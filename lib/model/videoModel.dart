class VideoModel{
  String? id;
  String? title;
  String? imageUrl;
  String? videoUrl;
  String? createdTimeStamp;

  VideoModel({
   this.imageUrl,
    this.title,
    this.id,
    this.createdTimeStamp,
    this.videoUrl
  });

  factory VideoModel.fromJson(Map<String,dynamic> json){
    return VideoModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      createdTimeStamp: json['createdTimeStamp'],

    );
  }
  Map<String,dynamic> toUpdateJson(){
    return {
      "id": this.id,
      "title": this.title,
      "imageUrl": this.imageUrl,
      "videoUrl": this.videoUrl,
    };

  }
  Map<String,dynamic> toAddJson(){
    return {
      "title": this.title,
      "imageUrl": this.imageUrl,
      "videoUrl": this.videoUrl,
    };

  }

}