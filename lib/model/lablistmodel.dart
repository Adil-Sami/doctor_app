// To parse this JSON data, do
//
//     final lablistmodel = lablistmodelFromJson(jsonString);

import 'dart:convert';
// for sngle
Lablistmodel lablistmodelSingleFromJson(String str) => Lablistmodel.fromJson(json.decode(str));
String lablistmodelSingleToJson(Lablistmodel data) => json.encode(data.toJson());


// for list
List<Lablistmodel> lablistmodelFromJson(String str) => List<Lablistmodel>.from(json.decode(str).map((x) => Lablistmodel.fromJson(x)));
String lablistmodelToJson(List<Lablistmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Lablistmodel {
  int id;
  var appointmentId;
  var uId;
  var drId;
  var labName;
  dynamic image;
  var date;
  List<LabTestAttachment> labTestAttachments;

  Lablistmodel({
    required this.id,
    required this.appointmentId,
    required this.uId,
    required this.drId,
    required this.labName,
    this.image,
    required this.date,
    required this.labTestAttachments,
  });

  factory Lablistmodel.fromJson(Map<String, dynamic> json) => Lablistmodel(
    id: json["id"],
    appointmentId: json["appointment_id"],
    uId: json["u_id"],
    drId: json["dr_id"],
    labName: json["lab_name"],
    image: json["image"],
    date: DateTime.parse(json["date"]),
    labTestAttachments: json["lab_test_attachments"] == null ? [] : List<LabTestAttachment>.from(json["lab_test_attachments"].map((x) => LabTestAttachment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_id": appointmentId,
    "u_id": uId,
    "dr_id": drId,
    "lab_name": labName,
    "image": image,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "lab_test_attachments": List<dynamic>.from(labTestAttachments.map((x) => x.toJson())),
  };

  Map<String, dynamic> toJsonAdd() => {
    "id": id.toString(),
    "appointment_id": appointmentId.toString(),
    "u_id": uId.toString(),
    "dr_id": drId.toString(),
    "lab_name": labName.toString(),
    "image": image.toString(),
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    // "lab_test_attachments": List<dynamic>.from(labTestAttachments.map((x) => x.toJson())),
  };

}

class LabTestAttachment {
  String labTestId;
  String attachment;

  LabTestAttachment({
    required this.labTestId,
    required this.attachment,
  });

  factory LabTestAttachment.fromJson(Map<String, dynamic> json) => LabTestAttachment(
    labTestId: json["lab_test_id"],
    attachment: json["attachment"],
  );

  Map<String, dynamic> toJson() => {
    "lab_test_id": labTestId,
    "attachment": attachment,
  };
}
