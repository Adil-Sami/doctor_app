import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/pharma_req_model.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class PharmaReqService {
  static const _viewUrl = "$apiUrl/get_pharma_bypid";
  static const _viewAllUrl = "$apiUrl/get_all_preq";
  static const _updateData = "$apiUrl/udpate_pharamareq_status";
  static const _addUrl = "$apiUrl/add_pharma_req";
  static const _deleteUrl = "$apiUrl/deleted_updated";

  static List<PharmacyReqModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PharmacyReqModel>.from(
        data.map((item) => PharmacyReqModel.fromJson(item)));
  }

  static Future<List<PharmacyReqModel>> getData() async {
    SharedPreferences preferences =await SharedPreferences.getInstance();
    final pharmaId=await preferences.getString("pharmaId")??"";
    final response =
    await http.post(Uri.parse(_viewUrl), body: {"pid": pharmaId});
    print(response.body);
    if (response.statusCode == 200) {
      List<PharmacyReqModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<PharmacyReqModel>> getAllData() async {

    final response =
    await http.post(Uri.parse(_viewAllUrl));
    if (response.statusCode == 200) {
      List<PharmacyReqModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future updateData(String status,String prId) async {
    print(status);
    print(prId);
    final response = await http.post(Uri.parse(_updateData),
        body: {"status":status,
        "prid":prId
        });
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future addData(PharmacyReqModel prescriptionModel) async {
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
    print(id);
    print(_deleteUrl);
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "pharma_request"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
