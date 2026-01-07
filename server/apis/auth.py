from flask import Blueprint , request , jsonify
from bson.objectid import ObjectId
from werkzeug.security import generate_password_hash, check_password_hash

from tools.momgo_db_tools import user_collection

auth_bp = Blueprint('auth' , __name__)


@auth_bp.route('/signup', methods=["POST"])
def signup():
    data = request.get_json()

    if not data or 'username' not in data or 'password' not in data:
        return jsonify({'message': 'Missing fields'}), 400

    username = data['username'].strip()
    password = data['password']

    if user_collection.find_one({'username': username}):
        return jsonify({'message': 'User already exists'}), 409

    user_document = {
        'username': username,
        'password': generate_password_hash(password)
    }

    user_collection.insert_one(user_document)

    return jsonify({'message': 'Successfully signed up'}), 201

@auth_bp.route('/login', methods=["POST"])
def login():
    data = request.get_json()

    if not data or 'username' not in data or 'password' not in data:
        return jsonify({'message': 'Missing fields'}), 400

    user = user_collection.find_one({'username': data['username']})

    if not user:
        return jsonify({'message': 'Invalid credentials'}), 401

    if not check_password_hash(user['password'], data['password']):
        return jsonify({'message': 'Invalid credentials'}), 401

    return jsonify({
        'message': 'Login successful',
        'user_id': str(user['_id'])
    }), 200
