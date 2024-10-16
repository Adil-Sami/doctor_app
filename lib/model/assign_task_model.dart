
class AssignTaskModel {
  var id;
  var workerId;
  var title;
  var createdTimeStamp;
  var updateTimeStamp;
  AssignTaskModel({
    this.workerId,
    this.id,
    this.createdTimeStamp,
    this.updateTimeStamp,
    this.title
  });

  factory AssignTaskModel.fromJson(Map<String, dynamic> json){
    return AssignTaskModel(
        title: json['title'],
        id: json['id'].toString(),
        createdTimeStamp: json['created_time_stamp'],
        workerId:  json['worker_id'].toString(),
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