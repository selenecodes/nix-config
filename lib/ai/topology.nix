let
  vllmHost = "10.10.50.10";
  vllmPort = 8000;
  vllmUrl = "http://${vllmHost}:${toString vllmPort}";
in {
  bifrost = rec {
    url = "http://127.0.0.1:4000";
    baseUrl = "${url}/v1";
    mcpUrl = "${url}/mcp";
  };

  vllm = {
    host = vllmHost;
    port = vllmPort;
    url = vllmUrl;
    baseUrl = "${vllmUrl}/v1";
  };
}
