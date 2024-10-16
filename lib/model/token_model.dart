
class TokenModel{
  var tokenId;
  var tokenNum;
  var tokenType;
  var completed;


  TokenModel({
    this.tokenId,
    this.tokenNum,
    this.tokenType,
    this.completed
  });

  factory TokenModel.fromJson(Map<String,dynamic> json){
    return TokenModel(
        tokenId: json['token_id'].toString(),
      tokenNum: json['token_num'],
      tokenType: json['token_type'],
      completed: json['completed']
    );
  }


}