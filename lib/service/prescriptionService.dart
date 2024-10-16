import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/prescriptionModel.dart';

import '../model/lablistmodel.dart';
import '../utilities/toastMsg.dart';

class PrescriptionService {
  static const _viewUrl = "$apiUrl/get_prescription";
  static const _viewUrlById = "$apiUrl/get_prescription_byid";
  static const _updateData = "$apiUrl/update_prescription";
  static const _addUrl = "$apiUrl/add_prescription";
  static const _deleteUrl = "$apiUrl/delete";

  static List<PrescriptionModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<PrescriptionModel>.from(
        data.map((item) => PrescriptionModel.fromJson(item)));
  }

  static Future<List<PrescriptionModel>> getData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final response =
        await http.post(Uri.parse(_viewUrl), body: {"uId": userId});
    print(response.body);
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<PrescriptionModel>> getDataByApId(
      {String? appointmentId, String? uid}) async {
    print(appointmentId);
    print(uid);

    final response = await http.post(Uri.parse(_viewUrlById),
        body: {"uId": uid, "appointmentId": appointmentId});
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<PrescriptionModel>> getDataByApIds(
      {String? appointmentId}) async {
    // print('id of user' + appointmentId.toString() );
    print('$apiLaravelUrl/doctor/prescription/index?appointment_id=${appointmentId}');
    final response = await http.get(Uri.parse('$apiLaravelUrl/doctor/prescription/index?appointment_id=${appointmentId}'));

        // body: {"appointmentId": appointmentId});
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<PrescriptionModel> list = dataFromJson(response.body);
      // print('list data');
      // print(list);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<Lablistmodel>> getLabTest(
      {String? appointmentId}) async {
    final response = await http.get(Uri.parse('$apiLaravelUrl/doctor/labtest/index?appointment_id=${appointmentId}'));

    // body: {"appointmentId": appointmentId});
    print("hassan");
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<Lablistmodel> list = lablistmodelFromJson(response.body);

      // print('list data');
      // print(list);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future updateData(PrescriptionModel prescriptionModel) async {
    final response = await http.post(Uri.parse(_updateData),
        body: prescriptionModel.toJsonUpdate());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future addData(PrescriptionModel prescriptionModel) async {
    final response = await http.post(Uri.parse(_addUrl),
        body: prescriptionModel.toJsonAdd());
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  Future AddLabReport(dynamic u_id, dynamic dr_id, dynamic lab_name,dynamic date,dynamic appointment_id) async {
    final loginUrl = Uri.parse('$apiLaravelUrl/doctor/labtest/store');
    final response = await http.post(loginUrl, headers: {}, body: {
      'u_id': u_id,
      'dr_id': dr_id,
      'lab_name': lab_name,
      'date': date,
      'appointment_id': appointment_id,

    });

    print(response.statusCode.toString());
    print(response.body.toString());
    if(response.body == 'success'){
      return ToastMsg.showToastMsg("Test suggested successfully");
    }
    else{
      ToastMsg.showToastMsg('ERROR');
    }
    // return json.decode(response.body);
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "db": "prescription"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
