import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/model/userModel.dart';
import 'package:demoadmin/screens/appointmentScreen/chooseTimeSlotsPage.dart';
import 'package:demoadmin/screens/appointmentScreen/resWalkinChooseRimeSlotsPage.dart';
import 'package:demoadmin/screens/prescription/prescriptionListPage.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/screens/videocall.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/notify_provider.dart';
import 'chat/chatScreen.dart';

class EditAppointmentDetailsPage extends StatefulWidget {
  final appointmentDetails;
  const EditAppointmentDetailsPage({Key? key, this.appointmentDetails})
      : super(key: key);
  @override
  _EditAppointmentDetailsPageState createState() =>
      _EditAppointmentDetailsPageState();
}

class _EditAppointmentDetailsPageState
    extends State<EditAppointmentDetailsPage> {

  late final provider;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isEnableBtn = true;
  bool _isLoading = false;
  int _groupValue = -1;
  UserModel? userModel;
  String _selectedGender = "";
  String userType = "";
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _latsNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _phnController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _serviceName2Controller = TextEditingController();
  TextEditingController _tokenNumberController = TextEditingController();
  TextEditingController _mrdController = TextEditingController();

  TextEditingController _doctNameController = TextEditingController();

  TextEditingController _serviceTimeController = TextEditingController();
  TextEditingController _appointmentIdController = TextEditingController();
  TextEditingController _uIdController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _createdDateTimeController = TextEditingController();
  TextEditingController _lastUpdatedController = TextEditingController();
  TextEditingController _orderIdController = TextEditingController();
  TextEditingController _paymentStatusController = TextEditingController();
  TextEditingController _paymentDateController = TextEditingController();
  TextEditingController _amountCont = TextEditingController();
  TextEditingController _paymentModeCont = TextEditingController();
  TextEditingController _appointmentStatusCont = TextEditingController();
  TextEditingController _gmeetLinkCont = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    //print(widget.appointmentDetails);
//initialize all input field
    getAndSetUserData();

    _firstNameController.text = widget.appointmentDetails.pFirstName;
    _latsNameController.text = widget.appointmentDetails.pLastName;
    _ageController.text = widget.appointmentDetails.age;
    _cityController.text = widget.appointmentDetails.pCity;
    _emailController.text = widget.appointmentDetails.pEmail;
    _phnController.text = widget.appointmentDetails.pPhn;
    _dateController.text = widget.appointmentDetails.appointmentDate;
    _timeController.text = widget.appointmentDetails.appointmentTime;
    _serviceNameController.text = widget.appointmentDetails.serviceName;
    _serviceName2Controller.text =
        widget.appointmentDetails.serviceName == "Online"
            ? "Video Consultation"
            : "Hospital Visit";
    _doctNameController.text = widget.appointmentDetails.doctName;
    _serviceTimeController.text =
        widget.appointmentDetails.serviceTimeMin.toString();
    _appointmentIdController.text = widget.appointmentDetails.id;
    _uIdController.text = widget.appointmentDetails.uId;
    _descController.text = widget.appointmentDetails.description;
    _createdDateTimeController.text =
        widget.appointmentDetails.createdTimeStamp;
    _lastUpdatedController.text = widget.appointmentDetails.updatedTimeStamp;
    _selectedGender = widget.appointmentDetails.gender;
    _paymentStatusController.text = widget.appointmentDetails.paymentStatus;
    _paymentDateController.text = widget.appointmentDetails.paymentDate;
    _orderIdController.text = widget.appointmentDetails.oderId;
    _amountCont.text = widget.appointmentDetails.amount;
    _paymentModeCont.text = widget.appointmentDetails.paymentMode;

    if (widget.appointmentDetails.gMeetLink != null &&
        widget.appointmentDetails.gMeetLink != "")
      _gmeetLinkCont.text = widget.appointmentDetails.gMeetLink;
    else
      _gmeetLinkCont.text = "https://";
    if (widget.appointmentDetails.isOnline == "true" &&
        widget.appointmentDetails.isOnline != null &&
        widget.appointmentDetails.isOnline != "")
      _appointmentStatusCont.text = "Online";
    else
      _appointmentStatusCont.text = "Offline";

    if (widget.appointmentDetails.appointmentStatus == "Rejected" ||
        widget.appointmentDetails.appointmentStatus == "Canceled")
      setState(() {
        _isEnableBtn = false;
      });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _timeController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _firstNameController.dispose();
    _latsNameController.dispose();
    _phnController.dispose();
    _emailController.dispose();
    _serviceNameController.dispose();
    _serviceTimeController.dispose();
    _appointmentIdController.dispose();
    _uIdController.dispose();
    _descController.dispose();
    _createdDateTimeController.dispose();
    _lastUpdatedController.dispose();
    _orderIdController.dispose();
    _paymentDateController.dispose();
    _paymentStatusController.dispose();
    _amountCont.dispose();
    _paymentModeCont.dispose();
    super.dispose();
  }

  _handlePrescriptionBtn() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PrescriptionListByIDPage(
                drName: widget.appointmentDetails.doctName,
                appointmentId: widget.appointmentDetails.id,
                userId: widget.appointmentDetails.uId,
                patientName: widget.appointmentDetails.pFirstName +
                    " " +
                    widget.appointmentDetails.pLastName,
                time: widget.appointmentDetails.appointmentTime,
                date: widget.appointmentDetails.appointmentDate,
                serviceName: widget.appointmentDetails.serviceName,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Edit Details"),
        bottomNavigationBar: BottomNavBarWidget(
          title: widget.appointmentDetails.appointmentStatus == "Visited"
              ? "Prescription"
              : "Update",
          onPressed: widget.appointmentDetails.appointmentStatus == "Visited"
              ? _handlePrescriptionBtn
              : _takeConfirmation,
          isEnableBtn: widget.appointmentDetails.appointmentStatus == "Visited"
              ? true
              : _isEnableBtn,
        ),
        floatingActionButton:
            widget.appointmentDetails.appointmentStatus == "Rejected" ||
                    widget.appointmentDetails.appointmentStatus == "Visited" ||
                    widget.appointmentDetails.appointmentStatus == "Canceled"
                ? null
                : new FloatingActionButton(
                    elevation: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.format_list_bulleted_sharp),
                      onPressed: showDialogBox,
                    ),
                    backgroundColor: btnColor,
                    onPressed: () {}),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : Form(
                key: _formKey,
                child: ListView(children: [
                  /*
                  commented by hassan005004
                  _appointmentStatusCont.text == "Online"
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                          child: GestureDetector(
                            onTap: () {
                              print(widget.appointmentDetails.uId);
                              print(widget.appointmentDetails.doctId);
                              print(widget.appointmentDetails.pEmail);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Meeting(
                                          uid: widget.appointmentDetails.uId,
                                          doctid:
                                              widget.appointmentDetails.doctId,
                                          email:
                                              widget.appointmentDetails.pEmail,
                                        )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Call To Patient",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "OpenSans-SemiBold",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),*/

                  // added by hassan005004
                  GestureDetector(
                    onTap: () {
                      // print(widget.appointmentDetails!.uId);
                      // print(widget.appointmentDetails!.id);
                      // print(widget.appointmentDetails!.doctId);
                      // print(widget.appointmentDetails!.pEmail);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  // widget.appointmentDetails
                                null,
                                widget.appointmentDetails.doctId,
                                widget.appointmentDetails.doctName,
                                widget.appointmentDetails.userId,
                                widget.appointmentDetails.uId,
                              )
                          )
                      ).then((value) async => {
                        provider = await Provider.of<NotifyProvider>(context, listen: false),
                        provider.messageEmpty(),
                        // print('asd'),
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Center(
                          child: Text(
                            "Contact to Patient".tr,
                            style: TextStyle(
                                fontFamily: "OpenSans-SemiBold",
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  InputFields.commonInputField(_mrdController, "MRD No.",
                      (item) {
                    return null;
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(
                      _firstNameController, "First Name", (item) {
                    return item.length > 0 ? null : "Enter first name";
                  }, TextInputType.text, 1),
                  InputFields.commonInputField(_latsNameController, "Last Name",
                      (item) {
                    return item.length > 0 ? null : "Enter last name";
                  }, TextInputType.text, 1),
                  InputFields.readableInputField(
                      _dateController, "Appointment Date", 1),
                  InputFields.readableInputField(
                      _timeController, "Appointment Time", 1),
                  InputFields.readableInputField(
                      _tokenNumberController, "Token", 1),
                  InputFields.readableInputField(
                      _doctNameController, "Doctor Name", 1),
                  InputFields.readableInputField(
                      _serviceName2Controller, "Service Name", 1),
                  // InputFields.readableInputField(
                  //     _serviceTimeController, "Service Time", 1),
                  InputFields.commonInputField(_phnController, "Mobile Number",
                      (item) {
                    return item.length > 8
                        ? null
                        : "Enter a valid digit mobile number";
                  }, TextInputType.phone, 1),
                  InputFields.readableInputField(
                      _appointmentStatusCont, "Appointment", 1),
                  // _appointmentStatusCont.text == "Online"
                  //     ? Padding(
                  //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  //         child: TextFormField(
                  //           onTap: () async {
                  //             showDialogBoxForGoogleMeet();
                  //           },
                  //           maxLines: null,
                  //           readOnly: true,
                  //           controller: _gmeetLinkCont,
                  //           keyboardType: TextInputType.text,
                  //           decoration: InputDecoration(
                  //               labelText: "Google Meet Link",
                  //               enabledBorder: UnderlineInputBorder(
                  //                 borderSide:
                  //                     BorderSide(color: Colors.grey[350]!),
                  //               ),
                  //               focusedBorder: UnderlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: appBarColor, width: 1.0),
                  //               )),
                  //         ),
                  //       )
                  //     : Container(),
                  InputFields.commonInputField(_ageController, "Age", (item) {
                    if (item.length > 0 && item.length <= 3)
                      return null;
                    else if (item.length > 3)
                      return "Enter valid age";
                    else
                      return "Enter age";
                  }, TextInputType.number, 1),
                  _genderDropDown(),
                  InputFields.commonInputField(_emailController, "Email",
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
                  }, TextInputType.emailAddress, 1),
                  InputFields.commonInputField(_cityController, "City", (item) {
                    return item.length > 0 ? null : "Enter a city name";
                  }, TextInputType.text, 1),
                  InputFields.readableInputField(
                      _appointmentIdController, "Appointment id", 1),
                  InputFields.readableInputField(_uIdController, "User Id", 1),
                  widget.appointmentDetails.oderId == ""
                      ? Container()
                      : InputFields.readableInputField(
                          _amountCont, "Amount", 1),
                  widget.appointmentDetails.oderId == ""
                      ? Container()
                      : InputFields.readableInputField(
                          _paymentModeCont, "Payment Mode", 1),
                  widget.appointmentDetails.oderId == ""
                      ? Container()
                      : InputFields.readableInputField(
                          _orderIdController, "Order Id", 1),
                  InputFields.readableInputField(
                      _paymentStatusController, "Payment Status", 1),
                  widget.appointmentDetails.oderId == ""
                      ? Container()
                      : InputFields.readableInputField(
                          _paymentDateController, "Payment Date", 1),
                  InputFields.readableInputField(
                      _createdDateTimeController, "Created on", 1),
                  InputFields.readableInputField(
                      _lastUpdatedController, "Last Update On", 1),
                  InputFields.commonInputField(
                      _descController, "Description, About problem", (item) {
                    if (item.isEmpty)
                      return null;
                    else {
                      return item.length > 0 ? null : "Enter Description";
                    }
                  }, TextInputType.text, 5),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        Text("Appointment Status:     "),
                        if (widget.appointmentDetails.appointmentStatus ==
                            "Confirmed")
                          _statusIndicator(Colors.green)
                        else if (widget.appointmentDetails.appointmentStatus ==
                            "Pending")
                          _statusIndicator(Colors.yellowAccent)
                        else if (widget.appointmentDetails.appointmentStatus ==
                            "Rejected")
                          _statusIndicator(Colors.red)
                        else if (widget.appointmentDetails.appointmentStatus ==
                            "Rescheduled")
                          _statusIndicator(Colors.orangeAccent)
                        else
                          Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                              "${widget.appointmentDetails.appointmentStatus}",
                              style: TextStyle(
                                fontFamily: 'OpenSans-SemiBold',
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Flexible(
                      child: Row(children: [
                        Text("Appointment Status:     "),
                        widget.appointmentDetails.vByUser == "0"
                            ? _statusIndicator(Colors.red)
                            : widget.appointmentDetails.vByUser == "1"
                                ? _statusIndicator(Colors.green)
                                : Container(),
                        SizedBox(width: 5),
                        widget.appointmentDetails.vByUser == "0"
                            ? Flexible(
                                child: Text("Mark Not Visited \n BY Users"))
                            : widget.appointmentDetails.vByUser == "1"
                                ? Flexible(
                                    child: Text("Mark Visited \n BY User"))
                                : Container()
                      ]),
                    ),
                  ),

                  widget.appointmentDetails.appointmentStatus == "Rejected" ||
                          widget.appointmentDetails.appointmentStatus ==
                              "Visited" ||
                          widget.appointmentDetails.appointmentStatus ==
                              "Canceled"
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child:
                              Text("Sorry! You can not edit this appointment"),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Divider(),
                  ),
                  // widget.appointmentDetails.appointmentStatus ==
                  //             "Rejected" ||
                  //     widget.appointmentDetails.appointmentStatus ==
                  //             "Done"
                  //     ? Container()
                  //     : _roundedDoneBtn("Done", "Done"),
                  // widget.appointmentDetails.appointmentStatus ==
                  //             "Rejected" ||
                  //     widget.appointmentDetails.appointmentStatus ==
                  //             "Done"
                  //     ? //if rejected then not show anything, now user have to make a new appointment
                  //     Container()
                  //     : Row(
                  //         //if not rejected
                  //         children: [
                  //           Expanded(
                  //               flex: 1,
                  //               child: _roundedBtn("Confirmed", "Confirmed")),
                  //           Expanded(
                  //               flex: 1,
                  //               child: _roundedBtn("Pending", "Pending")),
                  //         ],
                  //       ),
                  // widget.appointmentDetails.appointmentStatus  ==
                  //             "Rejected" ||
                  //     widget.appointmentDetails.appointmentStatus ==
                  //             "Done"
                  //     ? //if rejected then not show anything, now user have to make a new appointment
                  //     Container()
                  //     : Row(
                  //         //if not rejected
                  //         children: [
                  //           Expanded(
                  //               flex: 1,
                  //               child: _roundedReschtBtn(
                  //                   "Reschedule", "Rescheduled")),
                  //           Expanded(
                  //               flex: 1,
                  //               child:
                  //                   _roundedRejectBtn("Reject", "Rejected"))
                  //         ],
                  //       ),
                ]),
              ));
  }

  _takeConfirmation() {
    DialogBoxes.confirmationBox(
        context, "Update", "Are you sure want to update", _handleUpdate);
  }

  String getTime(appointmentTime) {
    final splitTime = appointmentTime.toString().split(":");
    String newTime = "";
    String newFirstTime = splitTime[0];
    String newLastTime = splitTime[1];
    if (int.parse(splitTime[0]) < 10 && splitTime[0].length == 1)
      newFirstTime = "0${splitTime[0]}";
    if (int.parse(splitTime[1]) < 10 && splitTime[1].length == 1)
      newLastTime = "0${splitTime[1]}";
    newTime = "$newFirstTime:$newLastTime";

    return newTime;
  }

  void _handleGMeetUpdate() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    final res = await AppointmentService.updateGmeet(
        _gmeetLinkCont.text, widget.appointmentDetails.id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else if (res == "error") {
      ToastMsg.showToastMsg("Something wents wrong");
    }
    _sendNotification("Google Meet Link");
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  showDialogBoxForGoogleMeet() {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose"),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputFields.commonInputField(
                          _gmeetLinkCont, "Google Meet Link", (iteam) {
                        return iteam.length > 0 ? null : "Enter link";
                      }, TextInputType.text, null)
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (Uri.parse(_gmeetLinkCont.text).isAbsolute) {
                        Navigator.of(context).pop();
                        _handleGMeetUpdate();
                      } else
                        ToastMsg.showToastMsg("Please enter valid url");
                    }
                  }),
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Open",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (_gmeetLinkCont.text != "") {
                      try {
                        await launchUrl(Uri.parse(_gmeetLinkCont.text));
                      } catch (e) {
                        // print(e);
                      }
                    }
                  }),
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      // print("hihihih");
      setState(() {
        _isEnableBtn = false;
        _isLoading = true;
      });

      final pattern = RegExp('\\s+'); //remove all space
      final fullName = _firstNameController.text + _latsNameController.text;
      String searchByName = fullName.toLowerCase().replaceAll(pattern, "");

      final appointmentModel = AppointmentModel(
          id: widget.appointmentDetails.id,
          pPhn: _phnController.text,
          pCity: _cityController.text,
          age: _ageController.text,
          pFirstName: _firstNameController.text,
          pLastName: _latsNameController.text,
          description: _descController.text,
          pEmail: _emailController.text,
          gender: _selectedGender,
          searchByName: searchByName);
      final res = await AppointmentService.updateData(appointmentModel);
      if (res == "success") {
        if (_mrdController.text != "")
          await UserService.updateDataMRD(
              mrd: _mrdController.text, uid: userModel!.id.toString());
        ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else if (res == "error") {
        ToastMsg.showToastMsg("Something wents wrong");
      }
      setState(() {
        _isEnableBtn = true;
        _isLoading = false;
      });
    }

    // _images.length > 0 ? _uploadImg() : _uploadNameAndDesc("");
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
            // print(value);
            _selectedGender = value!;
          });
        },
      ),
    );
  }

  _handleRescheduleBtn() {
    if (widget.appointmentDetails.walkin == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReWalkInChooseTimeSlotsPage(
            serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
            appointmentId: widget.appointmentDetails.id,
            appointmentDate: widget.appointmentDetails.appointmentDate,
            uId: widget.appointmentDetails.uId,
            uName: "${widget.appointmentDetails.uName}",
            serviceName: widget.appointmentDetails.serviceName,
            doctId: widget.appointmentDetails.doctId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseTimeSlotsPage(
            serviceTimeMin: widget.appointmentDetails.serviceTimeMin,
            appointmentId: widget.appointmentDetails.id,
            appointmentDate: widget.appointmentDetails.appointmentDate,
            uId: widget.appointmentDetails.uId,
            uName: "${widget.appointmentDetails.uName}",
            serviceName: widget.appointmentDetails.serviceName,
            doctId: widget.appointmentDetails.doctId,
          ),
        ),
      );
    }
  }

  _handleRejectAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // final res = await DeleteData.deleteBookedAppointment(
    //     widget.appointmentDetails.id,
    //     widget.appointmentDetails.appointmentDate,
    //     widget.appointmentDetails.doctId);
    // if (res == "success") {
    final appointmentModel = AppointmentModel(
        id: widget.appointmentDetails.id, appointmentStatus: "Rejected");
    final isUpdated = await AppointmentService.updateStatus(appointmentModel);
    if (isUpdated == "success") {
      await _sendNotification("Rejected");
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  _handleDoneAppointment() async {
    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });

    // final res = await DeleteData.deleteBookedAppointment(
    //     widget.appointmentDetails.id,
    //     widget.appointmentDetails.appointmentDate,
    //     widget.appointmentDetails.doctId);
    // if (res == "success") {
    final appointmentModel = AppointmentModel(
        id: widget.appointmentDetails.id, appointmentStatus: "Visited");
    final isUpdated = await AppointmentService.updateStatus(appointmentModel);
    if (isUpdated == "success") {
      await AppointmentService.updateToken(widget.appointmentDetails.id);
      _sendNotification("Visited");
      ToastMsg.showToastMsg("Successfully Updated");
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  // _roundedDoneBtn(String title, String status) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: GestureDetector(
  //       onTap: () {
  //         DialogBoxes.confirmationBox(
  //             context,
  //             "Done",
  //             "Are you sure want to done this appointment",
  //             _handleDoneAppointment);
  //
  //         //   _handleAppointmentStatus( widget.appointmentDetails["uId"],widget.appointmentDetails["appointmentId"], status);
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(25.0),
  //             gradient: LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               colors: [
  //                 Color(0xFF0099ff),
  //                 Color(0xFF004272),
  //               ],
  //             )),
  //         child: Center(
  //             child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Text(title, style: TextStyle(color: Colors.white)),
  //         )),
  //       ),
  //     ),
  //   );
  // }

  _handleAppointmentStatus(String appointmentId, String status) async {
    //print(uId + appointmentId +

    setState(() {
      _isEnableBtn = false;
      _isLoading = true;
    });
    final appointmentModel =
        AppointmentModel(id: appointmentId, appointmentStatus: status);

    final res = await AppointmentService.updateStatus(appointmentModel);
    if (res == "success") {
      await _sendNotification(status);

      ToastMsg.showToastMsg("Successfully Updated");
      if (status == "Confirmed") {
        final getToekn = await AppointmentService.getToken(
            widget.appointmentDetails.doctId, widget.appointmentDetails.dateC);
        // print(getToekn);
        if (getToekn.length == 0) {
          final addedToken = await AppointmentService.addToken(
              doctId: widget.appointmentDetails.doctId.toString(),
              appId: widget.appointmentDetails.id.toString(),
              tokenNum: "1",
              date: widget.appointmentDetails.dateC,
              tokenType: widget.appointmentDetails.walkin.toString());
          if (addedToken == "success")
            await _sendNotification("Appointment Checkedin", "1");
        } else if (getToekn.length > 0) {
          int tokenNum = int.parse(getToekn[getToekn.length - 1].tokenNum) + 1;
          //print("tnum $getToekn[getToekn.length-1].tokenNum $tokenNum");
          final addedToken = await AppointmentService.addToken(
              doctId: widget.appointmentDetails.doctId,
              appId: widget.appointmentDetails.id.toString(),
              tokenNum: tokenNum.toString(),
              date: widget.appointmentDetails.dateC,
              tokenType: widget.appointmentDetails.walkin.toString());
          if (addedToken == "success")
            await _sendNotification(
                "Appointment Checkedin", tokenNum.toString());
        }
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
          '/AppointmentListPage', ModalRoute.withName('/HomePage'));
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isEnableBtn = true;
      _isLoading = false;
    });
  }

  Widget _statusIndicator(color) {
    return CircleAvatar(radius: 7, backgroundColor: color);
  }

  _sendNotification(String title, [tokenNum]) async {
    String body = "";
    switch (title) {
      case "Visited":
        {
          body = "Thank you for visiting. Please visit again";
          break;
        }
      case "Confirmed":
        {
          body =
              "Your appointment has been confirmed for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Pending":
        {
          body =
              "Your appointment has been pending for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Rejected":
        {
          body =
              "Sorry! your appointment has been rejected for date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Google Meet Link":
        {
          body =
              "Please check, google meet link has been updated for date ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      case "Appointment Checkedin":
        {
          body =
              "Your Token Number is ${widget.appointmentDetails.walkin == "0" ? "A" : "W"}-$tokenNum for appointment date: ${widget.appointmentDetails.appointmentDate} time: ${widget.appointmentDetails.appointmentTime}";
          break;
        }
      default:
        {
          body = "";
        }
    }
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.appointmentDetails.uId,
        routeTo: "/Appointmentstatus",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.appointmentDetails.uName);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.appointmentDetails.uId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.appointmentDetails.uId, true);
    }
  }

  showDialogBox() {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text("Choose a status"),
            content: Container(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _myRadioButton(
                        title: "Confirmed",
                        value: 0,
                        onChanged: (newValue) => setState(() {
                              _groupValue = newValue;
                            })),
                    _myRadioButton(
                      title: "Visited",
                      value: 1,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Pending",
                      value: 2,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reject",
                      value: 3,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    ),
                    _myRadioButton(
                      title: "Reschedule",
                      value: 4,
                      onChanged: (newValue) =>
                          setState(() => _groupValue = newValue),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    switch (_groupValue) {
                      case 0:
                        {
                          Navigator.of(context).pop();
                          _handleAppointmentStatus(
                              widget.appointmentDetails.id, "Confirmed");
                        }

                        break;
                      case 1:
                        {
                          Navigator.of(context).pop();
                          _handleDoneAppointment();
                        }

                        break;
                      case 2:
                        {
                          Navigator.of(context).pop();
                          _handleAppointmentStatus(
                              widget.appointmentDetails.id, "Pending");
                        }

                        break;
                      case 3:
                        {
                          Navigator.of(context).pop();
                          _handleRejectAppointment();
                        }
                        break;

                      case 4:
                        {
                          Navigator.of(context).pop();
                          _handleRescheduleBtn();
                        }
                        break;
                      default:
                        // print("Not Select");
                        break;
                    }
                  }),
              new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              // usually buttons at the bottom of the dialog
            ],
          );
        });
      },
    );
  }

  Widget _myRadioButton({String? title, int? value, onChanged}) {
    return RadioListTile(
      activeColor: btnColor,
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged, //onChanged,
      title: Text(title ?? ""),
    );
  }

  void getAndSetUserData() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final type = preferences.getString("userType");
    setState(() {
      userType = type ?? "";
    });
    // print("user Type $userType");

    final res = await UserService.getUserById(widget.appointmentDetails.uId);
    if (res.length > 0) {
      userModel = res[0];
      _mrdController.text = res[0].mrd == null ? "" : res[0].mrd;
    }
    final tokenNumRes = await AppointmentService.getTokenByAppId(
        widget.appointmentDetails.id.toString());
    if (tokenNumRes.length > 0) {
      final tokentYpe = tokenNumRes[0].tokenType == "0" ? "A-" : "W-";
      _tokenNumberController.text =
          tokentYpe.toString() + tokenNumRes[0].tokenNum.toString();
    } else
      _tokenNumberController.text = "Token Not Issued";
    setState(() {
      _isLoading = false;
    });
  }
}
