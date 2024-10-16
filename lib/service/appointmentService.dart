import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/token_model.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/appointmentModel.dart';

class AppointmentService {
  static const _viewUrl = "$apiUrl/get_all_appointment";
  static const _viewUrlPdf = "$apiUrl/get_all_appointment_pdf";
  static const _viewUrlPdfByClinicId = "$apiUrl/get_all_app_pdf_by_clinicid";
  static const _viewUrlByDoctID = "$apiUrl/get_app_by_doctorid";
  static const _viewUrlByClinicID = "$apiUrl/get_app_byclinicid";
  static const _getByUserUrl = "$apiUrl/get_appointment_by_Uid";
  static const _searchByNameUrl = "$apiUrl/search_by_name";
  static const _searchByIdUrl = "$apiUrl/search_by_id";
  static const _updateStatusUrl = "$apiUrl/update_appointment_status";
  static const _updateReschUrl = "$apiUrl/update_appointment_resch";
  static const _updateDataUrl = "$apiUrl/update_appointment";
  static const _addUrl = "$apiUrl/add_appointment";
  static const _updateGmeetUrl = "$apiUrl/update_gmeetLink";
  static const _checkUrl = "$apiUrl/check_app";
  static const _checkDrWalkinUrl = "$apiUrl/check_dr_walkin";
  static const _deleteTokenUrl = "$apiUrl/delete_token";
  static const _getTokenUrl = "$apiUrl/get_token";
  static const _addTokenUrl = "$apiUrl/add_token";
  static const _get_token_appid = "$apiUrl/get_token_appid";
  static const _addWalkinUrl = "$apiUrl/add_walkin_app";
  static const _checkPhnUrl = "$apiUrl/get_appp_by_phn";
  static const _checkPDUrl = "$apiUrl/check_app_perday";
  static const updateTokenUrl = "$apiUrl/update_token";
  static const getAllDateTokenUrl = "$apiUrl/get_all_token_date";
  static const updateTokenStatus = "$apiUrl/update_token_status";


