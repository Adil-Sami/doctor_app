import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/labTestModel.dart';
import 'package:http/http.dart' as http;

class LabTestService {
  static const _viewUrl = "$apiUrl/get_lab_test";
  static const _viewUrlById = "$apiUrl/get_labattenderbyid";
  static const _updateData = "$apiUrl/update_labtest";
  static const _addUrl = "$apiUrl/add_lab_test";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _loginUrl = "$apiUrl/lab_attender_login";
  static const _updatFcm = "$apiUrl/update_la_fcm";
  static List<LabTestModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<LabTestModel>.from(
        data.map((item) => LabTestModel.fromJson(item)));
  }

  static Future<List<LabTestModel>> getData(clinicId) async {
    print("$_viewUrl?clinicId=$clinicId");
    final response =
    await http.get(Uri.parse("$_viewUrl?clinicId=$clinicId"));
    if (response.statusCode == 200) {
      List<LabTestModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<LabTestModel>> getDataByApId(
      { String? pid}) async {

    final response = await http.post(Uri.parse(_viewUrlById),
        body: {"laid":pid});
    if (response.statusCode == 200) {
      List<LabTestModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future updateData(LabTestModel prescriptionModel) async {
    final response = await http.post(Uri.parse(_updateData),
        body: prescriptionModel.toJsonUpdate());
    print("%%%%%%%${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future addData(LabTestModel prescriptionModel) async {
    print(prescriptionModel.toJsonAdd());
    final response = await http.post(Uri.parse(_addUrl),
        body: prescriptionModel.toJsonAdd());
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "lab_test"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static Future<List<LabTestModel>> getCredential(
      String email, String pass) async {
    final response = await http
        .post(Uri.parse(_loginUrl), body: {"email": email, "pass": pass});
    if (response.statusCode == 200) {
      List<LabTestModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static updateFcmId(String fcmId, String id) async {
    print("update fcm id $fcmId");
    print("id $id");
    final res = await http.post(Uri.parse("$_updatFcm"),
        body: {"fcmId": fcmId, "id": id});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

}
