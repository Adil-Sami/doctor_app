// To parse this JSON data, do
//
//     final userNewModel = userNewModelFromJson(jsonString);

import 'dart:convert';

UserNewModel userNewModelFromJson(String str) => UserNewModel.fromJson(json.decode(str));

String userNewModelToJson(UserNewModel data) => json.encode(data.toJson());

class UserNewModel {
  int st;
  String msg;
  List<Datum> data;

  UserNewModel({
    required this.st,
    required this.msg,
    required this.data,
  });

  factory UserNewModel.fromJson(Map<String, dynamic> json) => UserNewModel(
    st: json["st"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "st": st,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String? mrd;
  String firstName;
  String lastName;
  String amount;
  String uId;
  String city;
  String email;
  String fcmId;
  String imageUrl;
  String pNo;
  String phone;
  String searchByName;
  DateTime createdTimeStamp;
  DateTime updatedTimeStamp;
  String age;
  String gender;
  int parentUser;

  Datum({
    required this.id,
    required this.mrd,
    required this.firstName,
    required this.lastName,
    required this.amount,
    required this.uId,
    required this.city,
    required this.email,
    required this.fcmId,
    required this.imageUrl,
    required this.pNo,
    required this.phone,
    required this.searchByName,
    required this.createdTimeStamp,
    required this.updatedTimeStamp,
    required this.age,
    required this.gender,
    required this.parentUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    mrd: json["mrd"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    amount: json["amount"],
    uId: json["uId"],
    city: json["city"],
    email: json["email"],
    fcmId: json["fcmId"],
    imageUrl: json["imageUrl"],
    pNo: json["pNo"],
    phone: json["phone"],
    searchByName: json["searchByName"],
    createdTimeStamp: DateTime.parse(json["createdTimeStamp"]),
    updatedTimeStamp: DateTime.parse(json["updatedTimeStamp"]),
    age: json["age"],
    gender: json["gender"],
    parentUser: json["parent_user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mrd": mrd,
    "firstName": firstName,
    "lastName": lastName,
    "amount": amount,
    "uId": uId,
    "city": city,
    "email": email,
    "fcmId": fcmId,
    "imageUrl": imageUrl,
    "pNo": pNo,
    "phone": phone,
    "searchByName": searchByName,
    "createdTimeStamp": createdTimeStamp.toIso8601String(),
    "updatedTimeStamp": updatedTimeStamp.toIso8601String(),
    "age": age,
    "gender": gender,
    "parent_user": parentUser,
  };
}