  static List<AppointmentModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<AppointmentModel>.from(
        data.map((item) => AppointmentModel.fromJson(item)));
  }
  static Future getCheckPD(
      String doctId, String date,String isOnline) async {
    print("$_checkPDUrl?doctId=$doctId&date=$date&isOnline=$isOnline");
    final response = await http
        .get(Uri.parse("$_checkPDUrl?doctId=$doctId&date=$date&isOnline=$isOnline"));
    if (response.statusCode == 200) {
      final jsonRes=await jsonDecode(response.body);
      return jsonRes;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static List<TokenModel> dataFromJsonToekn(String jsonString) {
    final data = json.decode(jsonString);
    return List<TokenModel>.from(data.map((item) => TokenModel.fromJson(item)));
  }

  static Future<List<AppointmentModel>> getCheck(
      String doctId, String date, String time) async {
    final response = await http
        .get(Uri.parse("$_checkUrl?doctId=$doctId&time=$time&date=$date"));
    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }


  static Future<List<AppointmentModel>> getAppByPhn(
      String phn, String date) async {
    final response =
        await http.get(Uri.parse("$_checkPhnUrl?phn=$phn&date=$date"));
    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getDrWalkinCheck(
      String doctId, String date) async {
    final response = await http
        .get(Uri.parse("$_checkDrWalkinUrl?doctId=$doctId&date=$date"));
    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<TokenModel>> getAllTokenByDate(String date,String doctId) async {
    final response =
        await http.get(Uri.parse("$getAllDateTokenUrl?date=$date&doctId=$doctId"));
    if (response.statusCode == 200) {
      List<TokenModel> list = dataFromJsonToekn(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<TokenModel>> getToken(String doctId, String date) async {
    final response =
    await http.get(Uri.parse("$_getTokenUrl?doct_id=$doctId&date=$date"));
    if (response.statusCode == 200) {
      List<TokenModel> list = dataFromJsonToekn(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<TokenModel>> getTokenByAppId(String appid) async {
    final response =
        await http.get(Uri.parse("$_get_token_appid?app_id=$appid"));
    if (response.statusCode == 200) {
      List<TokenModel> list = dataFromJsonToekn(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static addToken(
      {required String doctId,
      required String appId,
      required String tokenNum,
      required String date,
      required String tokenType}) async {
    print("lllllllllllllllllllllll${doctId}");
    print("llllllllllllllllllappIdlllll${appId}");
    print("lllllllllllllllltokenNumlllllll${tokenNum}");
    print("llllllllllllllllltokenTypellllll${tokenType}");
    print("llllllllllllllllltokenTypellllll${date}");
    final res = await http.post(Uri.parse(_addTokenUrl), body: {
      "doctId": doctId,
      "appId": appId,
      "tokenNum": tokenNum,
      "tokenType": tokenType,
      "date": date
    });
    print("uuuuuuuuuuuuuuuuuuurrrrrrrrrrrrrrrr${res.body}");

    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateGmeet(String url, String id) async {
    final res = await http
        .post(Uri.parse(_updateGmeetUrl), body: {"gMeetLink": url, "id": id});
    // print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addData(AppointmentModel appointmentModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: appointmentModel.toJsonAdd());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static updateToken(String appId) async {
    final res =
    await http.post(Uri.parse(updateTokenUrl), body: {
      "appId":appId
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static updateTokenStatusData(String tokenId,String status) async {
    final res =
    await http.post(Uri.parse(updateTokenStatus), body: {
      "tokenId":tokenId,
      "status":status,
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }



  static addWalkinData(AppointmentModel appointmentModel) async {
    final res = await http.post(Uri.parse(_addWalkinUrl),
        body: appointmentModel.toJsonAdd());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<AppointmentModel>> getDataBYClinicId(List selectedStatus,
      String firstDate, String lastDate, int getLimit, String clinicId) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    // final typeRes = convertArrayToString(selectedType);
    final response = await http.get(Uri.parse("$_viewUrlByClinicID?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&clinicId=$clinicId"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getDataBYDoctId(
      List selectedStatus,
      //  List selectedType,
      String firstDate,
      String lastDate,
      int getLimit,
      String doctId) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    // final typeRes = convertArrayToString(selectedType);
    final response = await http.get(Uri.parse(
        "$_viewUrlByDoctID?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&doctId=$doctId"));

    if (response.statusCode == 200) {
      // print(response.body);
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getData(
      List selectedStatus,
      //  List selectedType,
      String firstDate,
      String lastDate,
      List doctList,
      int getLimit) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    var resDoct = convertArrayToString(doctList);
    // if(resDoct.length==0){
    //   resDoct=[];
    // }`doctId` IN ('".$array2."')
    // final typeRes = convertArrayToString(selectedType);
    print(firstDate);
    print(lastDate);
    print(
        "$_viewUrl?status=$res&doctList=$resDoct&firstDate=$firstDate&lastDate=$lastDate&limit=$limit");
    final response = await http.get(Uri.parse(
        "$_viewUrl?status=$res&doctList=$resDoct&firstDate=$firstDate&lastDate=$lastDate&limit=$limit"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getDataPdf(
      List selectedStatus,
      //  List selectedType,
      String firstDate,
      String lastDate,
      String doctId,
      int getLimit) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    print(
        "$_viewUrlPdf?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&doctId=$doctId");
    // final typeRes = convertArrayToString(selectedType);
    final response = await http.get(Uri.parse(
        "$_viewUrlPdf?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&doctId=$doctId"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getDataPdfByClinic(
      List selectedStatus,
      //  List selectedType,
      String firstDate,
      String lastDate,
      String clinicId,
      int getLimit) async {
    final limit = getLimit.toString();
    final res = convertArrayToString(selectedStatus);
    print(
        "$_viewUrlPdfByClinicId?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&clinicId=$clinicId");
    // final typeRes = convertArrayToString(selectedType);
    final response = await http.get(Uri.parse(
        "$_viewUrlPdfByClinicId?status=$res&firstDate=$firstDate&lastDate=$lastDate&limit=$limit&clinicId=$clinicId"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentByUser(
      String userId) async {
    final response = await http.get(Uri.parse("$_getByUserUrl?uid=$userId"));
    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentByName(
      String searchByName) async {
    final response = await http
        .get(Uri.parse("$_searchByNameUrl?db=appointments&name=$searchByName"));

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<AppointmentModel>> getAppointmentById(String id) async {
    print(id);

    final response = await http
        .get(Uri.parse("$_searchByIdUrl?db=appointments&idName=id&id=$id"));
    print(response.body);

    if (response.statusCode == 200) {
      List<AppointmentModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateData(AppointmentModel appointmentModel) async {
    print("${appointmentModel.toJsonUpdate()}");

    final res = await http.post(Uri.parse(_updateDataUrl),
        body: appointmentModel.toJsonUpdate());
    print(res.body);
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateStatus(AppointmentModel appointmentModel) async {
    final res = await http.post(Uri.parse(_updateStatusUrl),
        body: appointmentModel.toJsonUpdateStatus());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateDataResch(AppointmentModel appointmentModel) async {
    final res = await http.post(Uri.parse(_updateReschUrl),
        body: appointmentModel.toJsonUpdateResch());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static String convertArrayToString(List selectedStatus) {
    String res = "";

    for (int i = 0; i < selectedStatus.length; i++) {
      if (i == selectedStatus.length - 1) {
        res = res + selectedStatus[i];
      } else
        res = res + selectedStatus[i] + ",";
    }
    return res;
  }

  static deleteTokenData(String appid) async {
    final res = await http.post(Uri.parse(_deleteTokenUrl),
        body: {"appid": appid, "dbName": "clinic"});
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
}
