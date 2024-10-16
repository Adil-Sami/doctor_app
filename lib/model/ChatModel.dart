// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

import 'package:demoadmin/model/customOfferModel.dart';
import 'package:demoadmin/model/prescriptionModel.dart';

import 'lablistmodel.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({

    required this.st,
    required this.msg,
    required this.data,
  });

  int st;
  String msg;
  List<ChatClass> data;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    st: json["st"],
    msg: json["msg"],
    data: List<ChatClass>.from(json["data"].map((x) => ChatClass.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "st": st,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ChatClass {
  ChatClass({
    this.id,
    this.appointmentId,
    this.userListId,
    this.drprofileId,
    this.sender,
    this.type,
    this.message,
    this.status,
    this.foreignKey,
    this.prescription,
    this.labTest,
    this.customOffer,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic appointmentId;
  dynamic userListId;
  dynamic drprofileId;
  dynamic sender;
  dynamic type;
  dynamic message;
  dynamic status;
  dynamic foreignKey;
  PrescriptionModel? prescription;
  Lablistmodel? labTest;
  CustomOfferModel? customOffer;
  dynamic createdAt;
  dynamic updatedAt;

  factory ChatClass.fromJson(Map<String, dynamic> json) => ChatClass(
    id: json["id"],
    appointmentId: json["appointment_id"],
    userListId: json["userList_id"],
    drprofileId: json["drprofile_id"],
    sender: json["sender"],
    type: json["type"],
    message: json["message"],
    status: json["status"],
    foreignKey: json["foreign_key"],
    prescription: json["prescription"] == null ? null : PrescriptionModel.fromJson(json["prescription"]),
    labTest: json["lab_test"] == null ? null : Lablistmodel.fromJson(json["lab_test"]),
    customOffer: json["custom_offer"] == null ? null : CustomOfferModel.fromJson(json["custom_offer"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_id": appointmentId,
    "userList_id": userListId,
    "drprofile_id": drprofileId,
    "sender": sender,
    "type": type,
    "message": message,
    "status": status,
    "foreign_key": foreignKey,
    "prescription": prescription?.toJsonAdd(),
    "lab_test": labTest?.toJsonAdd(),
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };

}





