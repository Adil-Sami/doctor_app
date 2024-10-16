
class WorkerModel {
  var id;
  var workerId;
  var firstName;
  var lastName;
  var gender;
  var phone;
  var imageUrl;
var clinicId;
var createdTimeStamp;
var updateTimeStamp;
  WorkerModel({
    this.workerId,
    this.id,
this.firstName,
    this.lastName,
    this.phone,
    this.imageUrl,
    this.gender,this.clinicId,
    this.createdTimeStamp,
    this.updateTimeStamp
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json){
    return WorkerModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      imageUrl: json['image_url'],
      gender: json['gender'],
      id: json['id'].toString(),
      createdTimeStamp: json['created_time_stamp'],
        workerId:  json['worker_id'].toString(),
      updateTimeStamp: json['updated_time_stamp'],
      clinicId: json['clinic_id'].toString()

    );
  }
  Map<String, dynamic> toAddJson() {
    return {
      "first_name": this.firstName,
      "last_name": this.lastName,
      "image_url":this.imageUrl,
      "phone":this.phone,
      "clinic_id":this.clinicId,
      "gender":this.gender
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "id":workerId,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "image_url":this.imageUrl,
      "phone":this.phone,
      "gender":this.gender

    };
  }

}