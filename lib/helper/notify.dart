import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

errorNotify(msg) {
  Get.snackbar(
    'Error',
    '',
    messageText: Text(
      msg,
      style: TextStyle(
        color: Colors.white
      ),
    ),
    colorText: Colors.white,
    backgroundColor: Colors.red,
    icon: const Icon(Icons.error_outline, color: Colors.white,),
  );
}

successNotify(msg){
  Get.snackbar(
    'Success',
    msg,
    messageText: Text(
      msg,
      style: TextStyle(
        color: Colors.white
      ),
    ),
    colorText: Colors.white,
    backgroundColor: Colors.green,
    icon: const Icon(Icons.check,color: Colors.white,),
  );
}

infoNotify(msg){
  Get.snackbar(
    'Info',
    msg,
    messageText: Text(
      msg,
    ),
    colorText: Colors.white,
    backgroundColor: Colors.blue,
    icon: const Icon(Icons.check,color: Colors.white,),
  );

  // Fluttertoast.showToast(
  //     msg: msg,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.CENTER,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.blue,
  //     textColor: Colors.white,
  //     fontSize: 16.0
  // );
}
