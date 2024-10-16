import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:external_path/external_path.dart';
import 'package:demoadmin/config.dart';
import 'package:demoadmin/model/prescriptionModel.dart';
import 'package:demoadmin/service/prescriptionService.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/fontStyle.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:open_filex/open_filex.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  final title;
  final prescriptionDetails;
  PrescriptionDetailsPage(
      {@required this.title, @required this.prescriptionDetails});
  @override
  _PrescriptionDetailsPageState createState() =>
      _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _drNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<String> _oldImageUrls = [];
  List _imageUrls = [];
  // List<Asset> _listImages = <Asset>[];
  File? _file;
  String _filePath = "";
  bool _isUploading = false;
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var taskId;
  ReceivePort _port = ReceivePort();
  // ProgressDialog? pd;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _serviceNameController.text = widget.prescriptionDetails.appointmentName;
      _patientNameController.text = widget.prescriptionDetails.patientName;
      _drNameController.text = widget.prescriptionDetails.drName;
      _dateController.text = widget.prescriptionDetails.appointmentDate;
      _timeController.text = widget.prescriptionDetails.appointmentTime;
      _messageController.text = widget.prescriptionDetails.prescription;
      if (widget.prescriptionDetails.imageUrl != "")
        _oldImageUrls =
            widget.prescriptionDetails.imageUrl.toString().split(",");
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print("Download Status $progress");
      // print(data);
      // pd!.update(value: progress);
      await FlutterDownloader.open(taskId: taskId);
      // pd!.close();
      // if (status == DownloadTaskStatus(3)) {
      //   Future.delayed(const Duration(milliseconds: 2000), () async {
      //     try {
      //       await FlutterDownloader.open(taskId: taskId);
      //     } catch (e) {}
      //   });
      // }
      setState(() {});
    });
    // FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
    print(_imageUrls.length);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
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
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
        _isEnableBtn = false;
      });
      //  if (_listImages.length == 0) {
      String imageUrl = "";
      if (_oldImageUrls.length != 0) {
        for (var e in _oldImageUrls) {
          if (imageUrl == "") {
            imageUrl = e;
          } else {
            imageUrl = imageUrl + "," + e;
          }
        }
      }
      if (_imageUrls.length != 0) {
        for (var e in _imageUrls) {
          if (imageUrl == "") {
            imageUrl = e['url'];
          } else {
            imageUrl = imageUrl + "," + e['url'];
          }
        }
      }
      print("Uploading image urls ${imageUrl}");

      PrescriptionModel prescriptionModel = PrescriptionModel(
          id: widget.prescriptionDetails.id,
          drName: _drNameController.text,
          patientName: _patientNameController.text,
          imageUrl: imageUrl,
          prescription: _messageController.text);
      final res = await PrescriptionService.updateData(prescriptionModel);
      if (res == "success") {
        ToastMsg.showToastMsg("Successfully updated");
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else
        ToastMsg.showToastMsg("Something went wrong");
      // } else {
      //   await _startUploading();
      // }

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
  //       } else {}
  //     } else if (res == "1") {
  //       ToastMsg.showToastMsg(
  //           "Image ${_listImages[index].name} size must be less the 1MB");
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
  //           "Image ${_listImages[index].name} size must be less the 1MB");
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
  //       } else {
  //         Navigator.of(context).pushNamedAndRemoveUntil(
  //             '/EditGalleryPage', ModalRoute.withName('/'));
  //       }
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
  //             id: widget.prescriptionDetails.id,
  //             drName: _drNameController.text,
  //             patientName: _patientNameController.text,
  //             imageUrl: imageUrl,
  //             prescription: _messageController.text);
  //         final res = await PrescriptionService.updateData(prescriptionModel);
  //         if (res == "success") {
  //           ToastMsg.showToastMsg("Successfully updated");
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
        actions: [
          // IconButton(
          //     onPressed: () {
          //       DialogBoxes.confirmationBox(context, "Delete",
          //           "Are you sure want to delete prescription", () {
          //         _handleDeletePrescription();
          //       });
          //     },
          //     icon: Icon(Icons.delete))
        ],
      ),
      // bottomNavigationBar: BottomNavBarWidget(
      //     title: "Update",
      //     onPressed: () {
      //       _handleUpdate();
      //     },
      //     isEnableBtn: _isEnableBtn),
      // floatingActionButton: FloatingActionButton(
      //     elevation: 0.0,
      //     child: IconButton(
      //         icon: Icon(Icons.file_copy),
      //         onPressed: () {
      //           _handleFilePicker(pd);
      //         }),
      //     backgroundColor: btnColor,
      //     onPressed: () {}),
      body: _isUploading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  InputFields.readableInputField(
                      _serviceNameController, "Service", 1),

                  /*InputFields.commonInputField(
                      _patientNameController, "Patient Name", (item) {
                    return item.length > 0 ? null : "Enter patient name";
                  }, TextInputType.text, 1),*/

                  /*InputFields.commonInputField(_drNameController, "Dr Name",
                      (item) {
                    return item.length > 0 ? null : "Enter Dr name";
                  }, TextInputType.text, 1),*/

                  InputFields.readableInputField(_dateController, "Date", 1),
                  InputFields.readableInputField(_timeController, "Time", 1),
                  InputFields.commonInputField(_messageController, "Message",
                      (item) {
                    return item.length > 0 ? null : "Enter message ";
                  }, TextInputType.text, null),
                  _oldImageUrls.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(
                            "Previous attached image",
                            style: TextStyle(
                                fontFamily: "OpenSans-SemiBold", fontSize: 14),
                          ),
                        ),
                  _buildImageList(),
                  _imageUrls.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Text(
                            "New attached image",
                            style: TextStyle(
                                fontFamily: "OpenSans-SemiBold", fontSize: 14),
                          ),
                        ),
                  _buildNewImageList(),
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
          _filePath = result!.files.single.path ?? "";
        });
        //  print(_filePath);
        _handleUpload(result.files[0].name, _file, pd, _filePath);
      }
    } else {
      // User canceled the picker
    }
  }

  _handleUpload(fileName, filePath, pd, filePathToOpen) async {
    setState(() {
      _isUploading = true;
    });
    // pd.show(
    //   max: 100,
    //   msg: 'File Uploading...',
    //   progressType: ProgressType.valuable,
    // );
    final fileName = basename(filePath.path);
    // print("****************File Base Name: $fileName");
    try {
      FormData formData = new FormData.fromMap({
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
        _imageUrls.add({
          "filePath": filePathToOpen,
          "fileName": fileName,
          "url": "$fileUrl/${body["fileName"]}"
        });
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

  _handleDeletePrescription() async {
    setState(() {
      _isUploading = true;
      _isEnableBtn = false;
    });
    final res =
        await PrescriptionService.deleteData(widget.prescriptionDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully deleted");
      Navigator.of(this.context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isUploading = false;
      _isEnableBtn = true;
    });
  }

  _buildNewImageList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Flexible(
                      child: Text(
                          getFileNameFromUrl(_imageUrls[index]['fileName']))),
                  Flexible(
                    child: IconButton(
                        onPressed: () {
                          DialogBoxes.confirmationBox(context, "Delete",
                              "Are you sure want to delete selected image", () {
                            setState(() {
                              _imageUrls.removeAt(index);
                            });
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  ),
                  Flexible(
                    child: IconButton(
                        onPressed: () async {
                          //print(_imageUrls[index]['filePath']);
                          await OpenFilex.open(_imageUrls[index]['filePath']);
                        },
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          color: Colors.green,
                        )),
                  )
                ],
              ),
            );
          }),
    );
  }

  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _oldImageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Flexible(
                      child: Text(getFileNameFromUrl(_oldImageUrls[index]))),
                  Flexible(
                    child: IconButton(
                        onPressed: () {
                          DialogBoxes.confirmationBox(context, "Delete",
                              "Are you sure want to delete selected image", () {
                            setState(() {
                              _oldImageUrls.removeAt(index);
                            });
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  ),
                  Flexible(
                    child: IconButton(
                        onPressed: () async {
                          // pd = ProgressDialog(context: context);
                          final fileNameWithExt =
                              getFileNameFromUrl(_oldImageUrls[index]);
                          var perStatus = await Permission.storage.request();
                          if (perStatus.isGranted) {
                            String path = await ExternalPath
                                .getExternalStoragePublicDirectory(
                                    ExternalPath.DIRECTORY_DOWNLOADS);
                            if (await File(
                                        "${path}/MyClinicAdmin/$fileNameWithExt")
                                    .exists() ==
                                true) {
                              print("file exists");
                              await OpenFilex.open(
                                  '${path}/MyClinicAdmin/$fileNameWithExt');
                              //await  Directory("storage/emulated/0/Android/media/com.medicaljunction.download/files").create(recursive: true);
                            } else {
                              if (await Directory("$path/MyClinicAdmin")
                                      .exists() ==
                                  false) {
                                print("Directory not exists");
                                await Directory("${path}/MyClinicAdmin")
                                    .create(recursive: true);
                              }
                              ToastMsg.showToastMsg(
                                  "Download Stated, please wait");
                              // pd!.show(
                              //   max: 100,
                              //   msg: 'Downloading...',
                              //   progressType: ProgressType.valuable,
                              // );
                              taskId = await FlutterDownloader.enqueue(
                                url: _oldImageUrls[index],
                                savedDir: "${path}/MyClinicAdmin",
                                fileName: "$fileNameWithExt",
                                showNotification: true,
                                // show download progress in status bar (for Android)
                                openFileFromNotification:
                                    true, // click on notification to open downloaded file (for Android)
                              );
                            }
                          } else if (perStatus.isPermanentlyDenied) {
                            ToastMsg.showToastMsg(
                                "Please give us app storage permission from app settings");
                          }
                        },
                        icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 20,
                            ))),
                  ),
                ],
              ),
            );
          }),
    );
  }

  getFileNameFromUrl(fileUrl) {
    final File _file = File(fileUrl);
    final _filename = basename(_file.path);
    return _filename;
  }
}
