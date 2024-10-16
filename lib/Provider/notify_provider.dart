import 'package:flutter/foundation.dart';

import '../model/ChatModel.dart';

class NotifyProvider with ChangeNotifier {
  // Map<int, List<ChatClass>> selected = {};

  List<ChatClass> ChatMessageNotify = [];
  // List<ChatClass> get selected => [..._selected];
  //

  void messageAdd(dynamic id,
      dynamic appointmentId,
      dynamic userListId,
      dynamic drprofileId,
      dynamic sender,
      dynamic type,
      dynamic message,
      dynamic status) {

    // if(!selected.containsKey(appointmentId)){
    //   selected[appointmentId] = [];
    // }
    //
    // for (var entry in selected.entries) {
    //   if(entry.key == appointmentId){
    //     print('asdasd');
    //     entry.value.add(ChatClass(
    //         id: id,
    //         appointmentId: appointmentId,
    //         userListId: userListId,
    //         drprofileId: drprofileId,
    //         sender: sender,
    //         type: type,
    //         message: message,
    //         status: status,
    //         createdAt: DateTime.now(),
    //         updatedAt: DateTime.now())
    //     );
    //   }
    // }


    // print(selected.length);
    ChatMessageNotify.add(ChatClass(
        id: id,
        appointmentId: appointmentId,
        userListId: userListId,
        drprofileId: drprofileId,
        sender: sender,
        type: type,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now())
    );
    // print(';notifyListeners()');
    // print(_selected.length);


    notifyListeners();

  }

  void remove(dynamic id,
      dynamic appointmentId,
      dynamic userListId,
      dynamic drprofileId,
      dynamic sender,
      dynamic type,
      dynamic message,
      dynamic status) {
    ChatMessageNotify.remove(ChatClass(
        id: id,
        appointmentId: appointmentId,
        userListId: userListId,
        drprofileId: drprofileId,
        sender: sender,
        type: type,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()));
    notifyListeners();
  }

  void messageEmpty(){
    ChatMessageNotify = [];
    notifyListeners();
  }
}
