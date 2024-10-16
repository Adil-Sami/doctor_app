import 'dart:convert';

import 'package:demoadmin/model/userModel.dart';
import 'package:demoadmin/screens/walkin/walkinDepartment.dart';
import 'package:demoadmin/service/addData.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/checkScreenAdap.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/countrypicker.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterNewUsersPage extends StatefulWidget {
  final phn;
  const RegisterNewUsersPage({Key? key, this.phn}) : super(key: key);

  @override
  _RegisterNewUsersPageState createState() => _RegisterNewUsersPageState();
}

class _RegisterNewUsersPageState extends State<RegisterNewUsersPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _mobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _countryCodeControlller = TextEditingController();
  String _selectedGender = 'Gender';

  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _mobController.text = widget.phn;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (CheckDeviceScreen().CheckDeviceScreenPT())
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      appBar: CheckDeviceScreen().CheckDeviceScreenPT()
          ? AppBar(
              title: Text(
                "New Registrationnnn",
                style: TextStyle(fontSize: 25),
              ),
              backgroundColor: appBarColor,
            )
          : IAppBars.commonAppBar(context, "New Registration"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_selectedGender == "Gender") {
              Fluttertoast.showToast(
                  msg: "Please select gender",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 14.0);
            } else if (_countryCodeControlller.text == "")
              ToastMsg.showToastMsg("Select country code");
            else
              _handleUpload();
          }
        },
        title: "Next",
        isEnableBtn: _isLoading ? false : true,
      ),
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 15, right: 15),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(flex: 1, child: _countryCodeInputField()),
                        SizedBox(width: 10),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                            style: CheckDeviceScreen().CheckDeviceScreenPT()
                                ? TextStyle(fontSize: 24)
                                : TextStyle(fontSize: 16),
                            maxLines: 1,
                            readOnly: true,
                            controller: _mobController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelStyle:
                                    CheckDeviceScreen().CheckDeviceScreenPT()
                                        ? TextStyle(fontSize: 24)
                                        : TextStyle(fontSize: 16),
                                labelText: "Phone Number",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[200]!),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 1.0),
                                )),
                          ),
                        ),
                      ],
                    ),
                    CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.textInputFormFieldTablet(
                            context,
                            "First Name*",
                            TextInputType.text,
                            _firstNameController,
                            1,
                            (item) {
                              return item.length > 0
                                  ? null
                                  : "Enter your first name";
                            },
                          )
                        : InputFields.textInputFormField(
                            context,
                            "First Name*",
                            TextInputType.text,
                            _firstNameController,
                            1,
                            (item) {
                              return item.length > 0
                                  ? null
                                  : "Enter your first name";
                            },
                          ),
                    CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.textInputFormFieldTablet(
                            context,
                            "Last Name*",
                            TextInputType.text,
                            _lastNameController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter last name";
                            },
                          )
                        : InputFields.textInputFormField(
                            context,
                            "Last Name*",
                            TextInputType.text,
                            _lastNameController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter last name";
                            },
                          ),
                    CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.textInputFormFieldTablet(
                            context,
                            "Email",
                            TextInputType.emailAddress,
                            _emailController,
                            1,
                            (item) {
                              Pattern pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = new RegExp(pattern.toString());
                              if (item.length > 0) {
                                if (!regex.hasMatch(item) || item == null)
                                  return 'Enter a valid email address';
                                else
                                  return null;
                              } else
                                return null;
                            },
                          )
                        : InputFields.textInputFormField(
                            context,
                            "Email",
                            TextInputType.emailAddress,
                            _emailController,
                            1,
                            (item) {
                              Pattern pattern =
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                  r"{0,253}[a-zA-Z0-9])?)*$";
                              RegExp regex = new RegExp(pattern.toString());
                              if (item.length > 0) {
                                if (!regex.hasMatch(item) || item == null)
                                  return 'Enter a valid email address';
                                else
                                  return null;
                              } else
                                return null;
                            },
                          ),
                    CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.ageInputFormFieldTablet(
                            context,
                            "Age*",
                            TextInputType.number,
                            _ageController,
                            false,
                            (item) {
                              if (item.length > 0 && item.length <= 3)
                                return null;
                              else if (item.length > 3)
                                return "Enter valid age";
                              else
                                return "Enter age";
                            },
                          )
                        : InputFields.ageInputFormField(
                            context,
                            "Age*",
                            TextInputType.number,
                            _ageController,
                            false,
                            (item) {
                              if (item.length > 0 && item.length <= 3)
                                return null;
                              else if (item.length > 3)
                                return "Enter valid age";
                              else
                                return "Enter age";
                            },
                          ),
                    _genderDropDown(),
                    CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.textInputFormFieldTablet(
                            context,
                            "City*",
                            TextInputType.text,
                            _cityController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter city";
                            },
                          )
                        : InputFields.textInputFormField(
                            context,
                            "City*",
                            TextInputType.text,
                            _cityController,
                            1,
                            (item) {
                              return item.length > 0 ? null : "Enter city";
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 0, right: 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Gender',
          'Male',
          'Female',
          'Other',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      CheckDeviceScreen().CheckDeviceScreenPT() ? 22 : 16),
            ),
          );
        }).toList(),
        hint: Text(
          "Select Gender",
        ),
        onChanged: (String? value) {
          setState(() {
            print(value);
            _selectedGender = value!;
          });
        },
      ),
    );
  }

  void _handleUpload() async {
    String fcmId = "";
    setState(() {
      _isLoading = true;
    });

    final pattern = RegExp('\\s+'); //remove all space
    final fullName = _firstNameController.text + _lastNameController.text;
    String searchByName = fullName.toLowerCase().replaceAll(pattern, "");
    // SharedPreferences prefs=await SharedPreferences.getInstance();
    // final phone=prefs.getString("phn");
    final userModel = UserModel(
        uId: "",
        searchByName: searchByName,
        city: _cityController.text,
        age: _ageController.text,
        gender: _selectedGender,
        email: _emailController.text,
        fcmId: fcmId,
        firstName: _firstNameController.text,
        imageUrl: "",
        lastName: _lastNameController.text,
        phone: widget.phn,
        pNo: _countryCodeControlller.text + widget.phn);
    final insertStatus = await UserService.addData(userModel);
    // print("lplplplplplplplplplpl$insertStatus");
    if (insertStatus == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    } else {
      var jsonData = await json.decode(insertStatus);
      if (jsonData['status'] == "true") {
        await AddData.addRegisterDetails(jsonData['id'].toString());
        ToastMsg.showToastMsg("Registered");
        SharedPreferences preferences = await SharedPreferences.getInstance();
        final clinicId = preferences.getString("fdClinicId");
        final getUserDetails = await UserService.getDataByPhn(widget.phn);
        if (getUserDetails.length > 0) {
          final getClinicData =
              await ClinicService.getDataByClinicId(clinicId ?? "");
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalkinDepartmentPage(
                  userModel: getUserDetails[0],
                  clinicId: getClinicData[0].id.toString(),
                  cityId: getClinicData[0].cityId.toString(),
                  cityName: getClinicData[0].cityName,
                  clinicLocationName: getClinicData[0].locationName,
                  clinicName: getClinicData[0].title),
            ),
          );
        } else {
          Navigator.pop(context);
          ToastMsg.showToastMsg('Something went wrong');
        }
      } else
        ToastMsg.showToastMsg('Something went wrong');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _countryCodeInputField() {
    return CheckDeviceScreen().CheckDeviceScreenPT()
        ? InputFields.countryCodeInputFieldTablet(
            context,
            _countryCodeControlller,
            () {
              _countryCodePicker();
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
          )
        : InputFields.countryCodeInputField(
            context,
            _countryCodeControlller,
            () {
              _countryCodePicker();
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
          );
  }

  _countryCodePicker() async {
    final country = await CountryPicker.countryCodePicker(context);
    if (country != null) {
      print("Selected Country is: ${country.callingCode}");

      setState(() {
        _countryCodeControlller.text = country.callingCode;
        // _selectedCounteryCode = country.callingCode;

        // country.callingCode;
      });
    }
  }
}
