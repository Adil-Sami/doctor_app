import 'package:demoadmin/model/pharmacyModel.dart';
import 'package:demoadmin/service/pharmaService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPharmacyUserPage extends StatefulWidget {
  const EditPharmacyUserPage({Key? key}) : super(key: key);

  @override
  _EditPharmacyUserPageState createState() => _EditPharmacyUserPageState();
}

class _EditPharmacyUserPageState extends State<EditPharmacyUserPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  // List<Asset> _images = <Asset>[];
  String cityId = "";
  String pharmaId = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  bool passValid = true;
  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";
  String checkValue = "1";

  @override
  void initState() {
    // TODO: implement initState
    getAndSetData();
    //initialize all textController values

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
      appBar: IAppBars.commonAppBar(context, "Edit Profile"),
      bottomNavigationBar: _isLoading
          ? null
          : BottomNavBarWidget(
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
                    passInputField(_passController, "Password"),
                    confirmPassInputField(
                        _confirmPassController, "Confirm Password"),
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

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) {
      DialogBoxes.confirmationBox(
          context,
          "Update",
          "Are you sure want to update",
          _handleUpdate); //take confirmation form user
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
    // setState(() {
    //   _images.clear(); //clear array
    //   _imageUrl = "";
    // });
  }

  _updateDetails(imageDownloadUrl) async {
    PharmacyModel pharmacyModel = PharmacyModel(
      title: titleController.text,
      imageUrl: imageDownloadUrl,
      id: pharmaId,
      subTitle: _subTitleController.text,
      cityId: cityId,
      email: _emailController.text,
      pass: _passController.text,
    );
    final res = await PharmacyService.updateData(pharmacyModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Email id already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
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
    return InputFields.commonInputField(titleController, "Title*", (item) {
      return item.length > 0 ? null : "Enter Pharmacy tile";
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

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final phamraId = preferences.getString("pharmaId") ?? "";
    this.pharmaId = phamraId;

    final res = await PharmacyService.getDataByApId(pid: phamraId);
    cityId = res[0].cityId;
    titleController.text = res[0].title;
    _subTitleController.text = res[0].subTitle;
    _emailController.text = res[0].email;
    _passController.text = res[0].pass;
    _confirmPassController.text = res[0].pass;
    _imageUrl = res[0].imageUrl;

    setState(() {
      _isLoading = false;
    });
  }
}
