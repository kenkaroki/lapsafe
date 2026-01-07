import datetime
from flask import Blueprint, request, jsonify
from tools.model_detection_tools import gemini_content_flagger
from tools.momgo_db_tools import reports_collection

process_content_bp = Blueprint("process_content", __name__)

@process_content_bp.route("/process_content/process_text", methods=["POST"])
def process_text():
    data = request.get_json()

    if not data or "text" not in data or "user_id" not in data:
        return jsonify({"status": "neutral"}), 400

    text = data["text"].strip()

    if not text:
        return jsonify({"status": "neutral"}), 200

    try:
        label = gemini_content_flagger(text=text, modes=data.get('modes', []))
    except Exception as e:
        print(e)
        label = "neutral"

    if label == 'hateful':
        reports_collection.insert_one({
            "user_id": data["user_id"],
            "text": text,
            "created_at": datetime.datetime.utcnow()
        })

    return jsonify({"status": label}), 200
