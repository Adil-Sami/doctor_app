import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/workerModel.dart';

import 'package:http/http.dart' as http;

class WorkerService {
  static const _viewUrl = "$apiUrl/get_worker_by_clinic_id";
  static const _addUrl = "$apiUrl/add_worker";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/update_worker";
  static const _getubyphnUrl = "$apiUrl/get_worker_by_phone";
  static const _addUrlWorkerSync = "$apiUrl/sync_worker";

  static List<WorkerModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<WorkerModel>.from(
        data.map((item) => WorkerModel.fromJson(item)));
  }
  static Future<List<WorkerModel>> getDataByPhn(phn) async {
    final response =
    await http.post(Uri.parse("$_getubyphnUrl"), body: {"phn": phn});
    if (response.statusCode == 200) {
      List<WorkerModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<WorkerModel>> getData(String clinicId) async {
    final response = await http.get(Uri.parse("$_viewUrl?clinicId=$clinicId"));
    if (response.statusCode == 200) {
      List<WorkerModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }


  static addData(WorkerModel workerModel) async {
    final res =
    await http.post(Uri.parse(_addUrl), body: workerModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static addDataWorkerSync({clinicId,workerId}) async {
    final res =
    await http.post(Uri.parse(_addUrlWorkerSync), body: {
      "worker_id":workerId,
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

  static updateData(WorkerModel clinicModel) async {
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
