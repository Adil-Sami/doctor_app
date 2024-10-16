import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/doctTimeSlotModel.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/drProfielModel.dart';

class DrProfileService {
  static const _viewUrlByDeptId = "$apiUrl/get_drbydeptclinic";
  static const get_walkinde = "$apiUrl/get_walkinde";
  static const _viewUrl = "$apiUrl/get_drprofile";
  static const _getAllDoctorsURl = "$apiUrl/get_doctors";
  static const _viewUrlById = "$apiUrl/get_doct_by_id";
  static const _updateUrl = "$apiUrl/update_drprofile";
  static const _update = "$apiUrl/update_admin_fcm";
  static const _getAllDoctors = "$apiUrl/get_alldr";
  static const _deleteDoctAppType = "$apiUrl/deletDoctAppTye";
  static const _addDoctAppType = "$apiUrl/add_doctAppType";
  static const _deleteUrl = "$apiUrl/deleted_updated";
  static const _addUrl = "$apiUrl/add_doctors";
  static const _loginUrl = "$apiUrl/dr_login";
  static const _updateDoctFcm = "$apiUrl/update_doct_fcm";
  static const getPs = "$apiUrl/get_ioppass";
  static const updatelatlonUrl = "$apiUrl/update_dr_lat_long";
  static const doctTimeSlotUrl = "$apiUrl/get_doct_timelsot";
  static const addTimeSlotUrl = "$apiUrl/add_doct_timeslot";



  static List<DrProfileModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<DrProfileModel>.from(
        data.map((item) => DrProfileModel.fromJson(item)));
  }

  static List<DoctorTimeSlotModel> dataFromJsonTimeSlot(String jsonString) {
    final data = json.decode(jsonString);
    return List<DoctorTimeSlotModel>.from(
        data.map((item) => DoctorTimeSlotModel.fromJson(item)));
  }

  static addData(DrProfileModel drProfileModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: drProfileModel.toAddJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static addTimeSlot({
    required String time_slot,
    required String day_code,
    required String doct_id,
    required String slot_type,
  }) async {
    final res =
    await http.post(Uri.parse(addTimeSlotUrl), body: {
      "time_slot":time_slot,
      "day_code":day_code,
      "doct_id":doct_id,
      "slot_type":slot_type
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }


  static Future<List<DrProfileModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<DoctorTimeSlotModel>> getDoctTimeSlot(String doctId) async {
    final response = await http.get(Uri.parse("$doctTimeSlotUrl?doctId=$doctId"));
    if (response.statusCode == 200) {
      List<DoctorTimeSlotModel> list = dataFromJsonTimeSlot(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future getPass(String email) async {
    final response =
        await http.post(Uri.parse("$getPs"), body: {'email': email});
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      return "error"; //if any error occurs then it return a blank list
    }
  }

  static Future<List<DrProfileModel>> getDataById(
      String id, String clinicId, String cityId) async {
    final response = await http.get(Uri.parse(
        "$_viewUrlByDeptId?deptId=$id&clinicId=$clinicId&cityId=$cityId"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<DrProfileModel>> getWalkinDataById(
      String id, String clinicId, String cityId) async {
    final response = await http.get(Uri.parse(
        "$get_walkinde?deptId=$id&clinicId=$clinicId&cityId=$cityId"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future <List<DrProfileModel>>getDoctors() async {
    final response = await http.get(Uri.parse("$_getAllDoctorsURl"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<DrProfileModel>> getDataByDId(String doctId) async {
    final response = await http.get(Uri.parse("$_viewUrlById?doctId=$doctId"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<DrProfileModel>> getCredential(
      String email, String pass) async {
    print(_loginUrl);
    final response = await http
        .post(Uri.parse(_loginUrl), body: {"email": email, "pass": pass});
    print(response.body);
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(DrProfileModel drProfileModel) async {
    final res = await http.post(Uri.parse(_updateUrl),
        body: drProfileModel.toUpdateJson());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }



  static updateFcmId(String fcmId) async {
    final res = await http.post(Uri.parse("$_update"), body: {"fcmId": fcmId});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static  updateLongLat(String long,String lat, String doctId) async {
    final res = await http.post(Uri.parse("$updatelatlonUrl"),
        body: {"long": long,"lat":lat, "id": doctId});
    if (res.statusCode == 200) {
      return res.body;
    }
    else return "error";
  }

  static updateDoctFcmId(String fcmId, String doctId) async {
    print("dddddddddddd$doctId");
    final res = await http.post(Uri.parse("$_updateDoctFcm"),
        body: {"fcmId": fcmId, "id": doctId});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<DrProfileModel>> getAllDr(
      String clinicId, String cityId, String deptId) async {
    print(clinicId);
    print(cityId);
    print(deptId);
    final response = await http.get(Uri.parse(
        "$_getAllDoctors?clinicId=$clinicId &cityId=$cityId &deptId=$deptId"));
    if (response.statusCode == 200) {
      List<DrProfileModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static deleteDoctAppTypeData(String id) async {
    final res =
        await http.post(Uri.parse(_deleteDoctAppType), body: {"id": id});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }


  static addDoctType(data) async {
    final res = await http.post(Uri.parse(_addDoctAppType), body: data);
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static deleteData(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "drprofile"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static deleteDoctTimeSlot(String id) async {
    final res = await http
        .post(Uri.parse(_deleteUrl), body: {"id": id, "dbName": "doct_time_slots"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
