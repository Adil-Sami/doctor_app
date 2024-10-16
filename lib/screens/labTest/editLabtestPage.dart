import 'package:demoadmin/model/labTestModel.dart';
import 'package:demoadmin/service/labTestService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class EditLabTestPage extends StatefulWidget {
  final clinicId;
  final dataDetails;
  const EditLabTestPage({Key? key, this.dataDetails, this.clinicId})
      : super(key: key);

  @override
  _EditLabTestPageState createState() => _EditLabTestPageState();
}

class _EditLabTestPageState extends State<EditLabTestPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  TextEditingController titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool passValid = true;
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";
  String checkValue = "1";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all textController values
    titleController.text = widget.dataDetails.title;
    _subTitleController.text = widget.dataDetails.subTitle;
    _priceController.text = widget.dataDetails.price;
    _imageUrl = widget.dataDetails.imageUrl;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Lab Test"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Update",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // if (_imageUrl == "")
                    //   if (_images.length == 0)
                    //     ECircularCameraIconWidget(
                    //       onTap: _handleImagePicker,
                    //     )
                    //   else
                    //     ECircularImageWidget(
                    //       onPressed: _removeImage,
                    //       images: _images,
                    //       imageUrl: _imageUrl,
                    //     )
                    // else
                    //   ECircularImageWidget(
                    //     onPressed: _removeImage,
                    //     images: _images,
                    //     imageUrl: _imageUrl,
                    //   ),
                    _serviceNameInputField(),
                    _gLocationInputField(),
                    _emailInputField(),
                    _deleteServiceBtn()
                  ],
                ),
              ),
            ),
    );
  }

  Widget confirmPassInputField(controller, labelText) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
              controller: controller,
              validator: (item) {
                if (item!.length > 7 && item.length < 20) {
                  if (item == _passController.text)
                    return null;
                  else
                    return "Confirm password must be same with password";
                } else {
                  return "Enter confirm password";
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )),
            ),
          ],
        ));
  }

  Widget passInputField(controller, labelText) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
              controller: controller,
              validator: (item) {
                if (item!.length > 7 && item.length < 20) {
                  String pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  bool checkValid = regExp.hasMatch(item);
                  if (checkValid)
                    setState(() {
                      passValid = true;
                    });
                  else
                    setState(() {
                      passValid = false;
                    });

                  return checkValid ? null : "Enter a valid password";
                } else {
                  return "length should be at least 8";
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                  labelText: labelText,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 1.0),
                  )),
            ),
            !passValid ? SizedBox(height: 8) : Container(),
            !passValid
                ? Text(
                    "Password length should be greater then 8 and Minimum 1 Upper case, 1 lowercase,1 Numeric Number",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                : Container(),
          ],
        ));
  }

  Widget _emailInputField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InputFields.ageInputFormField(
          context, "Price", TextInputType.number, _priceController, false,
          (item) {
        return item.length > 0 ? null : "Enter price";
      }),
    );
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      if (_priceController.text == "0")
        ToastMsg.showToastMsg("Please enter a valid price");
      else
        DialogBoxes.confirmationBox(
            context,
            "Update",
            "Are you sure want to update",
            _handleUpdate); //take confirmation form user
    }
  }

  Widget _deleteServiceBtn() {
    return DeleteButtonWidget(
      onPressed: () {
        DialogBoxes.confirmationBox(
            context,
            "Delete",
            "Are you sure want to delete",
            _handleDeleteService); //take confirmation from user
      },
      title: "Delete",
    );
  }

  _handleDeleteService() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    final res = await LabTestService.deleteData(widget.dataDetails.id);
    // print(res);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1); //1 is number of images user can pick
    // setState(() {
    //   _images = res;
    // });
  }

  _handleUpdate() {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // if (_imageUrl == "" &&
    //     _images.length ==
    //         0) // if user not select any image and initial we have no any image
    //   _updateDetails(""); //update data without image
    // else if (_imageUrl != "") //if initial we have image
    //   _updateDetails(_imageUrl); //update data with image
    // else if (_imageUrl == "" && _images.length > 0) _handleUploadImage();
    // //if user select the image then first upload the image then update data in database
    // //  _uploadImg(); //upload image in to database
  }

  void _removeImage() {
    setState(() {
      // _images.clear(); //clear array
      // _imageUrl = "";
    });
  }

  _updateDetails(imageDownloadUrl) async {
    LabTestModel labTestModel = LabTestModel(
      title: titleController.text,
      imageUrl: imageDownloadUrl,
      id: widget.dataDetails.id,
      subTitle: _subTitleController.text,
      clinicId: widget.clinicId,
      price: _priceController.text,
    );
    final res = await LabTestService.updateData(labTestModel);
    print("lplplplpl$res");
    if (res == "already exists") {
      ToastMsg.showToastMsg("Name already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _gLocationInputField() {
    return InputFields.commonInputField(_subTitleController, "Sub Title*",
        (item) {
      return item.length > 0 ? null : "Enter sub title";
    }, TextInputType.text, 1);
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(titleController, "Name*", (item) {
      return item.length > 0 ? null : "Enter Name";
    }, TextInputType.text, 1);
  }

  void _handleUploadImage() async {
    // final res = await UploadImageService.uploadImages(_images[0]);
    // if (res == "0")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "1")
    //   ToastMsg.showToastMsg("Image size must be less the 1MB");
    // else if (res == "2")
    //   ToastMsg.showToastMsg(
    //       "Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload");
    // else if (res == "3" || res == "error")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else if (res == "")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else {
    //   await _updateDetails(res);
    // }
    // setState(() {
    //   _isEnableBtn = true;
    //   _isLoading = false;
    // });
  }
}
