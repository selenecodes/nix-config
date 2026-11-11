"""Forward OpenCode's stdio MCP connection to GitLab over authenticated mTLS."""

import logging
import os
import ssl
import sys

import anyio
import httpx2
import truststore
from mcp.client.streamable_http import streamable_http_client
from mcp.server.stdio import stdio_server
from mcp.shared.message import ClientMessageMetadata
from mcp_types import JSONRPCRequest, JSONRPCResponse


async def bridge(client, url):
    # V2 transports expect the session layer to stamp the negotiated version.
    # This transparent bridge forwards initialize rather than creating a session.
    protocol_version = None
    initialize_id = None

    async with (
        anyio.create_task_group() as lifetime,
        streamable_http_client(url, http_client=client) as (remote_read, remote_write),
        stdio_server() as (local_read, local_write),
    ):

        async def upstream():
            nonlocal initialize_id
            async for frame in local_read:
                if isinstance(frame, Exception):
                    raise frame
                message = frame.message
                if (
                    isinstance(message, JSONRPCRequest)
                    and message.method == "initialize"
                ):
                    initialize_id = message.id
                elif protocol_version:
                    frame.metadata = ClientMessageMetadata(
                        headers={"mcp-protocol-version": protocol_version}
                    )
                await remote_write.send(frame)
            lifetime.cancel_scope.cancel()

        async def downstream():
            nonlocal protocol_version
            async for frame in remote_read:
                if isinstance(frame, Exception):
                    raise frame
                message = frame.message
                if isinstance(message, JSONRPCResponse) and message.id == initialize_id:
                    protocol_version = message.result.get("protocolVersion")
                await local_write.send(frame)
            lifetime.cancel_scope.cancel()

        lifetime.start_soon(upstream)
        lifetime.start_soon(downstream)
        await anyio.sleep_forever()


def tls_context(cert):
    tls = truststore.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    tls.load_cert_chain(cert)
    return tls


async def main():
    token = os.environ.pop("GITLAB_PAT", "")
    if not token:
        raise ValueError("GITLAB_PAT is required; launch with opencode_gitlab")
    cert = os.environ.get("GITLAB_CLIENT_CERT", "")
    if not cert:
        raise ValueError(
            "GITLAB_CLIENT_CERT must point to a PEM certificate/private-key bundle"
        )

    async with httpx2.AsyncClient(
        verify=tls_context(cert),
        headers={"Authorization": f"Bearer {token}"},
        timeout=httpx2.Timeout(30, read=300),
    ) as client:
        await bridge(client, "https://gitlab.at.rws.nl/api/v4/mcp")


if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING, stream=sys.stderr)
    try:
        anyio.run(main)
    except Exception:  # noqa: BLE001 -- redact transport errors at the process boundary
        # Never dump HTTP headers, token values, or remote response bodies.
        print(
            "GitLab MCP bridge failed; check the PAT, PEM bundle, VPN and TLS trust.",
            file=sys.stderr,
        )
        sys.exit(1)
