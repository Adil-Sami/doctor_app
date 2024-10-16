import 'package:demoadmin/model/user_new_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;


class UserProvider with ChangeNotifier{


  UserNewModel? data;

 userListPageNew() async{
   var request = http.Request('GET', Uri.parse('https://mydoctorjo.com/api/admin/users'));

   http.StreamedResponse response = await request.send();

   if (response.statusCode == 200) {
   data = userNewModelFromJson(await response.stream.bytesToString());
   }
   else {
     print(response.reasonPhrase);
   }
 }

}

