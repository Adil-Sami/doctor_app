
class PharmacyModel{
  var id;
  var title;
  var subTitle;
  var imageUrl;
  var cityName;
  var createdTimeStamp;
  var cityId;
  var email;
  var pass;

  PharmacyModel({
    this.imageUrl,
    this.title,
    this.id,
    this.subTitle,
    this.cityName,
    this.createdTimeStamp,
    this.cityId,
    this.pass,
    this.email
  });

  factory PharmacyModel.fromJson(Map<String,dynamic> json){
    return PharmacyModel(
        title:json['title'],
        imageUrl: json['image_url'],
        cityName: json['cityName'],
        subTitle: json['subTitle'],
        createdTimeStamp:json['created_time_stamp'],
        id: json['id'].toString(),
      email: json['email'],
      pass: json['pass'],
      cityId: json['city_id'].toString()
    );
  }
  Map<String,dynamic> toJsonUpdate(){
    return {
      "id":this.id,
      "title":this.title,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "cityId":this.cityId,
      "email":this.email,
      "pass":this.pass

    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "title":this.title,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "cityId":this.cityId,
      "email":this.email,
      "pass":this.pass
    };

  }
}