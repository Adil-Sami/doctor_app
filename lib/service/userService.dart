import 'dart:convert';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/wallet_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:demoadmin/model/userModel.dart';

class UserService {
  static const _viewUrl = "$apiUrl/get_all_user";
  static const _updateUrl = "$apiUrl/update_user";
  static const _updateMRDUrl = "$apiUrl/update_mrd";
  static const _searchByNameUrl = "$apiUrl/search_by_name";
  static const _searchByIdUrl = "$apiUrl/search_by_id";
  static const _getubyphnUrl = "$apiUrl/get_user_by_phn";
  static const _addUrl = "$apiUrl/add_users_walin";

  static const _addWalletUrl = "$apiUrl/add_wallet";
  static const _getWHUrl = "$apiUrl/get_user_wallet_history";
  static const _getWAHUrl = "$apiUrl/get_all_wallet_history";

  static List<UserModel> dataFromJson(String jsonString) {
    final data = json.decode(jsonString);
    return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
  }
  static List<UserWalletHistoryModel> dataFromJsonWallet(String jsonString) {
    final data = json.decode(jsonString);
    return List<UserWalletHistoryModel>.from(data.map((item) => UserWalletHistoryModel.fromJson(item)));
  }
  static addDataWallet({
    required String payment_id,
    required String amount,
    required String status,
    required String desc,
    required String prAmount,
    required String userId
  }) async {

    print({      "payment_id":payment_id,
      "uid":userId,
      "amount":amount,
      "desc":desc,
      "pr_amount":prAmount,
      "status":status});
    final res =
    await http.post(Uri.parse(_addWalletUrl), body: {
      "payment_id":payment_id,
      "uid":userId,
      "amount":amount,
      "desc":desc,
      "pr_amount":prAmount,
      "status":status
    });
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }
  static Future<List<UserWalletHistoryModel>> getWalletHistory(userId) async {
    print("$_getWHUrl?uid=$userId");
    final response =
    await http.get(Uri.parse("$_getWHUrl?uid=$userId"),);
    if (response.statusCode == 200) {

      List<UserWalletHistoryModel> list = dataFromJsonWallet(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<UserWalletHistoryModel>> getWalletAllHistory() async {
    print(_getWAHUrl);
    final response =
    await http.get(Uri.parse("$_getWAHUrl"),);
    if (response.statusCode == 200) {

      List<UserWalletHistoryModel> list = dataFromJsonWallet(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<UserModel>> getData() async {
    final response = await http.get(Uri.parse("$_viewUrl"));
    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<UserModel>> getDataByPhn(phn) async {
    final response =
        await http.post(Uri.parse("$_getubyphnUrl"), body: {"phn": phn});
    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static updateDataMRD({required String mrd, required String? uid}) async {
    final res = await http
        .post(Uri.parse(_updateMRDUrl), body: {"uid": uid, "mrd": mrd});
    print("Mmmmmmmmrrrrrrrddddd update status ${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static updateData(UserModel userModel) async {
    final res =
        await http.post(Uri.parse(_updateUrl), body: userModel.toUpdateJson());
    print(">>>>>>>>>$_updateUrl>>>>>>>>>>>>>${res.body}");
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static addData(UserModel appointmentModel) async {
    final res =
        await http.post(Uri.parse(_addUrl), body: appointmentModel.toJsonAdd());
    if (res.statusCode == 200) {
      return res.body;
    } else
      return "error";
  }

  static Future<List<UserModel>> getUserByName(String searchByName) async {
    final response = await http
        .get(Uri.parse("$_searchByNameUrl?db=userList&name=$searchByName"));

    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }

  static Future<List<UserModel>> getUserById(String id) async {
    final response = await http
        .get(Uri.parse("$_searchByIdUrl?db=userList&idName=uId&id=$id"));

    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
  static Future<List<UserModel>> getUserByuid(String id) async {
    final response = await http
        .get(Uri.parse("$_searchByIdUrl?db=userList&idName=id&id=$id"));

    if (response.statusCode == 200) {
      List<UserModel> list = dataFromJson(response.body);
      return list;
    } else {
      return []; //if any error occurs then it return a blank list
    }
  }
}
