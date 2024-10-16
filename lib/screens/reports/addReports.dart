import 'package:demoadmin/model/reportModel.dart';
import 'package:demoadmin/service/reporstService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';

class AddReportPage extends StatefulWidget {
  final uid;
  const AddReportPage({Key? key, this.uid}) : super(key: key);

  @override
  _AddReportPageState createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController reportTitleController = TextEditingController();
  List<String> _imageUrls = [];
  // List<Asset> _listImages = <Asset>[];
  int _successUploaded = 1;
  bool _isUploading = false;
  bool _isEnableBtn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add",
        onPressed: _takeUpdateConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      floatingActionButton: _isUploading
          ? null
          : FloatingActionButton(
              elevation: 0.0,
              child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () async {
                    await _loadAssets();
                  }),
              backgroundColor: btnColor,
              onPressed: () {}),
      body: _isUploading ? LoadingIndicatorWidget() : buildBody(),
    );
  }

  _takeUpdateConfirmation() {
    // if (_listImages.length == 0) {
    //   ToastMsg.showToastMsg("Please add at least one image");
    // } else
    //   DialogBoxes.confirmationBox(context, "Update",
    //       "Are you sure want to update details", _handleUpdate);
  }

  _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
        _isEnableBtn = false;
      });

      // if (_listImages.length == 0) {
      //   String imageUrl = "";
      //
      //
      //   ReportModel prescriptionModel = ReportModel(
      //     uid: widget.uid,
      //     title: reportTitleController.text,
      //     imageUrl: imageUrl,
      //   );
      //   final res = await ReportService.addData(prescriptionModel);
      //   if (res == "success") {
      //     ToastMsg.showToastMsg("Successfully Added");
      //     Navigator.pop(context);
      //     Navigator.pop(context);
      //   } else if (res == "already exists") {
      //     setState(() {
      //       _imageUrls.clear();
      //       _listImages.clear();
      //     });
      //     ToastMsg.showToastMsg("Title name already exists");
      //   } else {
      //     setState(() {
      //       _imageUrls.clear();
      //       _listImages.clear();
      //     });
      //     ToastMsg.showToastMsg("Something went wrong");
      //   }
      // } else {
      //   await _startUploading();
      // }

      setState(() {
        _isUploading = false;
        _isEnableBtn = true;
      });
    }
  }

  _startUploading() async {
    int index = _successUploaded - 1;
    // setState(() {
    //   _imageName = _listImages[index].name;
    // });

    // if (_successUploaded <= _listImages.length) {
    //   final res = await UploadImageService.uploadImages(
    //       _listImages[index]); //  represent the progress of uploading task
    //   if (res == "0") {
    //     ToastMsg.showToastMsg(
    //         "Sorry, ${_listImages[index].name} is not in format only JPG, JPEG, PNG, & GIF files are allowed to upload");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {}
    //   } else if (res == "1") {
    //     ToastMsg.showToastMsg(
    //         "Image ${_listImages[index].name} size must be less the 2MB");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {}
    //   } else if (res == "2") {
    //     ToastMsg.showToastMsg(
    //         "Image ${_listImages[index].name} size must be less the 2MB");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {}
    //   } else if (res == "3" || res == "error") {
    //     ToastMsg.showToastMsg("Something went wrong");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {}
    //   } else if (res == "") {
    //     ToastMsg.showToastMsg("Something went wrong");
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {}
    //   } else {
    //     setState(() {
    //       _imageUrls.add(res);
    //     });
    //
    //     if (_successUploaded < _listImages.length) {
    //       //check more images for upload
    //       setState(() {
    //         _successUploaded = _successUploaded + 1;
    //       });
    //       _startUploading(); //if images is remain to upload then again run this task
    //
    //     } else {
    //       // print("***********${_imageUrls.length}");
    //       String imageUrl = "";
    //       if (_imageUrls.length != 0) {
    //         for (var e in _imageUrls) {
    //           if (imageUrl == "") {
    //             imageUrl = e;
    //           } else {
    //             imageUrl = imageUrl + "," + e;
    //           }
    //         }
    //       }
    //
    //       ReportModel reportModel = ReportModel(
    //           title: reportTitleController.text,
    //           imageUrl: imageUrl,
    //           uid: widget.uid);
    //       final res = await ReportService.addData(reportModel);
    //       if (res == "success") {
    //         ToastMsg.showToastMsg("Successfully Added");
    //         Navigator.pop(context);
    //         Navigator.pop(context);
    //       } else if (res == "already exists") {
    //         setState(() {
    //           _imageUrls.clear();
    //           _listImages.clear();
    //         });
    //         ToastMsg.showToastMsg("Title name already exists");
    //       } else {
    //         setState(() {
    //           _imageUrls.clear();
    //           _listImages.clear();
    //         });
    //         ToastMsg.showToastMsg("Something went wrong");
    //       }
    //     }
    //   }
    // }
    // setState(() {
    //   _isUploading = false;
    //   _isEnableBtn = true;
    // });
  }

  Future<void> _loadAssets() async {
    // List<Asset> resultList = <Asset>[];
    // //String error = 'No Error Detected';
    // try {
    //   resultList = await MultiImagePicker.pickImages(
    //     maxImages: 5,
    //     enableCamera: true,
    //     selectedAssets: _listImages,
    //     cupertinoOptions: CupertinoOptions(
    //       takePhotoIcon: "chat",
    //       doneButtonTitle: "Fatto",
    //     ),
    //     materialOptions: MaterialOptions(
    //       actionBarColor: "#abcdef",
    //       actionBarTitle: "Example App",
    //       allViewTitle: "All Photos",
    //       useDetailsView: false,
    //       selectCircleStrokeColor: "#000000",
    //     ),
    //   );
    // } on Exception catch (e) {
    //   print(e);
    //   // error = e.toString();
    // }
    //
    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;
    // setState(() {
    //   _listImages = resultList;
    //   if (resultList.length > 0)
    //     _isEnableBtn = true;
    //   else
    //     _isEnableBtn = false;
    // });
    //
    // // setState(() {
    // //   // _listImages = resultList;
    // //   _error = error;
    // // });
  }

  buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          InputFields.commonInputField(reportTitleController, "Report Title",
              (item) {
            return item.length > 0 ? null : "Enter report title";
          }, TextInputType.text, 1),

          // _imageUrls.length == 0
          //     ? Container()
          //     : Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          //   child: Text(
          //     "Previous attached image",
          //     style: TextStyle(
          //         fontFamily: "OpenSans-SemiBold", fontSize: 14),
          //   ),
          // ),
          //  _buildImageList(),

          // _listImages.length == 0
          //     ? Container()
          //     : Padding(
          //         padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          //         child: Text(
          //           "New attached image",
          //           style: TextStyle(
          //               fontFamily: "OpenSans-SemiBold", fontSize: 14),
          //         ),
          //       ),
          _buildNewImageList(),
        ],
      ),
    );
  }

  _buildNewImageList() {
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: ListView.builder(
    //       shrinkWrap: true,
    //       controller: _scrollController,
    //       itemCount: _listImages.length,
    //       itemBuilder: (context, index) {
    //         Asset asset = _listImages[index];
    //         return Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: GestureDetector(
    //             onLongPress: () {
    //               DialogBoxes.confirmationBox(context, "Delete",
    //                   "Are you sure want to delete selected image", () {
    //                 setState(() {
    //                   _listImages.removeAt(index);
    //                 });
    //               });
    //             },
    //             child: AssetThumb(
    //               asset: asset,
    //               width: 300,
    //               height: 300,
    //             ),
    //           ),
    //         );
    //       }),
    // );
  }
}
