
class UserModel{
  var firstName;
  var lastName;
  var uId;
  var city;
  var email;
  var fcmId;
  var imageUrl;
  var pNo;
  var searchByName;
  var age;
  var createdTimeStamp;
  var updateTimeStamp;
  var gender;
  var mrd;
  var phone;
  var id;

  String? amount;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.uId,
    this.city,
    this.email,
    this.fcmId,
    this.imageUrl,
    this.pNo,
    this.searchByName,
    this.age,
    this.createdTimeStamp,
    this.updateTimeStamp,
    this.gender,
    this.mrd,
    this.phone,
    this.amount


  });
  Map<String,dynamic> toJsonAdd(){
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "uId": this.uId, //firebase uid
      "city": this.city,
      "email": this.email,
      "fcmId": this.fcmId,
      "imageUrl": this.imageUrl,
      "pNo": this.pNo,
      "searchByName":this.searchByName,
      "age": this.age,
      "gender":this.gender,
      "phone":this.phone
    };

  }
  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      firstName:json['firstName'],
      lastName:json['lastName'],
      uId:json['uId'],
      id:json['id'],
      city:json['city'],
      email:json['email'],
      fcmId:json['fcmId'],
      imageUrl:json['imageUrl'],
      pNo:json['pNo'],
      searchByName:json['searchByName'],
      age:json['age'],
      createdTimeStamp: json['createdTimeStamp'],
      updateTimeStamp:json['updatedTimeStamp'],
        gender:json['gender'],
      mrd:json['mrd'],
      phone: json['pNo'],
        amount: json['amount']

    );
  }

  Map<String,dynamic> toUpdateJson(){
    return  {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "city": this.city,
      "age": this.age,
      "email": this.email,
      "imageUrl": this.imageUrl,
      "searchByName":this.searchByName,
      "uId": this.uId,
      "gender":this.gender,
      "mrd":this.mrd
    };

  }
}