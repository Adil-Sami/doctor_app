
class CustomOfferModel{
  var id;
  var price;
  var installments;
  var everyXMonths;
  var userId;
  var uId;
  var chatId;
  var currentInstallment;

  CustomOfferModel({
    this.id,
    this.price,
    this.installments,
    this.everyXMonths,
    this.userId,
    this.uId,
    this.chatId,
    this.currentInstallment,
  });

  factory CustomOfferModel.fromJson(Map<String,dynamic> json){
    return CustomOfferModel(
        id:json['id'].toString(),
        price:json['price'],
        installments: json['installments'],
        everyXMonths: json['every_x_months'],
        userId: json['user_id'],
        uId: json['uId'],
        chatId: json['chat_id'],
        currentInstallment: json["current_installment"] == null ? null : CurrentInstallmentModel.fromJson(json["current_installment"]),

    );
  }

  Map<String, dynamic> toJsonAdd() => {
    "id": id.toString(),
    "price": price.toString(),
    "installments": installments.toString(),
    "every_x_months": everyXMonths.toString(),
    "user_id": userId.toString(),
    "uId": uId.toString(),
    "chat_id": chatId.toString(),
  };
}


class CurrentInstallmentModel{
  var customOfferInstallmentId;
  var price;

  CurrentInstallmentModel({
    this.customOfferInstallmentId,
    this.price,
  });

  factory CurrentInstallmentModel.fromJson(Map<String,dynamic> json){
    return CurrentInstallmentModel(
      customOfferInstallmentId:json['custom_offer_installment_id'].toString(),
      price:json['price'],
    );
  }
}
