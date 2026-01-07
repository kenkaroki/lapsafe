from flask import Flask, jsonify
from flask_cors import CORS

from apis.process_text import process_content_bp
from apis.retrive_records import retrive_reports_bp
from apis.auth import auth_bp

app = Flask(__name__)
CORS(app)

app.register_blueprint(process_content_bp)
app.register_blueprint(retrive_reports_bp)
app.register_blueprint(auth_bp)

@app.route('/', methods=["GET"])
def base_route():
    return jsonify({"status": "server is running"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
