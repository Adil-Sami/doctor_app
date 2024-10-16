import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/adminNotificationModel.dart';

class AdminNotificationService {
  static const _viewUrl = "$apiUrl/get_admin_notification";
  static const _viewUrlByDoctId = "$apiUrl/get_admin_noti_by_doctid";
  static const _viewUrlBypId = "$apiUrl/get_admin_npid";
  static const _viewUrlBylaId = "$apiUrl/get_admin_naid";

  static List<AdminNotificationModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AdminNotificationModel>.from(
        data.map((item) => AdminNotificationModel.fromJson(item)));
  }
  static Future<List<AdminNotificationModel>> getDataByPharmaId(
      int getLimit, String pid) async {
    String limit = getLimit.toString();
    print("$_viewUrlBypId?limit=$limit&id$pid");

    final response =
    await http.get(Uri.parse("$_viewUrlBypId?limit=$limit&id="
        "$pid"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<AdminNotificationModel>> getDataByLabAttenderId(
      int getLimit, String id) async {
    String limit = getLimit.toString();
    print("$_viewUrlBypId?limit=$limit&id$id");

    final response =
    await http.get(Uri.parse("$_viewUrlBylaId?limit=$limit&id="
        "$id"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<AdminNotificationModel>> getData(int getLimit) async {
    String limit = getLimit.toString();

    final response = await http.get(Uri.parse("$_viewUrl?limit=$limit"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AdminNotificationModel>> getDataByDoctId(
      int getLimit, String doctId) async {
    String limit = getLimit.toString();
    print("$_viewUrlByDoctId?limit=$limit&id$doctId");

    final response =
        await http.get(Uri.parse("$_viewUrlByDoctId?limit=$limit&id="
            "$doctId"));
    if (response.statusCode == 200) {
      List<AdminNotificationModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

// static addData(NotificationModel notificationModel)async{
  //   print(notificationModel.routeTo);
  //   final res=await http.post(Uri.parse(_addUrl),body:notificationModel.toJsonAdd());
  //   if(res.statusCode==200){
  //     return res.body;
  //   }
  //   else return "error";
  //
  // }

}
