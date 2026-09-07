let
  vllmHost = "10.10.50.10";
  vllmPort = 8000;
  vllmUrl = "http://${vllmHost}:${toString vllmPort}";
in {
  bifrost.baseUrl = "http://127.0.0.1:4000/v1";

  vllm = {
    host = vllmHost;
    port = vllmPort;
    url = vllmUrl;
    baseUrl = "${vllmUrl}/v1";
  };
}
