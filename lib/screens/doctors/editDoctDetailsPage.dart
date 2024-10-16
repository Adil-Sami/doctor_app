import 'package:demoadmin/model/doctTimeSlotModel.dart';
import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/service/departmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditDoctDetialsPage extends StatefulWidget {
  final drDetails;
  final clinicId;
  final cityId;
  EditDoctDetialsPage({this.drDetails, this.clinicId, this.cityId});
  @override
  _EditDoctDetialsPageState createState() => _EditDoctDetialsPageState();
}

class _EditDoctDetialsPageState extends State<EditDoctDetialsPage> {
  TextEditingController _textEditingController=TextEditingController();
  bool passValid = true;
  String _clinicOpeningTime = "10:00";
  String _clinicClosingTime = "20:00";
  String _lunchOpeningTime = "13:00";
  String _lunchClosingTime = "14:00";
  bool _isLoading = false;
  bool _stopBooking = false;
  bool _stopwalkin = false;
  bool _payLater=true;
  bool _payNow=true;
  bool _active=false;
  bool _wActive=false;
  bool _vActive=false;

  String _imageUrl = "";
  // List<Asset> _images = <Asset>[];
  String _id = "";
  List<String> deptList = ["Select Department"];
  List<String> deptIdList = [""];
  List <DoctorTimeSlotModel>doctTimeSlots=[];
  bool dialogBoXLoading=false;

  String _selectedDeptId = "";
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _whatsAppNoController = TextEditingController();
  TextEditingController _primaryPhnController = TextEditingController();
  TextEditingController _secondaryPhnController = TextEditingController();
  TextEditingController _aboutUsController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _hNameController = TextEditingController();
  TextEditingController _launchOTCont = TextEditingController();
  TextEditingController _launchCTCont = TextEditingController();
  TextEditingController _serviceTime = TextEditingController();
  TextEditingController _appFeeCont = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _deptNameController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _wspdController = TextEditingController();
  TextEditingController _wspdpController = TextEditingController();
  TextEditingController _vspdController = TextEditingController();

