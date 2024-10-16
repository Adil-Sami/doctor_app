import 'package:demoadmin/model/user_new_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class CustomOfferProvider with ChangeNotifier{

  String? price;
  String? installments;
  String? everyXMonths;

  setPrice(String? val){
    price = val;
    notifyListeners();
  }

  setInstallments(String? val){
    installments = val;
    notifyListeners();
  }

  setEveryXMonths(String? val){
    everyXMonths = val;
    notifyListeners();
  }

}

