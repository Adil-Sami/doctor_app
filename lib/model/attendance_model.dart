
class AttendanceModel {
  var id;
  var task_title;
  var time_stamp;
  var firstName;
  var lastName;
  var  end_time_stamp;
  AttendanceModel({
    this.id,
    this.task_title,
    this.time_stamp,
    this.lastName,
    this.firstName,
    this.end_time_stamp

  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json){
    return AttendanceModel(
        task_title: json['task_title'],
        id: json['id'].toString(),
        time_stamp: json['time_stamp'],
      lastName: json['last_name'],
      firstName: json['first_name'],
        end_time_stamp:json['end_time_stamp']

    );
  }
  Map<String, dynamic> toAddJson() {
    return {
      // "first_name": this.firstName,
      // "last_name": this.lastName,
      // "image_url":this.imageUrl,
      // "phone":this.phone,
      // "clinic_id":this.clinicId,
      // "gender":this.gender
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      // "id":workerId,
      // "first_name": this.firstName,
      // "last_name": this.lastName,
      // "image_url":this.imageUrl,
      // "phone":this.phone,
      // "gender":this.gender

    };
  }

}