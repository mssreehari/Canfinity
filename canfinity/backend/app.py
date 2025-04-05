from flask import Flask, request, jsonify

app = Flask(__name__)

chemo_sessions = []
medicine_reminders = []

@app.route('/add_chemo_session', methods=['POST'])
def add_chemo_session():
    data = request.json
    chemo_sessions.append(data)
    return jsonify({"message": "Chemo session added", "data": data}), 201

@app.route('/get_chemo_sessions', methods=['GET'])
def get_chemo_sessions():
    return jsonify(chemo_sessions)

@app.route('/add_medicine_reminder', methods=['POST'])
def add_medicine_reminder():
    data = request.json
    medicine_reminders.append(data)
    return jsonify({"message": "Medicine reminder added", "data": data}), 201

@app.route('/get_medicine_reminders', methods=['GET'])
def get_medicine_reminders():
    return jsonify(medicine_reminders)

if __name__ == '__main__':
    app.run(debug=True)
