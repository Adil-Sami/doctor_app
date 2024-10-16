

class AppointmentTypeModel{
  var title;
  var imageUrl;
  var forTimeMin;
  var subTitle;
  var id;
  var openingTime;
  var closingTime;
  var day;


  AppointmentTypeModel({
    this.title,
    this.imageUrl,
    this.forTimeMin,
    this.id,
    this.subTitle,
    this.openingTime,
    this.closingTime,
    this.day
  });

  factory AppointmentTypeModel.fromJson(Map<String,dynamic> json){
    return AppointmentTypeModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      forTimeMin:  int.parse(json['forTimeMin']),
        id: json['id'],
        subTitle:json['subTitle'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      day: json['day']
    );
  }
  Map<String, dynamic> toAddJson() {
    return {
      "title": this.title,
      "forTimeMin": (this.forTimeMin).toString(),
      "imageUrl": this.imageUrl,
      "subTitle":this.subTitle,
      "openingTime":this.openingTime,
      "closingTime":this.closingTime,
      "day":this.day
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      "title": this.title,
      "forTimeMin": (this.forTimeMin).toString(),
      "imageUrl": this.imageUrl,
      "id":this.id,
      "subTitle":this.subTitle,
      "openingTime":this.openingTime,
      "closingTime":this.closingTime,
      "day":this.day
    };
  }

}