import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/task_model.dart';
import 'package:http/http.dart' as http;

class TaskService {
  static const _viewUrl = "$apiUrl/get_task_by_clinic_id";
  static const _addUrl = "$apiUrl/add_task";
  static const _deleteUrl = "$apiUrl/";
  static const _updateUrl = "$apiUrl/";

  static List<TaskModel > dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<TaskModel>.from(
        data.map((item) => TaskModel.fromJson(item)));
  }

  static Future<List<TaskModel>> getData(String workerID) async {
    final response = await http.get(Uri.parse("$_viewUrl?clinic_id=$workerID"));
    if (response.statusCode == 200) {
      List<TaskModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }


  static addData(title, clinicId) async {
    final res =
    await http.post(Uri.parse(_addUrl), body: {
      "title":title,
      "clinic_id":clinicId
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "clinic"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(TaskModel clinicModel) async {
    print("${clinicModel.toUpdateJson()}");
    final res = await http.post(Uri.parse(_updateUrl),
        body: clinicModel.toUpdateJson());
    print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
