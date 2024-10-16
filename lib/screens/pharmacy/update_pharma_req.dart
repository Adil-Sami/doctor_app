import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/model/pharma_req_model.dart';
import 'package:demoadmin/screens/prescription/shoePrescriptionPage.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/pharma_req_service.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';

class EditPharmaReqPage extends StatefulWidget {
  final PharmacyReqModel? reportModel;
  final forAdmin;
  const EditPharmaReqPage({Key? key, this.reportModel, this.forAdmin})
      : super(key: key);
  @override
  _EditPharmaReqPageState createState() => _EditPharmaReqPageState();
}

class _EditPharmaReqPageState extends State<EditPharmaReqPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _statuscont = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<String> _imageUrls = [];
  // List<Asset> _listImages = <Asset>[];

  bool _isUploading = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    _statuscont.text = widget.reportModel!.status == "0"
        ? "Pending"
        : widget.reportModel!.status == "1"
            ? "Confirmed"
            : widget.reportModel!.status == "2"
                ? "Delivered"
                : widget.reportModel!.status == "3"
                    ? "Canceled"
                    : "Not Updated";
    // TODO: implement initState
    _titleController.text = widget.reportModel!.desc;
    _firstNameController.text = widget.reportModel!.firstName;
    _lastNameController.text = widget.reportModel!.lastName ?? "";
    _phoneController.text = widget.reportModel!.phone;

    if (widget.reportModel!.imageUrl != "")
      _imageUrls = widget.reportModel!.imageUrl.toString().split(",");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Request List"),
      // floatingActionButton:widget.reportModel!.status=="0"?_isUploading?null: FloatingActionButton(
      //     elevation: 0.0,
      //     child:
      //     IconButton(icon: Icon(Icons.add_a_photo), onPressed: _loadAssets),
      //     backgroundColor: btnColor,
      //     onPressed: () {}):null,
      // bottomNavigationBar: widget.reportModel!.status=="0"||widget.reportModel!.status=="1"?BottomNavBarWidget(
      //   title: "Update",
      //   onPressed: _takeUpdateConfirmation,
      //   isEnableBtn: _isEnableBtn,
      // ):null,
      body: _isUploading ? LoadingIndicatorWidget() : buildBody(),
    );
  }

  buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          InputFields.readableInputField(_firstNameController, "First Name", 1),
          InputFields.readableInputField(_lastNameController, "Last Name", 1),
          InputFields.readableInputField(_phoneController, "Phone", 1),
          InputFields.commonInputField(_titleController, "Enter Report Title",
              (item) {
            return item.length > 0 ? null : "Enter Title";
          }, TextInputType.text, 1),
          InputFields.readableInputField(_statuscont, "Status", 1),
          _imageUrls.length == 0
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
          widget.reportModel!.status == "0"
              ? DeleteButtonWidget(
                  onPressed: () {
                    showDialog(
                      // barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: new Text("Confirmed"),
                          content: new Text(
                              "Are you sure want to update status to confirmed"),
                          actions: <Widget>[
                            new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: btnColor,
                                ),
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _handleUpdateReqService("1");
                                })
                            // usually buttons at the bottom of the dialog
                          ],
                        );
                      },
                    );
                    //take confirmation from user
                  },
                  title: "Confirmed Request",
                )
              : Container(),
          widget.reportModel!.status == "1"
              ? DeleteButtonWidget(
                  onPressed: () {
                    showDialog(
                      // barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: new Text("Delivered"),
                          content: new Text(
                              "Are you sure want to update status to delivered"),
                          actions: <Widget>[
                            new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: btnColor,
                                ),
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _handleUpdateReqService("2");
                                })
                            // usually buttons at the bottom of the dialog
                          ],
                        );
                      },
                    );
                    //take confirmation from user
                  },
                  title: "Delivered Request",
                )
              : Container(),
          widget.reportModel!.status == "0" || widget.reportModel!.status == "1"
              ? DeleteButtonWidget(
                  onPressed: () {
                    showDialog(
                      // barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: new Text("Cancel"),
                          content: new Text(
                              "Are you sure want to update status to cancel"),
                          actions: <Widget>[
                            new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: btnColor,
                                ),
                                child: new Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _handleUpdateReqService("3");
                                })
                            // usually buttons at the bottom of the dialog
                          ],
                        );
                      },
                    );
                    //take confirmation from user
                  },
                  title: "Cancel Request",
                )
              : Container(),
          //   widget.reportModel!.status=="0"|| widget.reportModel!.status=="1"? _deleteServiceBtn():Container()
        ],
      ),
    );
  }

  _handleUpdateReqService(String status) async {
    setState(() {
      _isUploading = true;
    });
    final res =
        await PharmaReqService.updateData(status, widget.reportModel!.id);
    if (res == "success") {
      _handleSendNoti(status);
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isUploading = false;
      });
    }
  }

  _handleSendNoti(String status) async {
    final res = await UserService.getUserByuid(widget.reportModel!.uid);
    final notificationModel = NotificationModel(
        title: "Request updated",
        body:
            "Pharmacy request id ${widget.reportModel!.pharmaId} has been updated. please check it",
        uId: res[0].uId,
        routeTo: "/PharmaReqListPage",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: "");
    await NotificationService.addData(notificationModel);
    await HandleFirebaseNotification.sendPushMessage(
        res[0].fcmId, //admin fcm
        "Request updated", //title
        "Pharmacy request id ${widget.reportModel!.pharmaId} has been updated please check" //body
        );
    await UpdateData.updateIsAnyNotification("usersList", res[0].uId, true);
    ToastMsg.showToastMsg("Successfully updated");
    if (widget.forAdmin)
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PharmaAllReqListPage', ModalRoute.withName('/HomePage'));
    else
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/PharmaReqListPage', ModalRoute.withName('/HomePage'));
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

  _buildImageList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: _imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowPrescriptionImagePage(
                          imageUrls: _imageUrls,
                          selectedImagesIndex: index,
                          title: "Image"),
                    ),
                  );
                },
                onLongPress: () {
                  DialogBoxes.confirmationBox(context, "Delete",
                      "Are you sure want to delete selected image", () {
                    setState(() {
                      _imageUrls.removeAt(index);
                    });
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ImageBoxContainWidget(
                    imageUrl: _imageUrls[index],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
