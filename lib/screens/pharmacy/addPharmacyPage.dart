import 'dart:convert';
import 'package:demoadmin/model/pharmacyModel.dart';
import 'package:demoadmin/service/addData.dart';
import 'package:demoadmin/service/pharmaService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';

class AddPharmaPage extends StatefulWidget {
  final cityId;
  final cityName;
  AddPharmaPage({this.cityId, this.cityName});
  @override
  _AddPharmaPageState createState() => _AddPharmaPageState();
}

class _AddPharmaPageState extends State<AddPharmaPage> {
  bool passValid = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String checkValue = "1";
  // List<Asset> _images = <Asset>[];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _subTitleController.dispose();
    super.dispose();
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = new RegExp(pattern.toString());
      if (!regex.hasMatch(item) || item == null)
        return 'Enter a valid email address';
      else
        return null;
    }, TextInputType.emailAddress, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Pharmacy"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add",
        onPressed: _takeConfirmation,
        isEnableBtn: _isEnableBtn,
      ),
      body: _isLoading
          ? Center(child: LoadingIndicatorWidget())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    // _images.length == 0
                    //     ? CircularCameraIconWidget(onTap: _handleImagePicker)
                    //     : CircularImageWidget(
                    //         images: _images,
                    //         onPressed: _removeImage,
                    //       ),
                    _serviceNameInputField(),
                    _locationInputField(),
                    _emailInputField(),
                    passInputField(_passController, "Password"),
                    confirmPassInputField(
                        _confirmPassController, "Confirm Password"),
                  ],
                ),
              ),
            ),
    );
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

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_nameController, "Title*", (item) {
      return item.length > 0 ? null : "Enter Title";
    }, TextInputType.text, 1);
  }

  Widget _locationInputField() {
    return InputFields.commonInputField(_subTitleController, "Sub Title*",
        (item) {
      return item.length > 0 ? null : "Enter Sub Title";
    }, TextInputType.text, 1);
  }

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Add New",
          "Are you sure want to add new pharmacy",
          _handleUpload); //take a confirmation from the user
    }
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1); //pick image with one limit
    // setState(() {
    //   _images = res;
    // });
  }

  _handleUpload() {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    // _images.length > 0
    //     ? _uploadImg()
    //     : _uploadData(""); //check user selected image or not
  }

  void _removeImage() {
    setState(() {
      // _images.clear(); //clean array
    });
  }

  _uploadData(imageDownloadUrl) async {
    print(widget.cityName);
    PharmacyModel pharmacyModel = PharmacyModel(
        title: _nameController.text,
        imageUrl: imageDownloadUrl,
        subTitle: _subTitleController.text,
        cityId: widget.cityId,
        pass: _passController.text,
        email: _emailController.text);
    final res2 = await PharmacyService.addData(pharmacyModel);
    if (res2 == "error") {
      ToastMsg.showToastMsg('Something went wrong');
      //   ToastMsg.showToastMsg("Email id already exists");
    } else {
      var jsonData = await json.decode(res2);
      if (jsonData['status'] == "true") {
        if (jsonData['msg'] == "already exists") {
          ToastMsg.showToastMsg("Email id is already registered");
        } else if (jsonData['msg'] == "added") {
          await AddData.addPharmaDetails(jsonData['id'].toString());
          ToastMsg.showToastMsg("Successfully Uploaded");
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else
        ToastMsg.showToastMsg('Something went wrong');

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     '/CityListPage', ModalRoute.withName('/'));
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _uploadImg() async {
    // final res = await UploadImageService.uploadImages(
    //     _images[0]); //upload image in the database
    // //all this error we have sated in the the php files
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
    // else
    //   await _uploadData(res);
    //
    // setState(() {
    //   setState(() {
    //     _isEnableBtn = true;
    //     _isLoading = false;
    //   });
    // });
  }
}
