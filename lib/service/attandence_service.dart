import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demoadmin/model/attendance_model.dart';

class AttendanceService {
  static const _viewUrl = "$apiUrl/get_att_wcid";
  static const _addUrl = "$apiUrl/add_attend";
  static const _getReUrl = "$apiUrl/get_att_report";
  static List<AttendanceModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AttendanceModel>.from(
        data.map((item) => AttendanceModel.fromJson(item)));
  }


  static addData( taskId) async {

    SharedPreferences preferences=await SharedPreferences.getInstance();
    final workerId=preferences.getString("userId")??"";
    final res =
    await http.post(Uri.parse(_addUrl), body: {
      "worker_id": workerId,
      "task_id":taskId
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static Future<List<AttendanceModel>> getReportData(String firstDate,String lastDate,String workerID,String clinicId) async {
    final response = await http.get(Uri.parse("$_getReUrl?worker_id=$workerID&clinic_id=$clinicId&firstDate=$firstDate&lastDate=$lastDate"));
    if (response.statusCode == 200) {
      List<AttendanceModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AttendanceModel>> getData(workerId,clinciId) async {
    final response = await http.get(Uri.parse("$_viewUrl?worker_id=$workerId&clinic_id=$clinciId"));
    if (response.statusCode == 200) {
      List<AttendanceModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

}
