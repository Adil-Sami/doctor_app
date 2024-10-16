// To parse this JSON data, do
//
//     final patientsendmessageModel = patientsendmessageModelFromJson(jsonString);

import 'dart:convert';

PatientsendmessageModel patientsendmessageModelFromJson(String str) => PatientsendmessageModel.fromJson(json.decode(str));

String patientsendmessageModelToJson(PatientsendmessageModel data) => json.encode(data.toJson());

class PatientsendmessageModel {
  PatientsendmessageModel({
    required this.st,
    required this.msg,
    this.data,
  });

  int st;
  String msg;
  dynamic data;

  factory PatientsendmessageModel.fromJson(Map<String, dynamic> json) => PatientsendmessageModel(
    st: json["st"],
    msg: json["msg"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "st": st,
    "msg": msg,
    "data": data,
  };
}
