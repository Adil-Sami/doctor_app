import 'package:demoadmin/model/frontDeskModel.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/fdService.dart';

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

class UpdateFDPage extends StatefulWidget {
  final dataDetails;
  const UpdateFDPage({Key? key, this.dataDetails}) : super(key: key);

  @override
  _UpdateFDPageState createState() => _UpdateFDPageState();
}

class _UpdateFDPageState extends State<UpdateFDPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // List<Asset> _images = <Asset>[];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  String ingDropdownValue = 'Select Clinic';
  String selectedClinicId = "";
  List ingItems = [
    {"clinicName": 'Select Clinic'}
  ];

  bool passValid = true;

  bool _isEnableBtn = true;
  bool _isLoading = false;
  String _imageUrl = "";
  String checkValue = "1";

  @override
  void initState() {
    // TODO: implement initState
    //initialize all textController values
    getAndSetData();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Edit Clinic"),
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
                    InputFields.commonInputField(_nameController, "First Name*",
                        (item) {
                      return item.length > 0 ? null : "Enter first name";
                    }, TextInputType.text, 1),
                    InputFields.commonInputField(
                        _lastNameController, "Last Name*", (item) {
                      return item.length > 0 ? null : "Enter last name";
                    }, TextInputType.text, 1),
                    InputFields.commonInputField(_emailController, "Email",
                        (item) {
                      Pattern pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = new RegExp(pattern.toString());
                      if (!regex.hasMatch(item) || item == null)
                        return 'Enter a valid email address';
                      else
                        return null;
                    }, TextInputType.emailAddress, 1),
                    passInputField(_passController, "Password"),
                    confirmPassInputField(
                        _confirmPassController, "Confirm Password"),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, bottom: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: ingDropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: ingItems.map((itemss) {
                                return DropdownMenuItem(
                                  value: itemss['clinicName'],
                                  child: Text(itemss['clinicName']),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (newValue) {
                                if (newValue != "Select Clinic") {
                                  for (int i = 0; i < ingItems.length; i++) {
                                    if (ingItems[i]['clinicName'] == newValue) {
                                      setState(() {
                                        ingDropdownValue =
                                            ingItems[i]['clinicName'];
                                        selectedClinicId =
                                            ingItems[i]['clinicId'];
                                      });

                                      break;
                                    }
                                  }
                                }

                                //   }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    _deleteServiceBtn()
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

  _takeConfirmation() {
    if (_formKey.currentState!.validate()) if (ingDropdownValue ==
        "Select Clinic")
      ToastMsg.showToastMsg("Select Clinic");
    else {
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
    final res = await FdService.deleteData(widget.dataDetails.id);
    // print(res);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Deleted");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/FDListPage', ModalRoute.withName('/HomePage'));
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
    FrontDeskModel clinicModel = FrontDeskModel(
        //   title: _clinicNameController.text,
        imageUrl: imageDownloadUrl,
        id: widget.dataDetails.id.toString(),
        pass: _passController.text,
        email: _emailController.text,
        clinicId: selectedClinicId.toString(),
        firstName: _nameController.text,
        lastName: _lastNameController.text);
    final res = await FdService.updateData(clinicModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Email Id is already exists");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/FDListPage', ModalRoute.withName('/HomePage'));
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
    // setState(() {
    //   _isEnableBtn = true;
    //   _isLoading = false;
    // });
  }

  void getAndSetData() async {
    _nameController.text = widget.dataDetails.firstName;
    _lastNameController.text = widget.dataDetails.lastName;
    _emailController.text = widget.dataDetails.email;
    _passController.text = widget.dataDetails.pass;
    _confirmPassController.text = widget.dataDetails.pass;
    _imageUrl = widget.dataDetails.imageUrl;
    final res = await ClinicService.getAllData();
    if (res.isNotEmpty) {
      setState(() {
        res.forEach((element) {
          ingItems.add({"clinicName": element.title, "clinicId": element.id});
        });
      });
      for (int i = 0; i < res.length; i++) {
        if (res[i].id.toString() == widget.dataDetails.clinicId.toString()) {
          setState(() {
            selectedClinicId = widget.dataDetails.clinicId.toString();
            ingDropdownValue = res[i].title;
          });

          break;
        }
      }
    }
  }
}
