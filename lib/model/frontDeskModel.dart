
class FrontDeskModel {
  var id;
  var firstName;
  var lastName;
  var imageUrl;
  var clinicName;
  var clinicId;
  var email;
  var pass;
  var lName;
  var cImageUrl;
  var kt1;
  var kt2;
  var ktImage;


  FrontDeskModel({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
    this.clinicId,
    this.email,
    this.pass,
    this.clinicName,
    this.lName,
    this.cImageUrl,
    this.kt2,
    this.kt1,
    this.ktImage
  });

  factory FrontDeskModel.fromJson(Map<String, dynamic> json){
    return FrontDeskModel(
      imageUrl: json['image_url'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      clinicId: json['clinic_id'].toString(),
      id: json['id'].toString(),
      email: json['email'],
      pass: json['pass'],
      clinicName: json['title'],
      lName: json['location_name'],
      cImageUrl: json['imageUrl']??"",
      kt1: json['kiosk_t1'],
      kt2:  json['kiosk_t2'],
      ktImage:  json['kiosk_img'],
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      "first_name": this.firstName,
      "imageUrl": this.imageUrl,
      "last_name":this.lastName,
      "clinicId":clinicId,
      "email":email,
      "pass":this.pass

    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
    "id":this.id,
      "first_name": this.firstName,
      "imageUrl": this.imageUrl,
      "last_name":this.lastName,
      "clinicId":clinicId,
      "email":email,
      "pass":this.pass,
    };
  }
}