XUI_HOSTNAME = "<xui.example.com>"  // X-UI dashboard URL (Exclude port and protocol)
XUI_PROTOCOL = "https"              // Force TLS. Options: http, https
XUI_INBOUND_PORT = 443;             // X-UI Inbound port. Options: 80, 443, 2052, 2053, 2082, 2083, 2086, 2087, 2095, 2096, 8080, 8443, 8880

addEventListener(
  "fetch", event => {
    let url = new URL(event.request.url);

    url.hostname = XUI_HOSTNAME;
    url.protocol = XUI_PROTOCOL;
    url.port = XUI_INBOUND_PORT;

    event.respondWith(
        fetch(new Request(url, event.request))
    )
  }
)
