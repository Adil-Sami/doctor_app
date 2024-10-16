import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/model/prescriptionModel.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/prescriptionService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';

class AddPrescriptionPage extends StatefulWidget {
  final drName;
  final title;
  final serviceName;
  final patientName;
  final date;
  final time;
  final appointmentId;
  final patientId;
  AddPrescriptionPage(
      {@required this.drName,
      @required this.title,
      @required this.patientName,
      @required this.serviceName,
      @required this.date,
      @required this.time,
      @required this.appointmentId,
      @required this.patientId});
  @override
  _AddPrescriptionPageState createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _drNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List _imageUrls = [];
  // List<Asset> _listImages = <Asset>[];
  bool _isUploading = false;
  bool _isEnableBtn = true;
  File? _file;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _serviceNameController.text = widget.serviceName;
      _patientNameController.text = widget.patientName;
      _drNameController.text = widget.drName;
      _dateController.text = widget.date;
      _timeController.text = widget.time;
    });
    super.initState();
    print(_imageUrls.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _serviceNameController..dispose();
    _patientNameController.dispose();
    _drNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
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

      PrescriptionModel prescriptionModel = PrescriptionModel(
          appointmentId: widget.appointmentId,
          patientId: widget.patientId,
          appointmentTime: widget.time,
          appointmentDate: widget.date,
          appointmentName: widget.serviceName,
          drName: _drNameController.text,
          patientName: _patientNameController.text,
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
      //  }
      //   else {
      //     //await _startUploading();
      //   }

      setState(() {
        _isUploading = false;
        _isEnableBtn = true;
      });
    }
  }

  // _startUploading() async {
  //   int index = _successUploaded - 1;
  //   // setState(() {
  //   //   _imageName = _listImages[index].name;
  //   // });
  //
  //   if (_successUploaded <= _listImages.length) {
  //     final res = await UploadImageService.uploadImages(
  //         _listImages[index]); //  represent the progress of uploading task
  //     if (res == "0") {
  //       ToastMsg.showToastMsg(
  //           "Sorry, ${_listImages[index].name} is not in format only JPG, JPEG, PNG, & GIF files are allowed to upload");
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       }
  //       ToastMsg.showToastMsg(
  //           "Image ${_listImages[index].name} size must be less the 2MB");
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       } else {}
  //     } else if (res == "2") {
  //       ToastMsg.showToastMsg(
  //           "Image ${_listImages[index].name} size must be less the 2MB");
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       } else {}
  //     } else if (res == "3" || res == "error") {
  //       ToastMsg.showToastMsg("Something went wrong");
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       } else {}
  //     } else if (res == "" || res == null) {
  //       ToastMsg.showToastMsg("Something went wrong");
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       } else {}
  //     } else {
  //       setState(() {
  //         _imageUrls.add(res);
  //       });
  //
  //       if (_successUploaded < _listImages.length) {
  //         //check more images for upload
  //         setState(() {
  //           _successUploaded = _successUploaded + 1;
  //         });
  //         _startUploading(); //if images is remain to upload then again run this task
  //
  //       } else {
  //         // print("***********${_imageUrls.length}");
  //         String imageUrl = "";
  //         if (_imageUrls.length != 0) {
  //           for (var e in _imageUrls) {
  //             if (imageUrl == "") {
  //               imageUrl = e;
  //             } else {
  //               imageUrl = imageUrl + "," + e;
  //             }
  //           }
  //         }
  //
  //         PrescriptionModel prescriptionModel = PrescriptionModel(
  //             appointmentId: widget.appointmentId,
  //             patientId: widget.patientId,
  //             appointmentTime: widget.time,
  //             appointmentDate: widget.date,
  //             appointmentName: widget.serviceName,
  //             drName: _drNameController.text,
  //             patientName: _patientNameController.text,
  //             imageUrl: imageUrl,
  //             prescription: _messageController.text);
  //         final res = await PrescriptionService.addData(prescriptionModel);
  //         if (res == "success") {
  //           ToastMsg.showToastMsg("Successfully Added");
  //           await _sendNotification();
  //           Navigator.of(context).pushNamedAndRemoveUntil(
  //               '/AppointmentListPage', ModalRoute.withName('/HomePage'));
  //         } else
  //           ToastMsg.showToastMsg("Something went wrong");
  //       }
  //     }
  //   }
  //   setState(() {
  //     _isUploading = false;
  //     _isEnableBtn = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: kAppBarTitleStyle,
        ),
        backgroundColor: appBarColor,
        // actions: [
        //   IconButton(onPressed: (){}, icon:Icon(Icons.delete))
        // ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: IconButton(
              icon: Icon(Icons.file_copy),
              onPressed: () async {
                await _handleFilePicker(null);
              }),
          backgroundColor: btnColor,
          onPressed: () {}),
      bottomNavigationBar: BottomNavBarWidget(
          title: "Add",
          onPressed: () {
            _handleUpdate();
          },
          isEnableBtn: _isEnableBtn),
      body: _isUploading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  // InputFields.readableInputField(
                  //     _serviceNameController, "Service", 1),
                  // InputFields.commonInputField(
                  //     _patientNameController, "Patient Name", (item) {
                  //   return item.length > 0 ? null : "Enter patient name";
                  // }, TextInputType.text, 1),
                  // InputFields.commonInputField(_drNameController, "Dr Name",
                  //     (item) {
                  //   return item.length > 0 ? null : "Enter Dr name";
                  // }, TextInputType.text, 1),
                  // InputFields.readableInputField(_dateController, "Date", 1),
                  // InputFields.readableInputField(_timeController, "Time", 1),
                  InputFields.commonInputField(_messageController, "Message",
                      (item) {
                    return item.length > 0 ? null : "Enter message ";
                  }, TextInputType.text, null),
                  _imageUrls.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(
                            "Attached Files",
                            style: TextStyle(
                                fontFamily: "OpenSans-SemiBold", fontSize: 14),
                          ),
                        ),
                  _buildImageList(),
                  // _imageUrls.length == 0
                  //     ? Container()
                  //     : Padding(
                  //         padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  //         child: Text(
                  //           "New attached image",
                  //           style: TextStyle(
                  //               fontFamily: "OpenSans-SemiBold", fontSize: 14),
                  //         ),
                  //       ),
                  //_buildNewImageList(),
                ],
              ),
            ),
    );
  }

  // Future<void> _loadAssets() async {
  //   final res = await ImagePicker.loadAssets(
  //       _listImages, mounted, 10); //get images from phone gallery with 10 limit
  //   setState(() {
  //     _listImages = res;
  //     // if (res.length > 0)
  //     //   _isEnableBtn = true;
  //     // else
  //     //   _isEnableBtn = false;
  //   });
  // }

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
        // print(_filePath);
        _handleUpload(result.files[0].name, _file, pd);
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
    final fileName = basename(filePath.path);
    print("****************File Base Name: $fileName");
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath.path, filename: fileName),
      });
      print("start uploading");
      final res = await Dio().post(
        "$apiUrl/upload_file",
        data: formData,
        onSendProgress: (int sent, int total) {
          int progress = (((sent / total) * 100).toInt());
          pd.update(value: progress);
        },
      );
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

  // Future<void> _loadAssets() async {
  //   List<Asset> resultList = <Asset>[];
  //   //String error = 'No Error Detected';
  //
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 5,
  //       enableCamera: true,
  //       selectedAssets: _listImages,
  //       cupertinoOptions: CupertinoOptions(
  //         takePhotoIcon: "chat",
  //         doneButtonTitle: "Fatto",
  //       ),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Example App",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //     // error = e.toString();
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //   setState(() {
  //     _listImages = resultList;
  //     if (resultList.length > 0)
  //       _isEnableBtn = true;
  //     else
  //       _isEnableBtn = false;
  //   });
  //
  //   // setState(() {
  //   //   // _listImages = resultList;
  //   //   _error = error;
  //   // });
  // }
  //
  // _buildNewImageList() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         controller: _scrollController,
  //         itemCount: _listImages.length,
  //         itemBuilder: (context, index) {
  //           Asset asset = _listImages[index];
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 8.0),
  //             child: GestureDetector(
  //               onLongPress: () {
  //                 DialogBoxes.confirmationBox(context, "Delete",
  //                     "Are you sure want to delete selected image", () {
  //                   setState(() {
  //                     _listImages.removeAt(index);
  //                   });
  //                 });
  //               },
  //               child: AssetThumb(
  //                 asset: asset,
  //                 width: 300,
  //                 height: 300,
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
  //
  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          shrinkWrap: true,
          controller: _scrollController,
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
                              _imageUrls.removeAt(index);
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

  _sendNotification() async {
    String title = "Prescription Added";
    String body =
        "New Prescription has been added for ${widget.serviceName} please check it";
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.patientId,
        routeTo: "/PrescriptionListPage",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.patientName);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.patientId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.patientId, true);
    }
  }
}
