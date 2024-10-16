import 'dart:convert';

import 'package:demoadmin/model/userModel.dart';
import 'package:demoadmin/screens/userScreen/editUserProfilePage.dart';
import 'package:demoadmin/service/addData.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/countrypicker.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:demoadmin/model/workerModel.dart';
import 'package:demoadmin/service/workerService.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewWorkerPage extends StatefulWidget {
  const AddNewWorkerPage({Key? key}) : super(key: key);

  @override
  _AddNewWorkerPageState createState() =>
      _AddNewWorkerPageState();
}

class _AddNewWorkerPageState
    extends State<AddNewWorkerPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _mobController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String clinicId="";
  String workerId="";
  String _selectedGender = 'Gender';
  // List<Asset> _images = <Asset>[];

  bool numberExists=true;
  bool checked=false;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    setFDId();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: IAppBars.commonAppBar(context, "New Worker"),
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
            }
            else
              _handleUpload();
          }
        },
        title: "Add",
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
              SizedBox(height: 50),
              // numberExists?Container():  _images.length == 0
              //     ? CircularCameraIconWidget(onTap: _handleImagePicker)
              //     : CircularImageWidget(
              //   images: _images,
              //   onPressed: _removeImage,
              // ),

              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: TextFormField(

                        readOnly: checked,
                        cursorColor: btnColor,
                        validator: (item) {
                          return item!.length ==10
                              ? null
                              : "Enter a valid 10 digit Phone number";
                        },
                        controller: _mobController,
                        keyboardType: TextInputType.number,
                        onTap: () {
                          FocusScopeNode currentFocus =
                          FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          suffix: IconButton(icon: Icon(Icons.edit),
                          onPressed: (){
                            setState(() {
                              checked=false;
                              numberExists=true;
                            });
                          }),
                            labelText: "Phone Number",
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: primaryColor, width: 1.0),
                            )),
                      ))
                ],
              ),
              checked?Container():numberExists?DeleteButtonWidget(title: "Sync",onPressed: (){
                if(_formKey.currentState!.validate()){
                  checkNumberExists();

                }
              },):Container(),
              numberExists?Container():InputFields.textInputFormField(
                context,
                "First Name*",
                TextInputType.text,
                _firstNameController,
                1,
                    (item) {
                  return item.length > 0 ? null : "Enter your first name";
                },
              ),
              numberExists?Container():  InputFields.textInputFormField(
                context,
                "Last Name*",
                TextInputType.text,
                _lastNameController,
                1,
                    (item) {
                  return item.length > 0 ? null : "Enter last name";
                },
              ),
              numberExists?Container():   _genderDropDown(),
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
              style: TextStyle(color: Colors.black),
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

  void _handleUploadSubmit(imageUrl) async {
    print("ppppppppppppppppppppppp");
    String fcmId = "";
    setState(() {
      _isLoading = true;
    });

      final workerModel = WorkerModel(
        gender: _selectedGender,
        firstName: _firstNameController.text,
        imageUrl: imageUrl,
        lastName: _lastNameController.text,
        phone: _mobController.text,
        clinicId: clinicId

      );

      final res = await WorkerService.addData(workerModel);

      if (res == "already exists") {
        ToastMsg.showToastMsg("Phone Number already exists");
      } else if (res == "success") {
        ToastMsg.showToastMsg("Successfully Uploaded");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/WorkerListPage', ModalRoute.withName('/HomePage'));
      } else if (res == "error") {
        ToastMsg.showToastMsg('Something went wrong');
      }
      setState(() {
        _isLoading = false;
      });

  }
  void _handleSync(imageUrl) async {
    setState(() {
      _isLoading = true;
    });

    final res = await WorkerService.addDataWorkerSync(clinicId:clinicId,workerId: workerId);

    if (res == "already exists") {
      ToastMsg.showToastMsg("Phone Number already sync with your clinic");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully sync");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/WorkerListPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg('Something went wrong');
    }
    setState(() {
      _isLoading = false;
    });

  }
  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(
    //     _images, mounted, 1); //pick image with one limit
    // setState(() {
    //   _images = res;
    // });
  }

  _handleUpload() {
    // setState(() {
    //   _isLoading = true;
    // });
    // _images.length > 0
    //     ? _uploadImg()
    //     : _handleUploadSubmit(""); //check user selected image or not
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
    // else if (res == "" || res == "null")
    //   ToastMsg.showToastMsg("Something went wrong");
    // else
    //   _handleUploadSubmit(res);
    //
    // setState(() {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }
  void _removeImage() {
    // setState(() {
    //   _images.clear(); //clean array
    // });
  }


  void setFDId() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    clinicId= preferences.getString("fdClinicId")??"";
  }

  void checkNumberExists()async {
    setState(() {
      _isLoading=true;
    });
    final res=await WorkerService.getDataByPhn(_mobController.text);
    print(res);
    if(res.isNotEmpty){
      workerId=res[0].id??"";
      numberExists=true;
      print(workerId);
      print(clinicId);
     _handleSync("");
    }else{
      workerId="";
      numberExists=false;
    }
    setState(() {
      checked=true;
      _isLoading=false;
    });
  }
}
