// by hassan005004

import 'package:demoadmin/model/labTestModel.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../model/ChatModel.dart';
import '../../model/PatientsendmessageModel.dart';
import 'dart:io';

import '../../model/lablistmodel.dart';
import '../../model/prescriptionModel.dart';

class LabTestApi {

  GetLabTest(dynamic lab_test_id) async {
    final loginUrl = Uri.parse('$apiLaravelUrl/doctor/labtest/show?id=${lab_test_id}');
    final response = await http.get(loginUrl, headers: {});

    Lablistmodel model = lablistmodelSingleFromJson(response.body.toString());
    if(response.statusCode == 200){
      return model;
    }else{
      return [];
    }
  }


}
