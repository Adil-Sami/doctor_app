import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/frontDeskModel.dart';

import 'package:http/http.dart' as http;

class FdService {
  static const _viewUrl = "$apiUrl/get_fd";
  static const _addUrl = "$apiUrl/add_fd";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _updateUrl = "$apiUrl/update_fd";
  static const _loginUrl = "$apiUrl/fd_login";
  static const _updateFcm = "$apiUrl/update_fd_fcm";

  static List<FrontDeskModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<FrontDeskModel>.from(
        data.map((item) => FrontDeskModel.fromJson(item)));
  }

  static Future<List<FrontDeskModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<FrontDeskModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addData(FrontDeskModel clinicModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: clinicModel.toAddJson());
    print("lolololollo${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  //
  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "front_desk"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(FrontDeskModel clinicModel) async {
    print("${clinicModel.toUpdateJson()}");
    final res = await http.post(Uri.parse(_updateUrl),
        body: clinicModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<FrontDeskModel>> getCredential(
      String email, String pass) async {
    print(_loginUrl);
    final response = await http
        .post(Uri.parse(_loginUrl), body: {"email": email, "pass": pass});
    if (response.statusCode == 200) {
      List<FrontDeskModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateFDFcmId(String fcmId, String doctId) async {
    print("dddddddddddd$doctId");
    final res = await http
        .post(Uri.parse("$_updateFcm"), body: {"fcmId": fcmId, "id": doctId});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
