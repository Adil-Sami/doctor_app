import 'package:demoadmin/screens/walkin/walkinDepartment.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkInEditUserProfilePage extends StatefulWidget {
  final userDetails; //QueryDocumentSnapshot

  const WalkInEditUserProfilePage({Key? key, this.userDetails})
      : super(key: key);
  @override
  _WalkInEditUserProfilePageState createState() =>
      _WalkInEditUserProfilePageState();
}

class _WalkInEditUserProfilePageState extends State<WalkInEditUserProfilePage> {
  bool _isLoading = false;
  String _imageUrl = "";
  // List<Asset> _images = <Asset>[];
  String _selectedGender = "";
  bool _isEnableBtn = true;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _mrdNumController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _uIdController = TextEditingController();
  TextEditingController _cratedDateController = TextEditingController();
  TextEditingController _updatedDateController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _emailController.text = widget.userDetails.email;
      _lastNameController.text = widget.userDetails.lastName;
      _firstNameController.text = widget.userDetails.firstName;
      _phoneNumberController.text = widget.userDetails.pNo;
      _imageUrl = widget.userDetails.imageUrl;
      _cityController.text = widget.userDetails.city;
      _uIdController.text = widget.userDetails.uId;
      _ageController.text = widget.userDetails.age;
      _cratedDateController.text = widget.userDetails.createdTimeStamp;
      _updatedDateController.text = widget.userDetails.updateTimeStamp;
      _selectedGender = widget.userDetails.gender;
      _mrdNumController.text =
          widget.userDetails.mrd == null ? "" : widget.userDetails.mrd;
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _uIdController.dispose();
    _cratedDateController.dispose();
    _updatedDateController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavBarWidget(
          isEnableBtn: _isEnableBtn,
          onPressed: () async {
            setState(() {
              _isEnableBtn = false;
              _isLoading = true;
            });
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            final clinicId = preferences.getString("fdClinicId");
            final getClinicData =
                await ClinicService.getDataByClinicId(clinicId ?? "");
            //  print(getClinicData[0].cityId);
            setState(() {
              _isEnableBtn = true;
              _isLoading = false;
            });
            if (getClinicData.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalkinDepartmentPage(
                      userModel: widget.userDetails,
                      clinicId: getClinicData[0].id.toString(),
                      cityId: getClinicData[0].cityId.toString(),
                      cityName: getClinicData[0].cityName,
                      clinicLocationName: getClinicData[0].locationName,
                      clinicName: getClinicData[0].title),
                ),
              );
            } else
              ToastMsg.showToastMsg("Something went wrong");
          }, // _takeConfirmation, // _handleUpdate,
          title: "Book Walk In Appointment",
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
                    //     _circularIcon()
                    //   else
                    //     _profileImage()
                    // else
                    //   _profileImage(),
                    _inputFieldOP("MRD", "Enter MRD", _mrdNumController),
                    _inputField(
                        "First Name", "Enter first name", _firstNameController),
                    _inputField(
                        "Last Name", "Enter last name", _lastNameController),
                    _inputField("City", "Enter city", _cityController),
                    _ageInputField("Age", _ageController),
                    _genderDropDown(),
                    _emailInputField(),
                    _phnNumInputField(),
                    _readOnlyInputField("User Id", _uIdController),
                    _readOnlyInputField("Created at", _cratedDateController),
                    _readOnlyInputField("Last updated", _updatedDateController),
                    //   _roundedCheckedBtn("Check Booked Appointment"),
                    //  _newAppointmentBtn("Book New Appointment"),
                  ],
                ),
              ));
  }





  Widget _readOnlyInputField(String labelText, controller) {
    return InputFields.readableInputField(controller, labelText, 1);
  }

  Widget _ageInputField(String labelText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      if (item.length > 0 && item.length <= 3)
        return null;
      else if (item.length > 3)
        return "Enter valid age";
      else
        return "Enter age";
    }, TextInputType.number, 1);
  }

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
  }

  Widget _inputFieldOP(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return null;
    }, TextInputType.text, 1);
  }

  Widget _emailInputField() {
    return InputFields.commonInputField(_emailController, "Email", (item) {
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
    }, TextInputType.emailAddress, 1);
  }

  Widget _phnNumInputField() {
    return InputFields.readableInputField(
        _phoneNumberController, "Mobile Number", 1);
  }

  Widget _profileImage() {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        //  color: Colors.green,
        child: Stack(
          children: <Widget>[
            // ClipOval(
            //     child: _imageUrl == ""
            //         ? AssetThumb(
            //             asset: _images[0],
            //             height: 150,
            //             width: 150,
            //           )
            //         //:Container()
            //         : ImageBoxFillWidget(imageUrl: _imageUrl)),
            Positioned(
                top: -5,
                right: -10,
                child: IconButton(
                  onPressed: _removeImage,
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );

    //   ClipRRect(
    //     borderRadius: //BorderRadius.circular(8.0),
    //     child:  Image.network( )
    // );
  }

  Widget _circularIcon() {
    return Center(
      child: Container(
        height: 150,
        width: 150,
        child: GestureDetector(
          onTap: _handleImagePicker,
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.camera_enhance_rounded,
                size: 50, color: primaryColor),
          ),
        ),
      ),
    );
  }

  void _handleImagePicker() async {
    // final res = await ImagePicker.loadAssets(_images, mounted, 1);
    // // print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS" + "$res");
    //
    // setState(() {
    //   _images = res;
    // });
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear();
    //   _imageUrl = "";
    // });
  }

  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedGender,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
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
          "Gender",
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
}
