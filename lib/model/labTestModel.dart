
class LabTestModel{
  var id;
  var title;
  var subTitle;
  var imageUrl;
  var createdTimeStamp;
  var clinicId;
  var price;

  LabTestModel({
    this.imageUrl,
    this.title,
    this.id,
    this.subTitle,
    this.clinicId,
    this.createdTimeStamp,
    this.price,
  });

  factory LabTestModel.fromJson(Map<String,dynamic> json){
    return LabTestModel(
        title:json['test_name'],
        imageUrl: json['image_url'],
        clinicId: json['clinic_id'].toString(),
        subTitle: json['subTitle'],
        createdTimeStamp:json['created_time_stamp'],
        id: json['id'].toString(),
        price: json['price'].toString(),
    );
  }
  Map<String,dynamic> toJsonUpdate(){
    return {
      "id":this.id,
      "title":this.title,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "clinicId":this.clinicId,
      "price":this.price

    };

  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "title":this.title,
      "imageUrl":this.imageUrl,
      "subTitle":this.subTitle,
      "clinicId":this.clinicId,
      "price":this.price
    };

  }
}