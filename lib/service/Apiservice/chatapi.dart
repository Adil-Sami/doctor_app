// by hassan005004 team
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../model/ChatModel.dart';
import '../../model/PatientsendmessageModel.dart';
import 'dart:io';

import '../../model/prescriptionModel.dart';

class ChatApi {


  GetPatientMessages(dynamic appointment_id) async {
    final loginUrl = Uri.parse('$apiLaravelUrl/doctor/chat/index?appointment_id=${appointment_id}');
    final response = await http.get(loginUrl, headers: {},
      // 'email': email.toString(),
      // 'password': password.toString(),
    );


    print(response.statusCode.toString());
    print(response.body.toString());

    ChatModel model = chatModelFromJson(response.body);
    if(model.st == 1){
      return model.data;
    }else{
      return [];
    }
    // return json.decode(response.body);
  }

  Future<PatientsendmessageModel> PatinetSendMessage(
      dynamic appointment_id,
      dynamic userList_id,
      dynamic user_id,
      dynamic drprofile_id,
      dynamic sender,
      dynamic type,
      dynamic message,
      file, {
        prescriptionModel = null,
        labtestModel = null,
        customOfferModel = null,
  } ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$apiLaravelUrl/doctor/chat/store'));

    request.fields['appointment_id'] = appointment_id.toString();
    request.fields['userList_id'] = userList_id.toString();
    request.fields['user_id'] = user_id.toString();
    request.fields['drprofile_id'] = drprofile_id.toString();
    request.fields['sender'] = sender.toString();
    request.fields['type'] = type.toString();

    if(type == 1){
      // simple chat message
      request.fields['message'] = message;
    }

    if(type == 2){
      // simple audio message + no work
    }

    if(type == 3) {
      // send attachment
      request.files.add(http.MultipartFile('message', File(file.path).readAsBytes().asStream(), File(file.path).lengthSync(),
          filename: file.path.split("/").last));
    }

    if(type == 4) {
      // send images
      request.files.add(http.MultipartFile('message', File(file.path).readAsBytes().asStream(), File(file.path).lengthSync(),
          filename: file.path.split("/").last));
    }

    if(type == 5){
      // send location + no work for this
      request.fields['message'] = message;
    }

    if(type == 6){
      // send prescription
      request.fields['message'] = message;

      // send prescription data + to maintain old functionality
      dynamic map = prescriptionModel.toJsonAdd();
      map.forEach((k, v) => request.fields['prescription[$k]'] =  v);
    }

    if(type == 7){
      // send lab test
      request.fields['message'] = message;

      // send labtest data + to maintain old functionality
      dynamic map = labtestModel.toJsonAdd();
      map.forEach((k, v) => request.fields['labtest[$k]'] =  v);
    }

    if(type == 10){
      // send lab test
      request.fields['message'] = message;

      // send labtest data + to maintain old functionality
      dynamic map = customOfferModel.toJsonAdd();
      map.forEach((k, v) => request.fields['custom_offer[$k]'] =  v);
    }

    var response = await request.send();
    //
    // print(response.stream);
    print(response.statusCode);
    final respStr = await response.stream.bytesToString();
    PatientsendmessageModel model = patientsendmessageModelFromJson(respStr);
    return model;

    // return json.decode(response.body);
  }
}


