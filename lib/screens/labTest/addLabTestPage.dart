import 'dart:convert';
import 'package:demoadmin/model/labTestModel.dart';
import 'package:demoadmin/service/labTestService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
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

class AddLabTestPage extends StatefulWidget {
  final clinicID;
  final clinicName;
  AddLabTestPage({this.clinicID, this.clinicName});
  @override
  _AddLabTestPageState createState() => _AddLabTestPageState();
}

class _AddLabTestPageState extends State<AddLabTestPage> {
  bool passValid = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String checkValue = "1";
  // List<Asset> _images = <Asset>[];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _subTitleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  bool _isEnableBtn = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _subTitleController.dispose();
    super.dispose();
  }

  Widget _priceInputField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InputFields.ageInputFormField(
          context, "Price", TextInputType.number, _priceController, false,
          (item) {
        return item.length > 0 ? null : "Enter price";
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Add Lab Test"),
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
                    _priceInputField(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _serviceNameInputField() {
    return InputFields.commonInputField(_nameController, "Test Name*", (item) {
      return item.length > 0 ? null : "Enter name";
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
      if (_priceController.text == "0")
        ToastMsg.showToastMsg("Please enter a valid price");
      DialogBoxes.confirmationBox(
          context,
          "Add New",
          "Are you sure want to add new lab test",
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
    // setState(() {
    //   _isEnableBtn = false;
    //   _isLoading = true;
    // });
    // _images.length > 0
    //     ? _uploadImg()
    //     : _uploadData(""); //check user selected image or not
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear(); //clean array
    // });
  }

  _uploadData(imageDownloadUrl) async {
    LabTestModel labTestModelModel = LabTestModel(
        title: _nameController.text,
        imageUrl: imageDownloadUrl,
        subTitle: _subTitleController.text,
        clinicId: widget.clinicID,
        price: _priceController.text);
    final res2 = await LabTestService.addData(labTestModelModel);
    if (res2 == "error") {
      ToastMsg.showToastMsg('Something went wrong');
      //   ToastMsg.showToastMsg("Email id already exists");
    } else {
      var jsonData = await json.decode(res2);
      if (jsonData['status'] == "true") {
        if (jsonData['msg'] == "already exists") {
          ToastMsg.showToastMsg("Name is already registered");
        } else if (jsonData['msg'] == "added") {
          // await AddData.addLabAttenderDetails(jsonData['id'].toString());
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
