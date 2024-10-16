// new file created + hassan005004
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoadmin/helper/extensions/date_time.dart';
import 'package:demoadmin/helper/extensions/string.dart';
import 'package:demoadmin/screens/appointmentScreen/chat/labDetail.dart';
import 'package:demoadmin/screens/appointmentScreen/chat/partils/message_screen_loader.dart';
import 'package:demoadmin/service/prescriptionService.dart';
import 'package:dio/dio.dart' as dios;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/model/prescriptionModel.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../Provider/custom_offer_provider.dart';
import '../../../Provider/notify_provider.dart';
import '../../../Service/appointmentService.dart';
import '../../../Service/notificationService.dart';
import '../../../helper/notify.dart';
import '../../../model/ChatModel.dart';
import '../../../model/appointmentModel.dart';
import '../../../model/customOfferModel.dart';
import '../../../model/labTestModel.dart';
import '../../../model/lablistmodel.dart';
import '../../../service/Apiservice/chatapi.dart';
import '../../../service/readData.dart';
import '../../../widgets/errorWidget.dart';
import '../../../widgets/loadingIndicator.dart';
import '../../../widgets/noDataWidget.dart';
import '../chooseTimeSlotsPage.dart';
import '../editAppointmetDetailsPage.dart';
import '../resWalkinChooseRimeSlotsPage.dart';
import 'chat_cards/message_card_loader.dart';
import 'partils/OwnMessgaeCrad.dart';
import '../../prescription/editprescriptionDetails.dart';
import '../../videocall.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatScreen extends StatefulWidget {
  final appointmentDetails;
  String? doctorId;
  String? doctorName;
  String? userId;
  String? uId;
  ChatScreen(this.appointmentDetails, this.doctorId, this.doctorName, this.userId, this.uId, {Key? key}) : super(key: key);
  // final ChatModell? chatModel;
  // final ChatModell? sourchat;


  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showEmoji = false;
  int _groupValue = -1;

  FocusNode focusNode = FocusNode();
  bool sendButton = true;
  List<ChatClass> chatmessages = [];
  ValueNotifier<int> chatmessagesNotifier = ValueNotifier<int>(0);
  // List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  // for loader
  bool _isLoading = false;
  ValueNotifier<bool> _isLoadingChat = ValueNotifier<bool>(true);

  String chatUniqueId = '0';
  String doctorId = '0';
  String userId = '0';
  String doctorName = '0';
  String uId = '0';
  String pEmail = '';

  // IO.Socket socket;

  @override
  void initState() {
    super.initState();
    // connect();

    // for api
    // apiGetMessages();

    focusNode.addListener(() {
      print("hassan 12");
      // if (focusNode.hasFocus) {
        print("hassan 1");
        setState(() {
          showEmoji = false;
        });
      // }
    });

    // if(widget.appointmentDetails != null){
    //   chatUniqueId = widget.appointmentDetails!.id.toString();
    //   doctorId = widget.appointmentDetails!.doctId.toString();
    //   userId = widget.userId.toString();
    //   doctorName = widget.appointmentDetails!.doctName.toString();
    //   uId = widget.appointmentDetails!.uId.toString();
    // }else{
      chatUniqueId = '${widget.userId}${widget.doctorId}';
      doctorId = widget.doctorId.toString();
      userId = widget.userId.toString();
      doctorName = widget.doctorName.toString();
      uId = widget.uId.toString();
    // }

    setState((){

    });
    // for api
    // setChatScreen();

    // _scrollController.addListener(_scrollDown);
  }

  void dispose(){
    // for api
    // unSetChatScreen();
    super.dispose();
  }

  // for api
  // setChatScreen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("isChatScreen", true);
  // }

  // for api
  // unSetChatScreen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("isChatScreen", false);
  // }


  // for api
  // apiGetMessages() async {
  //   chatmessages = await ChatApi().GetPatientMessages(widget.appointmentDetails.id.toString());
  //   chatmessagesNotifier.value = 1;
  //   Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
  //     // EasyLoading.dismiss();
  //     _scrollDown();
  //   }));
  // }

  List _imageUrls = [];

  // for api
  // void setchatmessage(dynamic message, dynamic type) {
  //   ChatClass messageModel = ChatClass(
  //       drprofileId: widget.appointmentDetails!.doctId,
  //       appointmentId: widget.appointmentDetails!.id,
  //       userListId: widget.appointmentDetails!.uId.toString(),
  //       sender: '2',
  //       type: type,
  //       message: message,
  //       createdAt: DateTime.now());
  //
  //   chatmessages.add(messageModel);
  //   chatmessagesNotifier.value = 1;
  //
  // }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 70,
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  final imagePicker = ImagePicker();
  late File imageFile;

  void getImage() async {
    PickedFile? image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image!.path);
    });

    // for api
    // setchatmessage(image!.path, '3');

    Navigator.pop(context);
    _isLoadingChat.value = true;

    await ChatApi().PatinetSendMessage(
        chatUniqueId.toString(),
        uId.toString(),
        userId.toString(),
        doctorId.toString(),
        2,
        4,
        '',
        image);
  }

  void getImagecamera() async {
    PickedFile? image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image!.path);
    });

    // for api
    // setchatmessage(image!.path, '4');

    Navigator.pop(context);
    _isLoadingChat.value = true;

    await ChatApi().PatinetSendMessage(
        chatUniqueId.toString(),
        uId.toString(),
        userId.toString(),
        doctorId.toString(),
        2,
        4,
        '',
        image);
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // for api
      // setState(() {
      //   setchatmessage(file!.path, '3');
      // });

      Navigator.pop(context);
      _isLoadingChat.value = true;

      await ChatApi().PatinetSendMessage(
          chatUniqueId.toString(),
          uId.toString(),
          userId.toString(),
          doctorId.toString(),
          2,
          3,
          '',
          file);
    } else {
      // print('No file selected');
    }
  }

  TextEditingController _messageController = TextEditingController();

  bool _isUploading = false;
  bool _isEnableBtn = true;
  File? _file;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: appBarColor,
              leadingWidth: 50,
              titleSpacing: 0,
              leading: IconButton(
                padding: EdgeInsets.only(left:5,right:5),
                constraints: BoxConstraints(),
                splashRadius: 30,
                icon: Icon(
                  Icons.arrow_back,
                  size: 24,
                ), onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    /*CircleAvatar(
                      backgroundImage: NetworkImage(widget.appointmentDetails.imageUrl),
                      radius: 22,
                      backgroundColor: Colors.blueGrey,
                    ),*/
                    /*Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Container(
                        margin: EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.appointmentDetails!.pFirstName,
                              style: TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.appointmentDetails.serviceName.toString(),
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.only(left:5,right:5),
                  constraints: BoxConstraints(),
                  splashRadius: 22,
                  icon: Icon(Icons.videocam),
                  onPressed: () async {
                    _isLoadingChat.value = true;
                    await ChatApi().PatinetSendMessage(
                        chatUniqueId.toString(),
                        uId.toString(),
                        userId.toString(),
                        doctorId,
                        2,
                        8,
                        "Call",
                        null);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Meeting(
                          uid: uId,
                          doctid: doctorId,
                          email: pEmail,
                        )
                      ),
                    );
                  },
                ),

                /*IconButton(
                  padding: EdgeInsets.only(left:5,right:5),
                  constraints: BoxConstraints(),
                  splashRadius: 22,
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {

                          if(widget.appointmentDetails!.description != '')
                            return Container(
                            color: Colors
                                .transparent, //could change this to Color(0xFF737373),
                            //so you don't have to change MaterialApp canvasColor
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10.0),
                                        topRight:
                                        const Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    widget.appointmentDetails!.description,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                )),
                          );
                          else
                            return Container(
                              color: Colors.transparent, //could change this to Color(0xFF737373),
                              //so you don't have to change MaterialApp canvasColor
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                          const Radius.circular(10.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text("Patient did not describe",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                            );
                        });
                  },
                ),*/

                IconButton(
                  padding: EdgeInsets.only(left:5,right:5),
                  constraints: BoxConstraints(),
                  splashRadius: 22,
                  icon: Icon(Icons.medication),
                  onPressed: () {
                    AppointmentChatModal.prescriptionModal(context, chatUniqueId);
                  },
                ),

                IconButton(
                  padding: EdgeInsets.only(left:5,right:0),
                  constraints: BoxConstraints(),
                  splashRadius: 22,
                  icon: Icon(Icons.medical_services),
                  onPressed: () {
                    AppointmentChatModal.labModal(
                        context, chatUniqueId);
                  },
                ),

                // InkWell(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => Meeting(
                //                   uid: widget.appointmentDetails!.uId,
                //                   doctid: widget.appointmentDetails!.doctId,
                //                   email: widget.appointmentDetails!.pEmail,
                //                 )),
                //       );
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: Icon(Icons.videocam),
                //     )),

                // InkWell(
                //     onTap: () {
                //       showModalBottomSheet(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //           backgroundColor: Colors.white,
                //           context: context,
                //           builder: (context) {
                //             return Container(
                //               color: Colors
                //                   .transparent, //could change this to Color(0xFF737373),
                //               //so you don't have to change MaterialApp canvasColor
                //               child: Container(
                //                   decoration: BoxDecoration(
                //                       color: Colors.white,
                //                       borderRadius: BorderRadius.only(
                //                           topLeft: const Radius.circular(10.0),
                //                           topRight:
                //                           const Radius.circular(10.0))),
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(12.0),
                //                     child: Text(
                //                       widget.appointmentDetails!.description,
                //                       style: TextStyle(
                //                         color: Colors.black,
                //                         fontWeight: FontWeight.normal,
                //                         fontSize: 16,
                //                       ),
                //                     ),
                //                   )),
                //             );
                //           });
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: Icon(Icons.info_outline),
                //     )),
                // InkWell(
                //     onTap: () {
                //       AppointmentChatModal.prescriptionModal(
                //           context, widget.appointmentDetails.id);
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: Icon(Icons.medication),
                //     )),
                // InkWell(
                //     onTap: () {
                //       AppointmentChatModal.labModal(
                //           context, widget.appointmentDetails.id);
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(5.0),
                //       child: Icon(Icons.medical_services),
                //     )),
                // SizedBox(width:10),

                PopupMenuButton(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    if(value == "appointment_detail"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAppointmentDetailsPage(
                              appointmentDetails: widget.appointmentDetails),
                        ),
                      );
                    }else if(value == "status_change"){
                      updateStatus();
                    }
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("Appointment Detail"),
                        value: "appointment_detail",
                      ),
                      PopupMenuItem(
                        child: Text("Status Change"),
                        value: "status_change",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Consumer<NotifyProvider>(builder: (ctx,value,child){
            // print(ctx);
            // print(value.selected.length);
            // print('value.selected.length');

            if(value.ChatMessageNotify.length >= 1){
              for(int i = 0; i< value.ChatMessageNotify.length; ++i){
                chatmessages.add(value.ChatMessageNotify[i]);
                chatmessagesNotifier.value = 1;
              }
              value.messageEmpty();
            }

            return  Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WillPopScope(
                child: Stack(
                  children: [

                    // FutureBuilder(
                    //   future: messages,
                    //   builder: (context, AsyncSnapshot<ChatModel> snapshot) {
                    //     if (snapshot.hasData) {
                    //
                    //
                    //       return


                    // for firebase
                    Container(
                      height: MediaQuery.of(context).size.height - 145 - 40,
                      margin: EdgeInsets.only(bottom: 70),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: StreamBuilder(
                            stream: ReadData.fetchMessagesStream(chatUniqueId).orderByChild('time').onValue,
                            builder: (context, snapshot) {

                              if (snapshot.hasData && !snapshot.hasError) {
                                _isLoadingChat.value = false;

                                DatabaseEvent databaseEvent = snapshot.data as DatabaseEvent; // 👈 Get the DatabaseEvent from the AsyncSnapshot
                                var databaseSnapshot = databaseEvent.snapshot; // 👈 Get the DataSnapshot from the DatabaseEvent

                                if(databaseSnapshot.value != null){
                                  Map<dynamic, dynamic> map = databaseSnapshot.value as Map<dynamic, dynamic>;

                                  // List<ChatClass> chat = map.values.toList() as List<ChatClass>;
                                  // print('Snapshossst4: ${databaseSnapshot.value}');
                                  // List<Chat> list = map.values.toList();
                                  // List<ChatClass> list = List<ChatClass>.from(map.values.toList().map((x) => ChatClass.fromJson(x)));

                                  List _list = map.values.toList();
                                  List<dynamic> list = _list..sort((a, b) => a['time'].compareTo(b['time']));

                                  List<ChatClass> chat_class_list = [];
                                  for(int i = 0; i < list.length; ++i){
                                    ChatClass chat = ChatClass.fromJson(jsonDecode(jsonEncode(list[i])));
                                    chat_class_list.add(chat);
                                  }

                                  _scrollDown();

                                  return Expanded(
                                    child: Column(
                                      children: [
                                        for(int i = 0; i < chat_class_list.length; ++i)
                                          // Text(chat_class_list[i].createdAt)
                                          OwnMessageCard(
                                              data: chat_class_list[i],
                                              appointmentDetails: widget.appointmentDetails,
                                              uId: uId,
                                              doctId: doctorId,
                                              pEmail: pEmail,
                                          ),

                                        // if(_isLoadingChat.value == true)
                                        ValueListenableBuilder(
                                          valueListenable: _isLoadingChat,
                                          builder: (context, value, _) {
                                            _scrollDown();
                                            if(_isLoadingChat.value == true) {
                                              return MessageCardShimmer(senderColor, Alignment.centerRight);
                                            } else {
                                              return Center();
                                            }
                                          }
                                        )
                                      ]
                                    )
                                  );
                                }else{
                                  return Container(
                                    height: MediaQuery.of(context).size.height - 160,
                                    child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.no_cell, size:45, color: Colors.grey),
                                            SizedBox(height:20),
                                            Text('Be the first to start communicate',
                                              style: TextStyle(
                                                  color: Colors.grey
                                              )
                                            ),
                                          ],
                                        )
                                    ),
                                  );
                                }
                              }else{
                                return MessageScreenShimmer();
                              }
                        }),
                      ),
                    ),

                    // for api
                    /*Container(
                      height: MediaQuery.of(context).size.height - 170,
                      margin: EdgeInsets.only(bottom: 70),
                      child: ValueListenableBuilder(
                        valueListenable: chatmessagesNotifier,
                        builder: (context, value, _) {
                          _scrollDown();
                          chatmessagesNotifier.value = 0;
                          return Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              // reverse: true,
                              itemCount: chatmessages.length,
                              itemBuilder: (context, i) {
                                if (i == chatmessages.length) {
                                  return Container(
                                    height: 60,
                                  );
                                }
                                // if (messages[i].sender == "2") {
                                return OwnMessageCard(
                                    data: chatmessages[i],
                                    widget: widget.appointmentDetails.id
                                        .toString());
                                // } else {
                                //   return ReplyCard(
                                //     data: messages[i],
                                //   );
                                // }
                              },
                            ),
                          );
                        },
                      ),
                    ),*/


                    //     }
                    //     return Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    // ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        // height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: Card(
                                    margin: EdgeInsets.only(
                                        left: 2, right: 2, bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: TextFormField(
                                      controller: _controller,
                                      focusNode: focusNode,
                                      textAlignVertical: TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      // keyboardType: showEmoji == false ? TextInputType.multiline : TextInputType.none,
                                      // readOnly: showEmoji == true ? true : false,
                                      // showCursor: true,
                                      maxLines: 5,
                                      minLines: 1,
                                      onTap: (){
                                          // var cursorPos = _controller.selection.base.offset;
                                          // print("hassan 1" + cursorPos.toString());
                                          showEmoji = false;
                                      },
                                      onChanged: (value) {
                                        // if (value.length > 0) {
                                        //   setState(() {
                                        //     sendButton = true;
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     sendButton = false;
                                        //   });
                                        // }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message s ${chatUniqueId}",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                            showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined,
                                          ),
                                          onPressed: () {

                                            if (showEmoji == true) {
                                                // focusNode.unfocus();
                                              //   focusNode.canRequestFocus = false;

                                              // show keyboard
                                              SystemChannels.textInput.invokeMethod('TextInput.show');
                                            }else{
                                              // hide keyboard
                                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                                            }

                                            setState(() {
                                              showEmoji = !showEmoji;
                                            });


                                          },
                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.only(left:5,right:5),
                                              constraints: BoxConstraints(),
                                              splashRadius: 22,
                                              icon: Icon(Icons.attach_file),
                                              onPressed: () {
                                                AttachFileBottomSheet(context);
                                              },
                                            ),
                                            // IconButton(
                                            //   icon: Icon(Icons.camera_alt),
                                            //   onPressed: () {
                                            //     getImagecamera();
                                            //   },
                                            // ),
                                            IconButton(
                                              padding: EdgeInsets.only(left:5,right:5),
                                              constraints: BoxConstraints(),
                                              splashRadius: 22,
                                              icon: Icon(Icons.medication, color:Colors.black),
                                              onPressed: () {
                                                PrescriptonBottomSheet();
                                              },
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.only(left:5,right:10),
                                              constraints: BoxConstraints(),
                                              splashRadius: 22,
                                              icon: Icon(Icons.medical_services, color:Colors.redAccent),
                                              onPressed: () {
                                                LabTestBottomSheet();
                                              },
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    right: 2,
                                    left: 2,
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Color(0xFF128C7E),
                                    child: IconButton(
                                      icon: Icon(
                                        sendButton ? Icons.send : Icons.send, // mic
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (sendButton) {
                                          String msg = _controller.text;

                                          // for api
                                          // setchatmessage(msg, '1');

                                          _controller.clear();
                                          _isLoadingChat.value = true;

                                          await ChatApi().PatinetSendMessage(
                                              chatUniqueId.toString(),
                                              uId.toString(),
                                              userId.toString(),
                                              doctorId.toString(),
                                              2,
                                              1,
                                              msg,
                                              null);

                                          // print('data insrted20');

                                          // if (login.st.toString() == '1') {
                                          //   // ToastMsg.showToastMsg("Successfully Added");
                                          //   print('user response 2');
                                          //   await _sendNotificationmessal();
                                          //   print('user response3');
                                          //   // Navigator.of(this.context).pushNamedAndRemoveUntil(
                                          //   //     '/AppointmentListPage', ModalRoute.withName('/HomePage'));
                                          // } else{
                                          //   ToastMsg.showToastMsg("Something went wrong");
                                          // }

                                          // setState(() {
                                          //   sendButton = false;
                                          // });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            showEmoji == true ? emojiSelect() : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onWillPop: () {
                  if (showEmoji) {
                    setState(() {
                      showEmoji = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget iconCreation(
    IconData icons,
    Color color,
    String text,
  ) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return SizedBox(
      height:250,
      width:MediaQuery.of(context).size.width,
      child: EmojiPicker(
        // onEmojiSelected: (category, Emoji emoji) {
        //   // Do something when emoji is tapped (optional)
        //   _controller.text = _controller.text + emoji.emoji;
        // },
        // onBackspacePressed: () {
        //   // Do something when the user taps the backspace button (optional)
        //   // Set it to null to hide the Backspace-Button
        // },
        textEditingController: _controller, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          recentTabBehavior: RecentTabBehavior.RECENT,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ), // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );

    // return EmojiPicker(
    //     rows: 4,
    //     columns: 7,
    //     onEmojiSelected: (emoji, category) {
    //       // print(emoji);
    //       setState(() {
    //         _controller.text = _controller.text + emoji.emoji;
    //       });
    //     });
  }

  // Widget _buildCard(prescriptionDetails) {
  //   // _itemLength=notificationDetails.length;
  //   return ListView.builder(
  //       controller: _scrollController,
  //       itemCount: prescriptionDetails.length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => PrescriptionDetailsPage(
  //                       title: prescriptionDetails[index].appointmentName,
  //                       prescriptionDetails: prescriptionDetails[index])),
  //             );
  //           },
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15.0),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: ListTile(
  //                   title: Text(prescriptionDetails[index].appointmentName,
  //                       style: TextStyle(
  //                         fontFamily: 'OpenSans-Bold',
  //                         fontSize: 14.0,
  //                       )),
  //                   trailing: Icon(
  //                     Icons.arrow_forward_ios,
  //                     color: iconsColor,
  //                     size: 20,
  //                   ),
  //                   subtitle: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "${prescriptionDetails[index].patientName}",
  //                         style: TextStyle(
  //                           fontFamily: 'OpenSans-SemiBold',
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                       Text(
  //                         "By ${prescriptionDetails[index].drName}",
  //                         style: TextStyle(
  //                           fontFamily: 'OpenSans-SemiBold',
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                       Text(
  //                         "${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
  //                         style: TextStyle(
  //                           fontFamily: 'OpenSans-Regular',
  //                           fontSize: 10,
  //                         ),
  //                       ),
  //                     ],
  //                   )),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future PrescriptonBottomSheet() {
    // ProgressDialog pd = ProgressDialog(context: context);
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) => Container(
              // height: 1000,
              height: 600,
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: const EdgeInsets.all(18.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      InputFields.commonInputField(_messageController, "Prescripton", (item) {
                        return item.length > 0 ? null : "Write Prescripton";
                      }, TextInputType.multiline, 3, textInputAction: TextInputAction.newline),
                      _imageUrls.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                              child: Text(
                                "Attached Files",
                                style: TextStyle(
                                  fontFamily: "OpenSans-SemiBold",
                                  fontSize: 14),
                              ),
                            ),
                      _buildImageList(),
                      Spacer(),
                      /*Padding(
                        padding: const EdgeInsets.only(left: 250),
                        child: IconButton(
                            icon: Icon(Icons.file_copy),
                            onPressed: () async {
                              await _handleFilePicker(pd);
                            }),
                      ),*/
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              _isLoadingChat.value = true;

                              String text = _messageController.text;
                              _messageController.text = '';

                              // print("hassan");
                              // print(widget.appointmentDetails.id);

                              // _handleUpdate();
                              // print('list data from precrption');
                              // print(1234);
                              String imageUrl = "";
                              if (_imageUrls.length != 0) {
                                for (var e in _imageUrls) {
                                  if (imageUrl == "") {
                                    imageUrl = e['url'];
                                  } else {
                                    imageUrl = imageUrl + "," + e['url'];
                                  }
                                }
                              }

                              // print(imageUrl);
                              String formattedDate = DateFormat.Hms().format(DateTime.now());

                              PrescriptionModel prescriptionModel = PrescriptionModel(
                                  appointmentId: chatUniqueId,
                                  patientId: uId,
                                  userId: userId,
                                  appointmentTime: formattedDate,
                                  appointmentDate: DateTime.now().toString(),
                                  appointmentName: 'serviceName',
                                  drName: doctorName,
                                  patientName: 'patientName',
                                  // imageUrl: imageUrl,
                                  imageUrl: imageUrl,
                                  prescription: text);

                                // print('asd');

                              await ChatApi().PatinetSendMessage(
                                  chatUniqueId.toString(),
                                  uId.toString(),
                                  userId.toString(),
                                  doctorId.toString(),
                                  2,
                                  6,
                                  text,
                                  '',
                                  prescriptionModel: prescriptionModel
                              );

                              // for api
                              // setchatmessage('prescription', '6');
                            },
                            child: Text(
                              'Send',
                              style: TextStyle(
                                fontFamily: "OpenSans-SemiBold",
                                fontSize: 14),
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Future LabTestBottomSheet() {
    // ProgressDialog pd = ProgressDialog(context: context);
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (builder) => Container(
            // height: 1000,
            height: 600,
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: const EdgeInsets.all(18.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    InputFields.commonInputField(
                        _messageController, "Lab Test", (item) {
                      return item.length > 0 ? null : "Enter message ";
                    }, TextInputType.multiline, 3,textInputAction: TextInputAction.newline),

                    // _imageUrls.length == 0
                    //     ? Container()
                    //     : Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    //   child: Text(
                    //     "Attached Files",
                    //     style: TextStyle(
                    //         fontFamily: "OpenSans-SemiBold", fontSize: 14),
                    //   ),
                    // ),
                    // _buildImageList(),
                    Spacer(),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 250),
                    //   child: IconButton(
                    //       icon: Icon(Icons.file_copy),
                    //       onPressed: () async {
                    //
                    //         await _handleFilePicker(pd);
                    //       }
                    //   ),
                    // ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {

                            // for api
                            // setchatmessage('labs test', '7');

                            Navigator.pop(context);
                            _isLoadingChat.value = true;

                            String text = _messageController.text;
                            _messageController.text = '';

                            Lablistmodel labTestModel = Lablistmodel(
                                uId: chatUniqueId,
                                drId: doctorId,
                                labName: text,
                                date: DateTime.now(),
                                appointmentId: chatUniqueId,
                                id: 0,
                                labTestAttachments: []
                            );

                            _isLoadingChat.value = true;
                            await ChatApi().PatinetSendMessage(
                                chatUniqueId.toString(),
                                uId.toString(),
                                userId.toString(),
                                doctorId.toString(),
                                2,
                                7,
                                text,
                                '',
                              labtestModel: labTestModel
                            );

                          },
                          child: Text('Send',
                            style: TextStyle(
                                fontFamily: "OpenSans-SemiBold",
                                fontSize: 14),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ));
  }

  _handleFilePicker(pd) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final fileSize = result.files[0].size * 0.000001;
      if (fileSize > 20) {
        result = null;
        ToastMsg.showToastMsg("File size must be less then 20MB");
      } else {
        File? file = File(result.files.single.path ?? "");
        setState(() {
          _file = file;
          //_filePath = result!.files.single.path??"";
        });
        print('file picker');
        // print(_filePath);
        _handleUpload(result.files[0].name, _file, pd);
        print('file picker bottom');
      }
    } else {
      // User canceled the picker
    }
  }

  _handleUpload(fileName, filePath, pd) async {
    setState(() {
      _isUploading = true;
    });
    // pd.show(
    //   max: 100,
    //   msg: 'File Uploading...',
    //   progressType: ProgressType.valuable,
    // );
    final fileName = Path.basename(filePath.path);
    print("****************File Base Name: $fileName");
    try {
      dios.FormData formData = dios.FormData.fromMap({
        "file": await dios.MultipartFile.fromFile(filePath.path,
            filename: fileName),
      });
      print("start uploading");

      print(formData.fields);
      final res = await dios.Dio().post(
        "$apiUrl/upload_file",
        data: formData,
        onSendProgress: (int sent, int total) {
          int progress = (((sent / total) * 100).toInt());
          pd.update(value: progress);
        },
      );
      print('uploading start');
      final body = jsonDecode(res.toString());
      print("Server res $fileName");
      print(body);

      if (body["status"]) {
        // print(body["fileName"]);
        _imageUrls
            .add({"fileName": fileName, "url": "$fileUrl/${body["fileName"]}"});
        setState(() {
          _isUploading = false;
        });

        // await _handleSendFileMsg(body["fileName"], body["message"], pd);
      } else {
        ToastMsg.showToastMsg("Uploading Error, try again");
      }
    } catch (e) {
      ToastMsg.showToastMsg("Uploading Error, try again");
      print("Error on uploading: $e");
      setState(() {
        _isUploading = false;
      });
    } finally {
      pd.close();
    }
  }

  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          shrinkWrap: true,
          // controller: _scrollController,
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                child: Row(
                  children: [
                    Flexible(
                        child: Text(
                      _imageUrls[index]['fileName'],
                    )),
                    Flexible(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              print('mahnoor');
                              setState(() {
                                _imageUrls.removeAt(index);
                              });
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.redAccent,
                          )),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  _handleUpdate() async {
    setState(() {
      _isUploading = true;
      _isEnableBtn = false;
    });
    // if (_listImages.length == 0) {
    String imageUrl = "";
    if (_imageUrls.length != 0) {
      for (var e in _imageUrls) {
        if (imageUrl == "") {
          imageUrl = e['url'];
        } else {
          imageUrl = imageUrl + "," + e['url'];
        }
      }
    }
    print(imageUrl);
    String formattedDate = DateFormat.Hms().format(DateTime.now());

    PrescriptionModel prescriptionModel = PrescriptionModel(
        appointmentId: chatUniqueId,
        patientId: widget.appointmentDetails.uId,
        appointmentTime: formattedDate,
        appointmentDate: DateTime.now().toString(),
        appointmentName: widget.appointmentDetails.serviceName,
        drName: widget.appointmentDetails.doctName,
        patientName: widget.appointmentDetails.pFirstName,
        // imageUrl: imageUrl,
        imageUrl: imageUrl,
        prescription: _messageController.text);
    final res = await PrescriptionService.addData(prescriptionModel);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Added");
      await _sendNotification();
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else
      ToastMsg.showToastMsg("Something went wrong");

    setState(() {
      _isUploading = false;
      _isEnableBtn = true;
    });
  }

  _sendNotification() async {
    String title = "Prescription Added";
    String body =
        "New Prescription has been added for ${widget.appointmentDetails.serviceName} please check it";
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.appointmentDetails.patientId,
        routeTo: "/PrescriptionListPage",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.appointmentDetails.patientName);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.appointmentDetails.patientId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.appointmentDetails.patientId, true);
    }
  }

  _sendNotificationmessal() async {
    String title = "New Message";
    String body = "New Message has been added for ${widget.appointmentDetails.pFirstName} please check it";
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.appointmentDetails.uId,
        routeTo: "/AppointmentPage",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.appointmentDetails.uId);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.appointmentDetails.uId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.appointmentDetails.uId, true);
    }
  }

  // _sendNotificationmessal() async {
  //   String title = "New Message Received";
  //   String body = "For the appointment #${widget.appointmentDetails!.id}";
  //   final notificationModel = NotificationModel(
  //       title: title,
  //       body: body,
  //       uId: widget.appointmentDetails!.uId,
  //       routeTo: "/UsersListForNotificationPage",
  //       sendBy: "patient",
  //       sendFrom: "Patient",
  //       doctId: widget.appointmentDetails!.doctId,
  //       sendTo: "Dcotor"
  //   );
  //
  //   final msgAdded = await NotificationService.addData(notificationModel);
  //
  //   final res = await DrProfileService.getDataByDrId(widget.appointmentDetails!.doctId); //get fcm id of specific user
  //
  //   if (msgAdded == "success") {
  //     HandleFirebaseNotification.sendPushMessage(res[0].fdmId.toString(), title, body);
  //     await UpdateData.updateIsAnyNotification(
  //         "usersList", widget.appointmentDetails!.uId, true);
  //   }
  // }

  labtestapi() async {
    final report = await PrescriptionService().AddLabReport(
      widget.appointmentDetails.uId,
      widget.appointmentDetails.doctId,
      _messageController.text,
      DateTime.now().toString(),
      chatUniqueId,
    );
  }

  AttachFileBottomSheet(context){
    showModalBottomSheet(
      backgroundColor:
      Colors.transparent,
      context: context,
      builder: (builder) => Container(
        height: 278,
        width: MediaQuery.of(
            context)
            .size
            .width,
        child: Card(
          margin: const EdgeInsets
              .all(
              18.0),
          shape: RoundedRectangleBorder(borderRadius:
              BorderRadius
                  .circular(
                  15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal:
                10,
                vertical:
                20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _handleFileSelection();
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.indigo,
                            child: Icon(
                              Icons.insert_drive_file,
                              // semanticLabel: "Help",
                              size: 29,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Document',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width:
                      40,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            getImagecamera();
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.pink,
                            child: Icon(
                              Icons.camera_alt,
                              // semanticLabel: "Help",
                              size: 29,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width:
                      40,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple,
                            child: Icon(
                              Icons.insert_photo,
                              // semanticLabel: "Help",
                              size: 29,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height:
                  30,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            PrescriptonBottomSheet();
                            // _handlePrescriptionBtn();
                            // getImage();
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.medication,
                              // semanticLabel: "Help",
                              size: 29,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Prescription',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width:
                      40,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            LabTestBottomSheet();
                            // _handlePrescriptionBtn();
                            // getImage();
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.redAccent,
                            child: Icon(
                              Icons.medical_services,
                              // semanticLabel: "Help",
                              size: 29,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Lab Test',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 35,),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:[
                                      Consumer<CustomOfferProvider>(
                                        builder: (context, provider, _) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Price",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: 'Price',
                                                  labelText: 'Enter price',
                                                  prefixIcon: Icon(Icons.currency_rupee),
                                                ),
                                                onChanged: (String val){
                                                  provider.setPrice(val);
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              Text("Number of installment",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Number of installment",
                                                ),
                                                onChanged: (String val){
                                                  provider.setInstallments(val);
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              Text("installment every x month",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "installment every x month",
                                                ),
                                                onChanged: (String val){
                                                  provider.setEveryXMonths(val);
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              InkWell(
                                                onTap: () async{
                                                  if(
                                                    provider.price == null ||
                                                      provider.installments == null ||
                                                        provider.everyXMonths == null
                                                  ){
                                                    errorNotify('Please fill all fileds');
                                                    return;
                                                  }
                                                  CustomOfferModel customOfferModel = CustomOfferModel(
                                                      price: provider.price,
                                                      installments: provider.installments,
                                                      everyXMonths: provider.everyXMonths,
                                                      userId: userId,
                                                      uId: uId,
                                                      chatId: chatUniqueId
                                                  );

                                                  // print('asd');

                                                  await ChatApi().PatinetSendMessage(
                                                      chatUniqueId.toString(),
                                                      uId.toString(),
                                                      userId.toString(),
                                                      doctorId.toString(),
                                                      2,
                                                      10,
                                                      '',
                                                      '',
                                                      customOfferModel: customOfferModel
                                                  );
                                                  Get.back();

                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius: BorderRadius.circular(25),
                                                  ),
                                                  child: Center(
                                                    child: Text("Send",
                                                     style: TextStyle(
                                                       color: Colors.white,
                                                       fontSize: 19
                                                     ),
                                                   )
                                                  ),
                                                ),
                                              )
                                            ]
                                          );
                                        }
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.currency_rupee,size: 30,color: Colors.white,),
                          )
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Currency',
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.w100,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
  }

  // for update status
  Widget _myRadioButton({String? title, int? value, onChanged}) {
    return RadioListTile(
      activeColor: btnColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged, //onChanged,
      title: Text(title ?? ""),
    );
  }
  updateStatus() {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a status"),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _myRadioButton(
                        title: "Confirmed",
                        value: 0,
                        onChanged: (newValue) => setState(() {
                          _groupValue = newValue;
                        })),
                    _myRadioButton(
                      title: "Visited",
                      value: 1,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Pending",
                      value: 2,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reject",
                      value: 3,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reschedule",
                      value: 4,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    switch (_groupValue) {
                      case 0:
                        {
                          Navigator.of(context).pop();
                          _handleAppointmentStatus(
                              chatUniqueId, "Confirmed");
                        }

                        break;
                      case 1:
                        {
                          Navigator.of(context).pop();
                          _handleDoneAppointment();
                        }

                        break;
                      case 2:
                        {
                          Navigator.of(context).pop();
                          _handleAppointmentStatus(
                              chatUniqueId, "Pending");
                        }

                        break;
                      case 3:
                        {
                          Navigator.of(context).pop();
                          _handleRejectAppointment();
                        }
                        break;

                      case 4:
                        {
                          Navigator.of(context).pop();
                          _handleRescheduleBtn();
                        }
                        break;
                      default:
                      // print("Not Select");
                        break;
                    }
                  }),
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }
  _handleAppointmentStatus(String appointmentId, String status) async {
    //print(uId + appointmentId +

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final appointmentModel = AppointmentModel(id: appointmentId, appointmentStatus: status);

    final res = await AppointmentService.updateStatus(appointmentModel);
    if (res == "success") {
      await _sendNotificationTwo(status);

      ToastMsg.showToastMsg("Successfully Updated");
      if (status == "Confirmed") {
        final getToekn = await AppointmentService.getToken(widget.appointmentDetails.doctId, widget.appointmentDetails.dateC);
        // print(getToekn);
        if (getToekn.length == 0) {
          final addedToken = await AppointmentService.addToken(
              doctId: widget.appointmentDetails.doctId.toString(),
              appId: chatUniqueId.toString(),
              tokenNum: "1",
              date: widget.appointmentDetails.dateC,
              tokenType: widget.appointmentDetails.walkin.toString());
          if (addedToken == "success")
            await _sendNotificationTwo("Appointment Checkedin", "1");
        } else if (getToekn.length > 0) {
          int tokenNum = int.parse(getToekn[getToekn.length - 1].tokenNum) + 1;
          //print("tnum $getToekn[getToekn.length-1].tokenNum $tokenNum");
          final addedToken = await AppointmentService.addToken(
              doctId: widget.appointmentDetails.doctId,
              appId: chatUniqueId.toString(),
              tokenNum: tokenNum.toString(),
              date: widget.appointmentDetails.dateC,
              tokenType: widget.appointmentDetails.walkin.toString());
          if (addedToken == "success")
            await _sendNotificationTwo("Appointment Checkedin", tokenNum.toString());
        }
      }

      // do not push from chat screen
      // Navigator.of(context).pushNamedAndRemoveUntil('/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
  _handleRescheduleBtn() {
    if (widget.appointmentDetails.walkin == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReWalkInChooseTimeSlotsPage(
            serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
            appointmentId: chatUniqueId,
            appointmentDate: widget.appointmentDetails.appointmentDate,
            uId: widget.appointmentDetails.uId,
            uName: "${widget.appointmentDetails.uName}",
            serviceName: widget.appointmentDetails.serviceName,
            doctId: widget.appointmentDetails.doctId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseTimeSlotsPage(
            serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
            appointmentId: chatUniqueId,
            appointmentDate: widget.appointmentDetails.appointmentDate,
            uId: widget.appointmentDetails.uId,
            uName: "${widget.appointmentDetails.uName}",
            serviceName: widget.appointmentDetails.serviceName,
            doctId: widget.appointmentDetails.doctId,
          ),
        ),
      );
    }
  }
  _handleRejectAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // final res = await DeleteData.deleteBookedAppointment(
    //     chatUniqueId,
    //     widget.appointmentDetails.appointmentDate,
    //     widget.appointmentDetails.doctId);
    // if (res == "success") {
    final appointmentModel = AppointmentModel(
        id: chatUniqueId, appointmentStatus: "Rejected");
    final isUpdated = await AppointmentService.updateStatus(appointmentModel);
    if (isUpdated == "success") {
      await _sendNotificationTwo("Rejected");
      ToastMsg.showToastMsg("Successfully Updated");

      // do not push from chat screen
      // Navigator.of(context).pushNamedAndRemoveUntil('/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
  _handleDoneAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // final res = await DeleteData.deleteBookedAppointment(
    //     chatUniqueId,
    //     widget.appointmentDetails.appointmentDate,
    //     widget.appointmentDetails.doctId);
    // if (res == "success") {
    final appointmentModel = AppointmentModel(
        id: chatUniqueId, appointmentStatus: "Visited");
    final isUpdated = await AppointmentService.updateStatus(appointmentModel);
    if (isUpdated == "success") {
      await AppointmentService.updateToken(chatUniqueId);
      _sendNotificationTwo("Visited");
      ToastMsg.showToastMsg("Successfully Updated");

      // do not push from chat screen
      // Navigator.of(context).pushNamedAndRemoveUntil('/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }
  _sendNotificationTwo(String title, [tokenNum]) async {
    String body = "";
    switch (title) {
      case "Visited":
        {
          body = "Thank you for visiting. Please visit again";
          break;
        }
      case "Confirmed":
        {
          body =
          "Your appointment has been confirmed for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Pending":
        {
          body =
          "Your appointment has been pending for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Rejected":
        {
          body =
          "Sorry! your appointment has been rejected for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Google Meet Link":
        {
          body =
          "Please check, google meet link has been updated for date ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Appointment Checkedin":
        {
          body =
          "Your Token Number is ${widget.appointmentDetails.walkin == "0" ? "A" : "W"}-$tokenNum for appointment date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      default:
        {
          body = "";
        }
    }
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.appointmentDetails.uId,
        routeTo: "/Appointmentstatus",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.appointmentDetails.uName);
    final msgAdded = await NotificationService.addData(notificationModel);

    if (msgAdded == "success") {
      final res = await UserService.getUserById(widget.appointmentDetails.uId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification("usersList", widget.appointmentDetails.uId, true);
    }
  }

}

Widget _labTestCard(prescriptionDetails) {
  // _itemLength=notificationDetails.length;
  return ListView.builder(
      // controller: _scrollController,
      itemCount: prescriptionDetails.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LabDetail(
                      prescriptionDetails: prescriptionDetails[index]
                  )),
            );

          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text(prescriptionDetails[index].labName,
                      style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: iconsColor,
                    size: 20,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prescriptionDetails[index].date.toString().toStandardDate(),
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14,
                        ),
                      ),
                      // Text(
                      //   "${prescriptionDetails[index].appointmentDate} ${prescriptionDetails[index].appointmentTime}",
                      //   style: TextStyle(
                      //     fontFamily: 'OpenSans-Regular',
                      //     fontSize: 10,
                      //   ),
                      // ),
                    ],
                  )),
            ),
          ),
        );
      });
}

Widget _prescriptionCard(prescriptionDetails) {
  // _itemLength=notificationDetails.length;
  return ListView.builder(
      // controller: _scrollController,
      itemCount: prescriptionDetails.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrescriptionDetailsPage(
                      title: prescriptionDetails[index].appointmentName,
                      prescriptionDetails: prescriptionDetails[index])),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text(prescriptionDetails[index].prescription.toString().limitChars(20),
                      style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: iconsColor,
                    size: 20,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescriptionDetails[index].appointmentDate.toString().toStandardDateTime(),
                        style: TextStyle(
                          fontFamily: 'OpenSans-Regular',
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      });
}



class AppointmentChatModal {
  static prescriptionModal(context, appointmentId) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text('Prescriptions',
                style:TextStyle(
                  fontSize:18,
                  fontWeight: FontWeight.bold
                )),
              ),
              Container(
                height: 400,
                child: FutureBuilder(
                    future: PrescriptionService.getDataByApIds(appointmentId: appointmentId),
                    //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData)
                        return snapshot.data.length == 0
                            ? NoDataWidget()
                            : Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 8, right: 8),
                            child: _prescriptionCard(
                              snapshot.data,
                            ));
                      else if (snapshot.hasError)
                        return IErrorWidget(); //if any error then you can also use any other widget here
                      else
                        return LoadingIndicatorWidget();
                    }),
              ),
            ],
          );
        });
  }

  static labModal(context, appointmentId) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text('Labs Test',
                      style:TextStyle(
                          fontSize:18,
                          fontWeight: FontWeight.bold
                      )),
                ),
                Container(
                  height: 400,
                  child: FutureBuilder(
                      future: PrescriptionService.getLabTest(appointmentId: appointmentId),
                      //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data.length == 0
                              ? NoDataWidget()
                              : Padding(
                                padding: const EdgeInsets.only(top: 0.0, left: 8, right: 8),
                                child: _labTestCard(snapshot.data)
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return IErrorWidget(); //if any error then you can also use any other widget here
                        }else {
                          return LoadingIndicatorWidget();
                        }
                      }),
                ),
              ],
            ),
          );
        });
  }


}
