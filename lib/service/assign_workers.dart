import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/assign_task_model.dart';
import 'package:http/http.dart' as http;

class AssignService {
  static const _viewUrl = "$apiUrl/get_task_by_worker_id";
  static const _addUrl = "$apiUrl/=";
  static const _assignUrl = "$apiUrl/assign_task";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/";


  static List<AssignTaskModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AssignTaskModel>.from(
        data.map((item) => AssignTaskModel.fromJson(item)));
  }

  static Future<List<AssignTaskModel>> getData(String workerID,String clinicId) async {


    final response = await http.get(Uri.parse("$_viewUrl?worker_id=$workerID&clinic_id=$clinicId"));
    if (response.statusCode == 200) {
      List<AssignTaskModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }



  static assignTask(task_id,worker_id) async {
    final res =
    await http.post(Uri.parse(_assignUrl), body: {
      "task_id":task_id,
      "worker_id":worker_id
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "assign_task"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(AssignTaskModel clinicModel) async {
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
