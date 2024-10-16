
class TaskModel {
  var id;
  var title;
  var clinicId;
  var createdTimeStamp;
  var updateTimeStamp;
  TaskModel({
    this.clinicId,
    this.id,
    this.createdTimeStamp,
    this.updateTimeStamp,
    this.title
  });

  factory TaskModel.fromJson(Map<String, dynamic> json){
    return TaskModel(
        title: json['title'],
        id: json['id'].toString(),
        createdTimeStamp: json['created_time_stamp'],
        clinicId:  json['clinic_id'].toString(),
        updateTimeStamp: json['updated_time_stamp']

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