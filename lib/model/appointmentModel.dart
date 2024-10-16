
import '../config.dart';

class AppointmentModel{
  var appointmentDate;
  var appointmentStatus;
  var appointmentTime;
  var pCity;
  var age;
  var pEmail;
  var pFirstName;
  var pLastName;
  var imageUrl;
  var serviceName;
  var serviceTimeMin;
  var uId;
  var userId;
  var pPhn;
  var description;
  var searchByName;
  var uName;
  var id;
  var createdTimeStamp;
  var updatedTimeStamp;
  var gender;
  var amount;
  var paymentMode;
  var oderId;
  var paymentDate;
  var paymentStatus;
  var isOnline;
  var gMeetLink;
  var deptId;
  var cityId;
  var clinicName;
  var cityName;
  var doctName;
  var doctId;
  var department;
  var hName;
  var  clinicId;
  var dateC;
  var walkin;
  var vByUser;

  AppointmentModel({

    this.appointmentDate,
    this.appointmentStatus,
    this.appointmentTime,
    this.pCity,
    this.age,
    this.pEmail,
    this.pFirstName,
    this.pLastName,
    this.imageUrl,
    this.serviceName,
    this.serviceTimeMin,
    this.uId,
    this.userId,
    this.pPhn,
    this.description,
    this.searchByName,
    this.uName,
    this.id,
    this.createdTimeStamp,
    this.updatedTimeStamp,
    this.gender,
    this.paymentStatus,
    this.paymentDate,
    this.amount,
    this.oderId,
    this.paymentMode,
    this.isOnline,
    this.gMeetLink,
    this.clinicName,
    this.cityName,
    this.doctName,
    this.doctId,
    this.department,
    this.hName,
    this.clinicId,
    this.deptId,
    this.cityId,
    this.dateC,
    this.walkin,
    this.vByUser

  });

  factory AppointmentModel.fromJson(Map<String,dynamic> json){
    return AppointmentModel(
      doctId: json['doctId'],
      appointmentDate:json['appointmentDate'],
      appointmentStatus:json['appointmentStatus'],
      appointmentTime:json['appointmentTime'],
      pCity:json['pCity'],
      age:json['age'],
      pEmail:json['pEmail'],
      pFirstName:json['pFirstName'],
      pLastName:json['pLastName'],
      imageUrl:json['imageUrl'] != '' && json['imageUrl'] != null ? json['imageUrl'] : '$webUrl/php/fixed/profile.webp',
      serviceName:json['serviceName'],
      serviceTimeMin:json['serviceTimeMin'],
      uId:json['uId'],
      userId:json['user_id'],

      pPhn:json['pPhn'],
      description:json['description'],
      searchByName:json['searchByName'],
      uName:json['uName'],
        id:json['id'],
        createdTimeStamp:json['createdTimeStamp'],
        updatedTimeStamp:json['updatedTimeStamp'],
      gender: json["gender"],
        amount: json['amount'],
        paymentMode:json['paymentMode'],
        oderId: json["orderId"],
        paymentDate:json['paymentDate'],
        paymentStatus: json['paymentStatus'],
        isOnline: json['isOnline'],
        gMeetLink:json['gmeetLink'],
        clinicName: json['title'],
        cityName: json['cityName'],
        doctName:json['doctName'],
      dateC: json['date_c'],
        walkin:json['walkin'],
      clinicId: json['clinicId'],
      vByUser: json['visited_by_user']
    );
  }
   Map<String,dynamic> toJsonUpdate(){
    return {
      "id":this.id,
      "pCity":this.pCity,
      "age":this.age,
      "pEmail":this.pEmail,
      "pFirstName":this.pFirstName,
      'pLastName':this.pLastName,
      "pPhn":this.pPhn,
      "description":this.description,
      "searchByName":this.searchByName,
      "gender":this.gender,

    };

  }
  Map<String,dynamic> toJsonUpdateStatus(){
    return {

      "appointmentStatus":this.appointmentStatus,
      "id":this.id,

    };

  }
  Map<String,dynamic> toJsonUpdateResch(){
    return {
      "appointmentStatus":this.appointmentStatus,
      "id":this.id,
      "appointmentDate":this.appointmentDate,
      "appointmentTime":this.appointmentTime,
      "date_c":this.dateC

    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "appointmentDate":this.appointmentDate,
      "appointmentStatus":this.appointmentStatus,
      "appointmentTime":this.appointmentTime,
      "pCity":this.pCity,
      "age":this.age,
      "pEmail":this.pEmail,
      "pFirstName":this.pFirstName,
      'pLastName':this.pLastName,
      "serviceName":this.serviceName,
      "serviceTimeMin":(this.serviceTimeMin).toString(),
      "uId":this.uId,
      "userId":this.userId,
      "pPhn":this.pPhn,
      "description":this.description,
      "searchByName":this.searchByName,
      "uName":this.uName,
      "gender":this.gender,
      "doctName":this.doctName,
      "department":this.department,
      "hName":this.hName,
      "doctId":this.doctId,
      "orderId":this.oderId,
      "paymentStatus":this.paymentStatus,
      "amount":this.amount,
      "paymentMode":this.paymentMode,
      "isOnline":this.isOnline,
      "clinicId":this.clinicId,
      "cityId":this.cityId,
      "deptId":this.deptId,
      "date_c":this.dateC

    };

  }
}
