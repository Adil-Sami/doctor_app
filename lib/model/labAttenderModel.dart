
class LabAttenderModel{
  var id;
  var name;
  var clinicName;
  var subTitle;
  var imageUrl;
  var createdTimeStamp;
  var clinicID;
  var email;
  var pass;

  LabAttenderModel({
    this.imageUrl,
    this.clinicName,
    this.name,
    this.id,
    this.subTitle,
    this.clinicID,
    this.createdTimeStamp,
    this.pass,
    this.email
  });

  factory LabAttenderModel.fromJson(Map<String,dynamic> json){
    return LabAttenderModel(
      clinicName: json['tiitle'],
        name:json['name'],
        imageUrl: json['image_url'],
        clinicID: json['clinic_id'].toString(),
        subTitle: json['subTitle'],
        createdTimeStamp:json['created_time_stamp'],
        id: json['id'].toString(),
        email: json['email'],
        pass: json['pass'],
    );
  }
  Map<String,dynamic> toJsonUpdate(){
    return {
      "id":this.id,
      "name":this.name,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "email":this.email,
      "pass":this.pass

    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "name":this.name,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "clinicId":this.clinicID,
      "email":this.email,
      "pass":this.pass
    };

  }
}