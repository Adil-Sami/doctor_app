
import 'package:cloud_firestore/cloud_firestore.dart';
class AddData {
  static Future<String> addRegisterDetails(uid) async {
    var sendData = {"uId": uid, "isAnyNotification": false};
    String res = "";
    await FirebaseFirestore.instance
        .collection('usersList')
        .doc(uid)
        .set(sendData)
        .then((value) {
      res = "success";
    }).catchError((onError) {
      print(onError);
      res = "error";
    });
    return res;
  }
  static Future<String> addNotiDetails(doctId) async {
    var sendData = {"isAnyNotification": false};
    String res = "";
    await FirebaseFirestore.instance
        .collection('doctorsNoti')
        .doc(doctId)
        .set(sendData)
        .then((value) {
      res = "success";
    }).catchError((onError) {
      print(onError);
      res = "error";
    });
    return res;
  }
  static Future<String> addPharmaDetails(pid) async {
    var sendData = {"isAnyNotification": false};
    String res = "";
    await FirebaseFirestore.instance
        .collection('pharma')
        .doc(pid)
        .set(sendData)
        .then((value) {
      res = "success";
    }).catchError((onError) {
      print(onError);
      res = "error";
    });
    return res;
  }
  static Future<String> addLabAttenderDetails(id) async {
    var sendData = {"isAnyNotification": false};
    String res = "";
    await FirebaseFirestore.instance
        .collection('labattender')
        .doc(id)
        .set(sendData)
        .then((value) {
      res = "success";
    }).catchError((onError) {
      print(onError);
      res = "error";
    });
    return res;
  }

}