  List _dayCode = [];

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserDetails();
    getAndSetData();
    getTimeSlots();//get and set all initial values
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _serviceTime.dispose();
    _appFeeCont.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    _subTitleController.dispose();
    _whatsAppNoController.dispose();
    _primaryPhnController.dispose();
    _secondaryPhnController.dispose();
    _aboutUsController.dispose();
    _addressController.dispose();
    _deptNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          title: "Update",
          onPressed: _takeConfirmation,
          isEnableBtn: _isEnableBtn,
        ),
        appBar: IAppBars.commonAppBar(context, "Edit Profile"),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    // if (_imageUrl == "")
                    //   if (_images.length == 0)
                    //     ECircularCameraIconWidget(onTap: _handleImagePicker)
                    //   else
                    //     ECircularImageWidget(
                    //       onPressed: _removeImage,
                    //       imageUrl: _imageUrl,
                    //       images: _images,
                    //     )
                    // else
                    //   ECircularImageWidget(
                    //     onPressed: _removeImage,
                    //     imageUrl: _imageUrl,
                    //     images: _images,
                    //   ),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),
                    _inputField(
                        "Subtitle", "Enter sub title", _subTitleController),
                    _inputField(
                        "Hospital Name", "Enter first name", _hNameController),
                    _ammountFiled(),
                    _serviceTimeInputField(),
                    _wActiveWidget(),
                   _wActive? _wspdpFiled():Container(),
                    _wActive?  _buildWalkinTimeSlots():Container(),
                    _vActiveWidget(),
                    _vActive?_vspdFiled():Container(),
                    _vActive?  _buildVideoTimeSlots():Container(),
                    _wspdFiled(),
                    // Center(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(
                    //         "Select any days where you want to close booking in every week",
                    //         style: TextStyle(
                    //           fontFamily: 'OpenSans-SemiBold',
                    //           fontSize: 14,
                    //         )),
                    //   ),
                    // ),
                    // _buildDayCheckedBox("Monday", _monCheckedValue, 1),
                    // _buildDayCheckedBox("Tuesday", _tueCheckedValue, 2),
                    // _buildDayCheckedBox("Wednesday", _wedCheckedValue, 3),
                    // _buildDayCheckedBox("Thursday", _thuCheckedValue, 4),
                    // _buildDayCheckedBox("Friday", _friCheckedValue, 5),
                    // _buildDayCheckedBox("Saturday", _satCheckedValue, 6),
                    // _buildDayCheckedBox("Sunday", _sunCheckedValue, 7),
                    // _inputField(
                    //     "Launch opening time (HH:MM)", "Enter last name", _launchOTCont),
                    // _inputField(
                    //     "Launch closing time (HH:MM)", "Enter sub title", _launchCTCont),
                    InputFields.readableInputField(
                        _deptNameController, "Department", 1),
                    // deptList.length > 0
                    //     ? _genderDropDown()
                    //     : Container(
                    //         child: Padding(
                    //           padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
                    //           child: Text(
                    //             "Please add department",
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //         ),
                    //       ),

                    _emailInputField(),
                    passInputField(_passController, "Password"),
                    confirmPassInputField(
                        _confirmPassController, "Confirm Password"),
                    _phnNumInputField(
                        _primaryPhnController, "Enter primary phone number"),
                    _phnNumInputField(_secondaryPhnController,
                        "Enter secondary phone number"),
                    _phnNumInputField(
                        _whatsAppNoController, "Enter what'sapp phone number"),
                    _descInputField(_addressController, "Address", null),
                    _descInputField(_descController, "Description", null),
                    _descInputField(_aboutUsController, "About us", null),
                    _stopBookingWidget(),
                  //  _stopWalkInWidget(),
                    _payNowWidget(),
                    _payLaterWidget(),
                    _activeWidget(),
                    _deleteServiceBtn()
                  ],
                ),
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

  Widget textField(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        onTap: () async {
          TimeRange result = await showTimeRangePicker(
            start: TimeOfDay(
                hour: int.parse(_clinicOpeningTime.substring(0, 2)),
                minute: int.parse(_clinicOpeningTime.substring(3, 5))),
            end: TimeOfDay(
                hour: int.parse(_clinicClosingTime.substring(0, 2)),
                minute: int.parse(_clinicClosingTime.substring(3, 5))),
            strokeColor: primaryColor,
            handlerColor: primaryColor,
            selectedColor: primaryColor,
            context: context,
          );

          print("result " + result.toString());
          if (result != "null") {
            setState(() {
              if (result.toString().substring(17, 22) ==
                  result.toString().substring(37, 42)) {
                ToastMsg.showToastMsg("please select different times");
              } else {
                _clinicOpeningTime = result.toString().substring(17, 22);
                _clinicClosingTime = result.toString().substring(37, 42);
                //_isEnableBtn = true;
              }
            });
          }

          print("op $_clinicOpeningTime clo $_clinicClosingTime");
        },
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            //labelText: title,
            hintText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget luchTimetextField(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        onTap: () async {
          // print("kkkkkkkkkkkkkkkkkkkkkk");
          TimeRange result = await showTimeRangePicker(
            start: TimeOfDay(
                hour: int.parse(_lunchOpeningTime.substring(0, 2)),
                minute: int.parse(_lunchOpeningTime.substring(3, 5))),
            end: TimeOfDay(
                hour: int.parse(_lunchClosingTime.substring(0, 2)),
                minute: int.parse(_lunchClosingTime.substring(3, 5))),
            strokeColor: primaryColor,
            handlerColor: primaryColor,
            selectedColor: primaryColor,
            context: context,
          );

          //  print("result>>>>>>>>>>>>>>>>>> " + result.toString());
          if (result != "null") {
            setState(() {
              if (result.toString().substring(17, 22) ==
                  result.toString().substring(37, 42)) {
                ToastMsg.showToastMsg("please select different times");
              } else {
                _lunchOpeningTime = result.toString().substring(17, 22);
                _lunchClosingTime = result.toString().substring(37, 42);
                //    isEnableBtn = true;
              }
            });
          }
        },
        readOnly: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            //labelText: title,
            hintText: title,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  _takeConfirmation() {
    // if (_selectedDept == "Select Department") {
    //  ToastMsg.showToastMsg("please select department");
    // } else {
    if(_payLater==false &&_payNow==false)
      ToastMsg.showToastMsg("Must enable at least one option pay later or pay now");
    else{
      print(_selectedDeptId);
      DialogBoxes.confirmationBox(context, "Update",
          "Are you sure you want to update profile details", _handleUpdate);
    }

    // }
    //take a confirmation form the user
  }

  _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      //if all input fields are valid
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });
    //   if (_imageUrl == "" &&
    //       _images.length ==
    //           0) // if user not select any image and initial we have no any image
    //     _updateDetails(""); //update data without image
    //   else if (_imageUrl != "") //if initial we have image
    //     _updateDetails(_imageUrl); //update data with image
    //   else if (_imageUrl == "" &&
    //       _images.length >
    //           0) //if user select the image then first upload the image then update data in database
    //     _handleUploadImage(); //upload image in to database
    //
    }
  }

  _updateDetails(imageDownloadUrl) async {
    // final cryptor = new PlatformStringCryptor();
    // final String key = await cryptor.generateRandomKey();
    // final String encrypted = await cryptor.encrypt(_passController.text, key);
    //print("<<<<<<<<<<<<<<<<<<<<<<<<<<<,$imageDownloadUrl");
    String newDays = "";
    if (_dayCode.length > 0) {
      for (int i = 0; i < _dayCode.length; i++) {
        if (i == 0)
          newDays = _dayCode[0].toString();
        else
          newDays = newDays + "," + _dayCode[i].toString();
      }
    }

    print("New Days $newDays");
    final drProfileModel = DrProfileModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        id: _id,
        description: _descController.text,
        subTitle: _subTitleController.text,
        email: _emailController.text,
        aboutUs: _aboutUsController.text,
        address: _addressController.text,
        pNo1: _primaryPhnController.text,
        pNo2: _secondaryPhnController.text,
        profileImageUrl: imageDownloadUrl,
        whatsAppNo: _whatsAppNoController.text,
        hName: _hNameController.text,
        lunchClosingTime: _lunchClosingTime,
        lunchOpeningTime: _lunchOpeningTime,
        deptId: _selectedDeptId,
        stopBooking: _stopBooking ? "true" : "false",
        clt: _clinicClosingTime,
        opt: _clinicOpeningTime,
        dayCode: newDays,
        serviceTime: _serviceTime.text,
        fee: _appFeeCont.text,
        pass: _passController.text,
        stopWalkIn: _stopwalkin ? "1" : "0",
        active: _active ? "1" : "0",
        payNow: _payNow ? "1" : "0",
        payLater: _payLater ? "1" : "0",
        wspd: _wspdController.text,
        wspdp: _wspdpController.text,
        vspd: _vspdController.text,
      walkin_active:_wActive ? "1" : "0",
      video_active: _vActive ? "1" : "0",
    );
    // final mymap={
    //   "firstName": _firstNameController.text,
    //   "lastName": _lastNameController.text,
    //   "id": _id,
    //   "description": _descController.text,
    //   "subTitle": _subTitleController.text,
    //   "email": _emailController.text,
    //   "aboutUs": _aboutUsController.text,
    //   "address": _addressController.text,
    //   "pNo1": _primaryPhnController.text,
    //   'pNo2': _secondaryPhnController.text,
    //   "profileImageUrl": imageDownloadUrl,
    //   "whatsAppNo": _whatsAppNoController.text,
    //   "hName": _hNameController.text,
    //   "lunchClosingTime": _lunchClosingTime,
    //   "lunchOpeningTime": _lunchOpeningTime,
    //   "deptId": _selectedDeptId,
    //   "stopBooking": _stopBooking ? "true" : "false",
    //   "clt": _clinicClosingTime,
    //   "opt": _clinicOpeningTime,
    //   "dayCode": newDays,
    //   "serviceTime": _serviceTime.text,
    //   "fee": _appFeeCont.text,
    //   "pass": _passController.text,
    //   "stopWalkIn": _stopwalkin?"1":"0",
    //   "wspd": _wspdController.text
    // };
    // print(mymap);

    final res = await DrProfileService.updateData(drProfileModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Email id is already registered");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
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
    // else if (res == "" || res == "null")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else {
    //   await _updateDetails(res);
    // }
    //
    // setState(() {
    //   _isEnableBtn = true;
    //   _isLoading = false;
    // });
  }

  Widget _descInputField(controller, labelText, maxLine) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : "Enter description";
    }, TextInputType.multiline, maxLine);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
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

  Widget _stopBookingWidget() {
    return ListTile(
      title: Text("online booking"),
      subtitle: _stopBooking
          ? Text("turn off to start online booking")
          : Text("turn on to stop online booking"),
      trailing: IconButton(
        icon: _stopBooking
            ? Icon(
                Icons.toggle_on_outlined,
                color: Colors.green,
                size: 35,
              )
            : Icon(
                Icons.toggle_off_outlined,
                color: Colors.red,
                size: 35,
              ),
        onPressed: () {
          setState(() {
            _stopBooking = !_stopBooking;
          });
        },
      ),
    );
  }

  Widget _payNowWidget() {
    return ListTile(
      title: Text("Pay Now"),
      subtitle: _payNow
          ? Text("turn off to hide pay now option")
          : Text("turn on to show pay now option"),
      trailing: IconButton(
        icon: _payNow
            ? Icon(
          Icons.toggle_on_outlined,
          color: Colors.green,
          size: 35,
        )
            : Icon(
          Icons.toggle_off_outlined,
          color: Colors.red,
          size: 35,
        ),
        onPressed: () {
          setState(() {
            _payNow = !_payNow;
          });
        },
      ),
    );
  }
  Widget _payLaterWidget() {
    return ListTile(
      title: Text("Pay Later"),
      subtitle: _payLater
          ? Text("turn off to hide pay later option")
          : Text("turn on to show pay later option"),
      trailing: IconButton(
        icon: _payLater
            ? Icon(
          Icons.toggle_on_outlined,
          color: Colors.green,
          size: 35,
        )
            : Icon(
          Icons.toggle_off_outlined,
          color: Colors.red,
          size: 35,
        ),
        onPressed: () {
          setState(() {
            _payLater = !_payLater;
          });
        },
      ),
    );
  }
  Widget _activeWidget() {
    return ListTile(
      title: Text("Active"),
      subtitle: _active
          ? Text("turn off to hide doctor")
          : Text("turn on to show doctor"),
      trailing: IconButton(
        icon: _active
            ? Icon(
          Icons.toggle_on_outlined,
          color: Colors.green,
          size: 35,
        )
            : Icon(
          Icons.toggle_off_outlined,
          color: Colors.red,
          size: 35,
        ),
        onPressed: () {
          setState(() {
            _active = !_active;
          });
        },
      ),
    );
  }
  Widget _wActiveWidget() {
    return ListTile(
      title: Text("Active Walk-in slots"),
      subtitle: _wActive
          ? Text("turn off to deactivate")
          : Text("turn on to active"),
      trailing: IconButton(
        icon: _wActive
            ? Icon(
          Icons.toggle_on_outlined,
          color: Colors.green,
          size: 35,
        )
            : Icon(
          Icons.toggle_off_outlined,
          color: Colors.red,
          size: 35,
        ),
        onPressed: () {
          setState(() {
            _wActive = !_wActive;
          });
        },
      ),
    );
  }
  Widget _vActiveWidget() {
    return ListTile(
      title: Text("Active video consultant slots"),
      subtitle: _vActive
          ? Text("turn off to deactivate")
          : Text("turn on to active"),
      trailing: IconButton(
        icon: _vActive
            ? Icon(
          Icons.toggle_on_outlined,
          color: Colors.green,
          size: 35,
        )
            : Icon(
          Icons.toggle_off_outlined,
          color: Colors.red,
          size: 35,
        ),
        onPressed: () {
          setState(() {
            _vActive = !_vActive;
          });
        },
      ),
    );
  }
  Widget _phnNumInputField(controller, labelText) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length == 13
          ? null
          : "Enter a 10 digit mobile number with country code";
    }, TextInputType.phone, 1);
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1); //1 is the number of images that user can pick
    //
    // setState(() {
    //   _images = res;
    // });
  }

  void _removeImage() {
    setState(() {
      // _images.clear(); //clear array of the image
      // _imageUrl = "";
    });
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    //  print(decrypted);
    // final res =
    // await DrProfileService.getData(); //fetch all details of the doctors
    // print(res["profileImageUrl"]);
    setState(() {
      //set all the values in to text fields
      _wspdController.text = widget.drDetails.wspd;
      _wspdpController.text=widget.drDetails.wspdp;
      _vspdController.text = widget.drDetails.vspd;
      _emailController.text = widget.drDetails.email;
      _passController.text = widget.drDetails.pass;
      _confirmPassController.text = widget.drDetails.pass;
      _serviceTime.text = widget.drDetails.serviceTime;
      _lastNameController.text = widget.drDetails.lastName;
      _firstNameController.text = widget.drDetails.firstName;
      _imageUrl = widget.drDetails.profileImageUrl;
      _descController.text = widget.drDetails.description;
      _subTitleController.text = widget.drDetails.subTitle;
      _whatsAppNoController.text = widget.drDetails.whatsAppNo;
      _primaryPhnController.text = widget.drDetails.pNo1;
      _secondaryPhnController.text = widget.drDetails.pNo2;
      _aboutUsController.text = widget.drDetails.aboutUs;
      _addressController.text = widget.drDetails.address;
      _id = widget.drDetails.id;
      _hNameController.text = widget.drDetails.hName;
      _launchCTCont.text = widget.drDetails.lunchClosingTime;
      _launchOTCont.text = widget.drDetails.lunchOpeningTime;
      _lunchClosingTime = widget.drDetails.lunchClosingTime;
      _lunchOpeningTime = widget.drDetails.lunchOpeningTime;
      _clinicClosingTime = widget.drDetails.clt;
      _clinicOpeningTime = widget.drDetails.opt;
      _appFeeCont.text = widget.drDetails.fee;
      if (widget.drDetails.stopBooking == "true")
        _stopBooking = true;
      else
        _stopBooking = false;

      if (widget.drDetails.stopWalkIn == "0")
        _stopwalkin = false;
      else
        _stopwalkin = true;
      if (widget.drDetails.active == "0")
        _active = false;
      else
        _active = true;
      if (widget.drDetails.active == "0")
        _payNow = false;
      else
        _payNow = true;
      if (widget.drDetails.payLater == "0")
        _payLater = false;
      else
        _payLater = true;
      if (widget.drDetails.walkin_active == "0")
        _wActive = false;
      else
        _wActive = true;
      if (widget.drDetails.video_active == "0")
        _vActive = false;
      else
        _vActive = true;
      if (widget.drDetails.dayCode != null && widget.drDetails.dayCode != "") {
        final day = widget.drDetails.dayCode.toString().split(",");
        for (var e in day) {
          _dayCode.add(int.parse(e));
        }
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  Widget _ammountFiled() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: null,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _appFeeCont,
        validator: (item) {
          if (item!.length == 0)
            return "Enter price";
          else if (item.length > 5)
            return "only enter a 5 digit price";
          else
            return null;
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Enter price INR",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  Widget _wspdFiled() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: null,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _wspdController,
        validator: (item) {
          // if (item!.length == 0)
          //   return "Enter walk in slot per day";
          // else
          if (int.parse(item!) > 0 && int.parse(item) <= 50)
            return null;
          else
            return "only enter 0 to 50 numbers";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Walk-in slot per day KISOk",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }
  Widget _wspdpFiled() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: null,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _wspdpController,
        validator: (item) {
          // if (item!.length == 0)
          //   return "Enter walk in slot per day";
          // else
          if (int.parse(item!) > 0 && int.parse(item) <= 50)
            return null;
          else
            return "only enter 0 to 50 numbers";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Walk-in slot per day",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }
  Widget _vspdFiled() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: null,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: _vspdController,
        validator: (item) {
          // if (item!.length == 0)
          //   return "Enter walk in slot per day";
          // else
          if (int.parse(item!) > 0 && int.parse(item) <= 50)
            return null;
          else
            return "only enter 0 to 50 numbers";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Video consultant slot per day",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }

  // _genderDropDown() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
  //     child: DropdownButton<String>(
  //       focusColor: Colors.white,
  //       value: _selectedDept,
  //       //elevation: 5,
  //       style: TextStyle(color: Colors.white),
  //       iconEnabledColor: btnColor,
  //       items: deptList.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(
  //             value,
  //             style: TextStyle(color: Colors.black),
  //           ),
  //         );
  //       }).toList(),
  //       hint: Text(
  //         "Department",
  //       ),
  //       onChanged: (String value) {
  //         setState(() {
  //           print(value);
  //           _selectedDept = value;
  //           for (int i = 0; i < deptList.length; i++) {
  //             if (deptList[i]==value) {
  //               setState(() {
  //                 _selectedDeptId = deptIdList[i];
  //               });
  //               print(_selectedDeptId);
  //             }
  //           }
  //         });
  //       },
  //     ),
  //   );
  // }
  //
  void getTimeSlots() async {
    setState(() {
      _isLoading = true;
    });
    final getSlots=await DrProfileService.getDoctTimeSlot(widget.drDetails.id);
    if(getSlots.isNotEmpty)
      setState(() {
        doctTimeSlots=getSlots;
      });

    setState(() {
      _isLoading = false;
    });
  }
  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await DepartmentService.getData(widget.clinicId, widget.cityId);
    if (res != "null") {
      for (var e in res) {
        setState(() {
          deptList.add(e.name);
          deptIdList.add(e.id);
          if (e.id == widget.drDetails.deptId) {
            _selectedDeptId = e.id;
            _deptNameController.text = e.name;
          }
        });
      }
    };

    setState(() {
      _isLoading = false;
    });
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

    final res = await DrProfileService.deleteData(widget.drDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ToastMsg.showToastMsg("Something went wrong");
      setState(() {
        _isLoading = false;
        _isEnableBtn = true;
      });
    }
  }

  _serviceTimeInputField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLines: 1,
        controller: _serviceTime,
        validator: (item) {
          if (item!.length > 0) {
            if (item.length < 3)
              return null;
            else
              return "Enter valid interval";
          } else
            return "Enter time interval";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Time interval in (MIN)",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
            )),
      ),
    );
  }
  openDialogBox(title,context,dayCode,slotType) {
    bool isLoading=false;
    return showDialog(
       barrierDismissible:isLoading,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: new Text(title),
                content: Form(
                  key: _formKey2,
                  child:isLoading?Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LoadingIndicatorWidget(),
                    ],
                  ): Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputFields.commonInputField(
                          _textEditingController, "Time Slot",
                              (item){return item!.length>0?null:"Enter time slot";}
                          , TextInputType.text, 1),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left:20.0),
                        child: Text("Ex. 10 AM To 2 PM ",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12
                          ),),
                      ),
                    ],
                  ),
                ),
                actions: isLoading?null:<Widget>[
                  new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: btnColor,
                      ),
                      child: new Text("Submit"),
                      onPressed:() async{
                        setState((){
                          isLoading=true;
                        });
                        final res=await DrProfileService.addTimeSlot(
                            time_slot: _textEditingController.text,
                            day_code: dayCode,
                            doct_id: widget.drDetails.id,
                            slot_type: slotType);

                        if(res=="success"){
                          ToastMsg.showToastMsg("Success");
                          Navigator.of(context).pop();
                          getTimeSlots();
                        }else ToastMsg.showToastMsg("Something went wrong");
                        setState((){
                          isLoading=false;
                        });

                      }),
                  new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: btnColor,
                      ),
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  // usually buttons at the bottom of the dialog
                ],
              );
            }
        );
      },
    );
  }

  _buildButton(onPressed) {
    return  SizedBox(
      width: 110,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Center(
              child: Row(
                children: [
                  Text("Add Slot",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  Icon(Icons.add)
                ],
              )),
          onPressed: onPressed),
    );
  }

  _buildTimeSlotList(String dayCode,String slotType) {
  return  ListView.builder(
        shrinkWrap: true,
        itemCount: doctTimeSlots.length,
        itemBuilder: (context, index) {
          return doctTimeSlots[index].slotType==slotType&&doctTimeSlots[index].dayCode==dayCode?
          ListTile(title: Text(doctTimeSlots[index].timeSlot),
          trailing: IconButton(onPressed: ()async{
            // setState(() {
            //   _isLoading=true;
            // });
            final deleteData=await DrProfileService.deleteDoctTimeSlot(doctTimeSlots[index].tsId.toString());
            if(deleteData=="success"){
              ToastMsg.showToastMsg("success");
              getTimeSlots();
             // Navigator.pop(context);
            }else{
              ToastMsg.showToastMsg("something went wrong");
            }
            // setState(() {
            //   _isLoading=false;
            // });

          },icon: Icon(Icons.delete),color: Colors.red,),
          ):Container();
        });
  }

  _buildVideoTimeSlots() {
    return ExpansionTile(title: Text("Video-Schedule"),
      children: [
        ExpansionTile(title: Text("Monday"),
          children: [
            _buildTimeSlotList("1","1"),
            _buildButton((){
              openDialogBox("Monday",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("TuesDay"),
          children: [
            _buildTimeSlotList("2","1"),
            _buildButton((){
              openDialogBox("TuesDay",context,"2","1");
            })
          ],),
        ExpansionTile(title: Text("Wednesday"),
          children: [
            _buildTimeSlotList("3","1"),
            _buildButton((){
              openDialogBox("Wednesday",context,"3","1");
            })
          ],),
        ExpansionTile(title: Text("Thursday"),
          children: [
            _buildTimeSlotList("4","1"),
            _buildButton((){
              openDialogBox("Thursday",context,"4","1");
            })
          ],),
        ExpansionTile(title: Text("Friday"),
          children: [
            _buildTimeSlotList("5","1"),
            _buildButton((){
              openDialogBox("Friday",context,"5","1");
            })
          ],),
        ExpansionTile(title: Text("Saturday"),
          children: [
            _buildTimeSlotList("6","1"),
            _buildButton((){
              openDialogBox("Saturday",context,"6","1");
            })
          ],),
        ExpansionTile(title: Text("Sunday"),
          children: [
            _buildTimeSlotList("7","1"),
            _buildButton((){
              openDialogBox("Sunday",context,"7","1");
            })
          ],)

      ],);
  }
  _buildWalkinTimeSlots() {
    return ExpansionTile(title: Text("Walkin-Schedule"),
      children: [
        ExpansionTile(title: Text("Monday"),
          children: [
            _buildTimeSlotList("1","0"),
            _buildButton((){
              openDialogBox("Monday",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("TuesDay"),
          children: [
            _buildTimeSlotList("2","0"),
            _buildButton((){
              openDialogBox("TuesDay",context,"2","0");
            })
          ],),
        ExpansionTile(title: Text("Wednesday"),
          children: [
            _buildTimeSlotList("3","0"),
            _buildButton((){
              openDialogBox("Wednesday",context,"3","0");
            })
          ],),
        ExpansionTile(title: Text("Thursday"),
          children: [
            _buildTimeSlotList("4","0"),
            _buildButton((){
              openDialogBox("Thursday",context,"4","0");
            })
          ],),
        ExpansionTile(title: Text("Friday"),
          children: [
            _buildTimeSlotList("5","0"),
            _buildButton((){
              openDialogBox("Friday",context,"5","0");
            })
          ],),
        ExpansionTile(title: Text("Saturday"),
          children: [
            _buildTimeSlotList("6","0"),
            _buildButton((){
              openDialogBox("Saturday",context,"6","0");
            })
          ],),
        ExpansionTile(title: Text("Sunday"),
          children: [
            _buildTimeSlotList("7","0"),
            _buildButton((){
              openDialogBox("Sunday",context,"7","0");
            })
          ],)

      ],);
  }
}
