import 'package:demoadmin/model/doctTimeSlotModel.dart';
import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/service/departmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/uploadImageService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/imagePicker.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool passValid = true;
  String _clinicOpeningTime = "10:00";
  String _clinicClosingTime = "20:00";
  String _lunchOpeningTime = "13:00";
  String _lunchClosingTime = "14:00";
  bool _isLoading = false;
  bool _stopBooking = false;
  String _imageUrl = "";
  String doctId="";
  // List<Asset> _images = <Asset>[];
  String _id = "";
  List<String> deptList = ["Select Department"];
  List<String> deptIdList = [""];
  String _selectedDeptId = "";
  bool _isEnableBtn = true;
  bool _stopwalkin = false;
  bool _active=false;
  bool _wActive=false;
  bool _vActive=false;
  List <DoctorTimeSlotModel>doctTimeSlots=[];
  TextEditingController _deptNameController = TextEditingController();
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
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _clinicName = TextEditingController();
  TextEditingController _wspdController = TextEditingController();
  TextEditingController _wspdpController = TextEditingController();
  TextEditingController _vspdController = TextEditingController();
  TextEditingController _textEditingController=TextEditingController();
  bool _payNow=true;
  bool _payLater=true;

  List _dayCode = [];


  @override
  void initState() {
    // TODO: implement initState
    _fetchUserDetails();
    getTimeSlots();//get and set all initial values
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _descController.dispose();
    // _subTitleController.dispose();
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
                    InputFields.readableInputField(
                        _clinicName, "Clinic Name", 1),
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
                    // textField("Opening Time: $_clinicOpeningTime"),
                    // textField("Closing Time: $_clinicClosingTime"),
                    // luchTimetextField("Lunch Opening Time: $_lunchOpeningTime"),
                    // luchTimetextField("Lunch Closing Time: $_lunchClosingTime"),
                 //   _wspdFiled(),
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
                    // deptList.length > 0
                    //     ? _genderDropDown()
                    //     : Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
                    //     child: Text(
                    //       "Please add department",
                    //       style: TextStyle(color: Colors.red),
                    //     ),
                    //   ),
                    // ),
                    InputFields.readableInputField(
                        _deptNameController, "Department", 1),
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
                   // _stopWalkInWidget(),
                    _payNowWidget(),
                    _payLaterWidget(),
                    _activeWidget(),
                  ],
                ),
              ));
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
  void getTimeSlots() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final doctId = prefs.getString("doctId")??"";
    this.doctId=prefs.getString("doctId")??"";
    final getSlots=await DrProfileService.getDoctTimeSlot(doctId);
    if(getSlots.isNotEmpty)
      setState(() {
        doctTimeSlots=getSlots;
      });

    setState(() {
      _isLoading = false;
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
              openDialogBox("TuesDay",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("Wednesday"),
          children: [
            _buildTimeSlotList("3","1"),
            _buildButton((){
              openDialogBox("Wednesday",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("Thursday"),
          children: [
            _buildTimeSlotList("4","1"),
            _buildButton((){
              openDialogBox("Thursday",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("Friday"),
          children: [
            _buildTimeSlotList("5","1"),
            _buildButton((){
              openDialogBox("Friday",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("Saturday"),
          children: [
            _buildTimeSlotList("6","1"),
            _buildButton((){
              openDialogBox("Saturday",context,"1","1");
            })
          ],),
        ExpansionTile(title: Text("Sunday"),
          children: [
            _buildTimeSlotList("7","1"),
            _buildButton((){
              openDialogBox("Sunday",context,"1","1");
            })
          ],)

      ],);
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
              openDialogBox("TuesDay",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("Wednesday"),
          children: [
            _buildTimeSlotList("3","0"),
            _buildButton((){
              openDialogBox("Wednesday",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("Thursday"),
          children: [
            _buildTimeSlotList("4","0"),
            _buildButton((){
              openDialogBox("Thursday",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("Friday"),
          children: [
            _buildTimeSlotList("5","0"),
            _buildButton((){
              openDialogBox("Friday",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("Saturday"),
          children: [
            _buildTimeSlotList("6","0"),
            _buildButton((){
              openDialogBox("Saturday",context,"1","0");
            })
          ],),
        ExpansionTile(title: Text("Sunday"),
          children: [
            _buildTimeSlotList("7","0"),
            _buildButton((){
              openDialogBox("Sunday",context,"1","0");
            })
          ],)

      ],);
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
                            doct_id: doctId,
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
          if (int.parse(item!) >= 0 && int.parse(item) <= 50)
            return null;
          else
            return "only enter 0 to 50 numbers";
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: "Walk-in slot per day kiosk",
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
          if (int.parse(item!) >= 0 && int.parse(item) <= 50)
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

  Widget _inputField(String labelText, String validatorText, controller) {
    return InputFields.commonInputField(controller, labelText, (item) {
      return item.length > 0 ? null : validatorText;
    }, TextInputType.text, 1);
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

  Widget _stopBookingWidget() {
    return ListTile(
      title: Text("online booking"),
      subtitle: _stopBooking
          ? Text("turn off to start all booking")
          : Text("turn on to stop all booking"),
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

  _takeConfirmation() {
    // if (_selectedDept == "Select Department") {
    //   ToastMsg.showToastMsg("please select department");
    // } else {
    if(_payLater==false &&_payNow==false)
      ToastMsg.showToastMsg("Must enable at least one option pay later or pay now");
    else
    DialogBoxes.confirmationBox(context, "Update",
        "Are you sure you want to update profile details", _handleUpdate);
    // }
    //take a confirmation form the user
  }

  _handleUpdate() {
    // if (_formKey.currentState!.validate()) {
    //   //if all input fields are valid
    //   setState(() {
    //     _isEnableBtn = false;
    //     _isLoading = true;
    //   });
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
    // }
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
    //  print("New Days $newDays");
    final drProfileModel = DrProfileModel(
        wspd: _wspdController.text,
        wspdp:_wspdpController.text ,
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
        payNow: _payNow ? "1" : "0",
        payLater: _payLater ? "1" : "0",
        stopWalkIn: _stopwalkin ? "1" : "0",
      active: _active ? "1" : "0",
      vspd: _vspdController.text,
      walkin_active:_wActive ? "1" : "0",
      video_active: _vActive ? "1" : "0",

    );

    final res = await DrProfileService.updateData(drProfileModel);
    if (res == "already exists") {
      ToastMsg.showToastMsg("Email id is already registered");
    } else if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.pop(context);
      // Navigator.pop(context);
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

  // Widget _inputField(String labelText, String validatorText, controller) {
  //   return InputFields.commonInputField(controller, labelText, (item) {
  //     return item.length > 0 ? null : validatorText;
  //   }, TextInputType.text, 1);
  // }

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
    // //print("RRRRRRRRRRRREEEEEEEEEEEESSSSSSSS"+"$res");
    //
    // setState(() {
    //   _images = res;
    // });
  }

  void _removeImage() {
    // setState(() {
    //   _images.clear(); //clear array of the image
    //   _imageUrl = "";
    // });
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final doctId = prefs.getString("doctId");
    final res = await DrProfileService.getDataByDId(
        doctId!); //fetch all details of the doctors
    // print(res["profileImageUrl"]);
    //set all the values in to text fields
    final res2 =
        await DepartmentService.getData(res[0].clinicId, res[0].cityId);
    if (res2 != "null") {
      for (var e in res2) {
        setState(() {
          deptList.add(e.name);
          deptIdList.add(e.id);
          if (e.id == res[0].deptId) {
            _selectedDeptId = e.id;
            _deptNameController.text = e.name;
          }
        });
      }
    }
    print(generateMd5(res[0].pass));
    _wspdController.text = res[0].wspd;
    _wspdpController.text=res[0].wspdp;
    _vspdController.text = res[0].vspd;
    _emailController.text = res[0].email;
    _passController.text = res[0].pass;
    _confirmPassController.text = res[0].pass;
    _serviceTime.text = res[0].serviceTime;
    _lastNameController.text = res[0].lastName;
    _firstNameController.text = res[0].firstName;
    _clinicName.text = res[0].clinicName;
    _imageUrl = res[0].profileImageUrl;
    _descController.text = res[0].description;
    _subTitleController.text = res[0].subTitle;
    _whatsAppNoController.text = res[0].whatsAppNo;
    _primaryPhnController.text = res[0].pNo1;
    _secondaryPhnController.text = res[0].pNo2;
    _aboutUsController.text = res[0].aboutUs;
    _addressController.text = res[0].address;
    _id = res[0].id;
    _hNameController.text = res[0].hName;
    _launchCTCont.text = res[0].lunchClosingTime;
    _launchOTCont.text = res[0].lunchOpeningTime;
    _lunchClosingTime = res[0].lunchClosingTime;
    _lunchOpeningTime = res[0].lunchOpeningTime;
    _clinicClosingTime = res[0].clt;
    _clinicOpeningTime = res[0].opt;
    _appFeeCont.text = res[0].fee;
    if (res[0].payNow == "0")
      _payNow = false;
    else
      _payNow = true;
    if (res[0].payLater == "0")
    _payLater = false;
    else
      _payLater = true;
    if (res[0].stopBooking == "true")
      _stopBooking = true;
    else
      _stopBooking = false;
    if (res[0].stopWalkIn == "0")
      _stopwalkin = false;
    else
      _stopwalkin = true;
    if (res[0].active == "0")
      _active = false;
    else
      _active = true;
    if (res[0].walkin_active == "0")
      _wActive = false;
    else
      _wActive = true;
    if (res[0].video_active == "0")
      _vActive = false;
    else
      _vActive = true;
    if (res[0].dayCode != null && res[0].dayCode != "") {
      final day = res[0].dayCode.toString().split(",");
      for (var e in day) {
        _dayCode.add(int.parse(e));
      }
    }

    setState(() {
      _isLoading = false;
    });
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
}
