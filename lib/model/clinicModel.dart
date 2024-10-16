
class ClinicModel {
  var id;
  var title;
  var imageUrl;
  var location;
  var cityId;
  var locationName;
  var number_reveal;
  var cityName;
  var kt1;
  var kt2;
  var ktImage;

  ClinicModel({
    this.id,
    this.title,
    this.imageUrl,
    this.location,
    this.locationName,
    this.cityId,
    this.number_reveal,
    this.cityName,
    this.kt1,
    this.kt2,
    this.ktImage
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json){
    return ClinicModel(
      locationName: json['location_name'],
        imageUrl: json['imageUrl'],
        location: json['location'],
        title: json['title'],
        number_reveal: json['number_reveal'],
        id: json['id'].toString(),
        cityName: json['cityName'],
        cityId: json['city_id'].toString(),
      kt1: json['kiosk_t1'],
      kt2:  json['kiosk_t2'],
      ktImage:  json['kiosk_img'],

    );
  }
   Map<String, dynamic> toAddJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
      "cityId":this.cityId,
      "gUrl":this.location,
      "lName":this.locationName,
      "number_reveal":this.number_reveal
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "name": this.title,
      "imageUrl": this.imageUrl,
      "id":this.id,
      "gUrl":this.location,
      "cityId":this.cityId,
      "number_reveal":this.number_reveal

    };
  }

}