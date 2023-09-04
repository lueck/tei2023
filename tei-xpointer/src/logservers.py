# USAGE:
# $ python3 logserver.py
# will start the server listening on localhost:8000

from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import parse_qs, urlparse
from functools import cached_property
import base64

class LogHandler(BaseHTTPRequestHandler):

    @cached_property
    def url(self):
        return urlparse(self.path)

    def do_GET(self):
        print(self.url.path)
        print(self.url.query)
        params = parse_qs(self.url.query)
        for p in params.get("base64", []):
            print(p)
            print(base64.b64decode(p))
        for p in params.get("plain", []):
            print(p)
        self.send_response(200)
        self.send_header("Content-Type", "application/xml")
        self.end_headers()
        self.wfile.write(str.encode("<b>true</b>", "UTF-8")) # return true

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8000), LogHandler)
    server.serve_forever()
