from flask import Blueprint, request, jsonify
from models.report import Report

report_blueprint = Blueprint('report', __name__)

@report_blueprint.route('/reports', methods=['POST'])
def generate_report():
    data = request.get_json()
    user_id = data['userId']
    report_type = data['reportType']
    generated_date = data['generatedDate']

    report_id = Report.generate_report(user_id, report_type, generated_date)
    return jsonify({"message": "Report generated successfully", "reportId": report_id}), 201

@report_blueprint.route('/reports/<int:user_id>', methods=['GET'])
def get_reports(user_id):
    reports = Report.get_reports_by_user(user_id)
    return jsonify(reports), 200