
import 'dart:convert';

PrescriptionModel prescriptionModelFromJson(String str) => PrescriptionModel.fromJson(json.decode(str));
String prescriptionModelToJson(PrescriptionModel data) => json.encode(data.toJsonAdd());


class PrescriptionModel {
  var prescription;
  var patientName; //fcm id
  var appointmentId;
  var appointmentTime;
  var appointmentDate;
  var appointmentName;
  var drName;
  var imageUrl;
  var id;
  var patientId;
  var userId;
  var uId;

  PrescriptionModel({
    this.appointmentTime,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentName,
    this.patientName,
    this.prescription,
    this.imageUrl,
    this.drName,
    this.id,
    this.patientId,
    this.userId,
  });

  factory PrescriptionModel.fromJson(Map<String,dynamic> json){
    return PrescriptionModel(
            appointmentTime: json['appointmentTime'],
      appointmentDate: json['appointmentDate'],
      appointmentId: json['appointmentId'],
      appointmentName: json['appointmentName'],
      prescription: json['prescription'],
      patientName: json['patientName'],
      imageUrl: json['imageUrl'],
      drName: json['drName'],
      id: json['id'].toString(),
      // userId: json['userId'].toString(),
      // uId: json['uId'].toString(),

    );
  }

  Map<String,dynamic> toJsonUpdate(){
    return {
      "prescription":this.prescription,
      "id":this.id,
      "drName":this.drName,
      "patientName":this.patientName,
      "imageUrl":this.imageUrl
    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentId":this.appointmentId,
      "patientId":this.patientId,
      "user_id":this.userId,
      "appointmentTime":this.appointmentTime,
      "appointmentDate":this.appointmentDate,
      "imageUrl":this.imageUrl,
      "appointmentName":this.appointmentName,
      "drName":this.drName,
      "patientName":this.patientName,
      "prescription":this.prescription,
    };
  }

}
