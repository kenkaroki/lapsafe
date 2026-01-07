from flask import Blueprint, jsonify
from bson.objectid import ObjectId
from tools.momgo_db_tools import reports_collection

retrive_reports_bp = Blueprint('retrive_reports', __name__)

@retrive_reports_bp.route('/get_reports/<user_id>', methods=["GET"])
def get_reports(user_id):

    cursor = reports_collection.find(
        {"user_id": user_id},
        {"_id": 0, "text": 1, "created_at": 1}
    )

    reports = []

    for r in cursor:
        reports.append([
            r["text"],
            r["created_at"].isoformat()
        ])

    return jsonify({"reports": reports}), 200

