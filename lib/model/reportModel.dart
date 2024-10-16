
class ReportModel{
  var title;
  var imageUrl;
   var id;
  var uid;

  ReportModel({
this.title,
    this.imageUrl,
    this.uid,
    this.id,
  });

  factory ReportModel.fromJson(Map<String,dynamic> json){
    return ReportModel(
      title: json['title'],
      id: json['id'].toString(),
      imageUrl: json['imageUrl']

    );
  }
  Map<String,dynamic> toJsonUpdate(){
    return {
      "uid":this.uid,
      "id":this.id,
      "title":this.title,
      "imageUrl":this.imageUrl
    };
  }
  Map<String,dynamic> toJsonAdd(){
    return {
      "title":this.title,
      "imageUrl":this.imageUrl,
      "uid":this.uid
    };
  }
}