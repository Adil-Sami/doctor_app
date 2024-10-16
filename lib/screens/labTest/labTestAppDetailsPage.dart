import 'package:demoadmin/model/labTestAppModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/Notification/handleLocalNotification.dart';
import 'package:demoadmin/service/labTestApppService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabTestAppDetailsPage extends StatefulWidget {
  final LabTestAppModel? appointmentDetails;
  final foAdmin;

  const LabTestAppDetailsPage({Key? key, this.appointmentDetails, this.foAdmin})
      : super(key: key);
  @override
  _LabTestAppDetailsPageState createState() => _LabTestAppDetailsPageState();
}

class _LabTestAppDetailsPageState extends State<LabTestAppDetailsPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phnController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _createdDateTimeController = TextEditingController();
  TextEditingController _paymentStatusController = TextEditingController();
  TextEditingController _amountCont = TextEditingController();
  TextEditingController _appointmentStatusCont = TextEditingController();
  TextEditingController _cityName = TextEditingController();
  TextEditingController _clinicName = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController.text = widget.appointmentDetails!.pName;
    _ageController.text = widget.appointmentDetails!.pAge;
    _cityController.text = widget.appointmentDetails!.pCity;
    _emailController.text = widget.appointmentDetails!.pEmail;
    _phnController.text = widget.appointmentDetails!.pPhn;
    _serviceNameController.text = widget.appointmentDetails!.serviceName;
    _descController.text = widget.appointmentDetails!.pDesc;
    _createdDateTimeController.text =
        widget.appointmentDetails!.createdTimeStamp;
    if (widget.appointmentDetails!.status == "0")
      _statusController.text = "Pending";
    else if (widget.appointmentDetails!.status == "1")
      _statusController.text = "Confirmed";
    else if (widget.appointmentDetails!.status == "2")
      _statusController.text = "Visited";
    else if (widget.appointmentDetails!.status == "3")
      _statusController.text = "Canceled";
    _cityName.text = widget.appointmentDetails!.pCity;
    _clinicName.text = widget.appointmentDetails!.clinicName;
    _paymentStatusController.text = widget.appointmentDetails!.pymentStatus;
    _amountCont.text = widget.appointmentDetails!.paymentAmount + '\u{20B9}';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _firstNameController.dispose();
    _phnController.dispose();
    _emailController.dispose();
    _serviceNameController.dispose();
    _descController.dispose();
    _paymentStatusController.dispose();
    _amountCont.dispose();
    _appointmentStatusCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Request List"),
      bottomNavigationBar: widget.appointmentDetails!.status == "2" ||
              widget.appointmentDetails!.status == "3"
          ? null
          : _isLoading
              ? null
              : BottomNavTwoBarWidget(
                  firstBtnOnPressed: () {
                    widget.appointmentDetails!.status == "1"
                        ? _handleVisitedBtn()
                        : _handleConfirmBtn();
                  },
                  firstTitle: widget.appointmentDetails!.status == "1"
                      ? "Visited"
                      : "Confirmed",
                  isenableBtn: true,
                  secondBtnOnPressed: () {
                    _handleCancelBtn();
                  },
                  secondTitle: "Canceled",
                ),
      //
      // widget.appointmentDetails!.status=="0"? BottomNavigationStateWidget(
      //     title: "Cancel",
      //     onPressed: _takeConfirmation,
      //     clickable: !_isLoading?"true":""):null,
      body: _isLoading
          ? LoadingIndicatorWidget()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 0, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 20),
                    _inputTextField("Name", _firstNameController, 1),
                    _inputTextField("Amount", _amountCont, 1),
                    _inputTextField(
                        "Payment Status", _paymentStatusController, 1),
                    _inputTextField("Age", _ageController, 1),
                    _inputTextField("Appointment Status", _statusController, 1),
                    _inputTextField("Phone Number", _phnController, 1),
                    _inputTextField("City ", _cityController, 1),
                    //  _inputTextField("Email", _emailController, 1),
                    _inputTextField("Clinic Name", _clinicName, 1),
                    // _inputTextField("Clinic City", _cityName, 1),
                    _inputTextField(
                        "Created on", _createdDateTimeController, 1),
                    _inputTextField("Description, About your problem",
                        _descController, null),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _inputTextField(String labelText, controller, maxLine) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextFormField(
        maxLines: maxLine,
        readOnly: true,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            // prefixIcon:Icon(Icons.,),
            labelText: labelText,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  void _handleCancelBtn() async {
    setState(() {
      _isLoading = true;
    });
    final res = await LabTestAppService.updateStatusData(
      widget.appointmentDetails!.id.toString(),
      "3",
    );
    if (res == "success") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final uid = preferences.getString("uid");
      final notificationModel = NotificationModel(
          title: "Canceled",
          body: "Test Appointment has been canceled",
          uId: uid,
          routeTo: "/LabTestAppListPage",
          sendBy: "user",
          sendFrom: "${widget.appointmentDetails!.pName}",
          sendTo: "Admin");
      await NotificationService.addData(notificationModel);
      _handleSendNotification(uid);
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleConfirmBtn() async {
    setState(() {
      _isLoading = true;
    });
    final res = await LabTestAppService.updateStatusData(
      widget.appointmentDetails!.id.toString(),
      "1",
    );
    if (res == "success") {
      final res =
          await UserService.getUserByuid(widget.appointmentDetails!.uid);
      final notificationModel = NotificationModel(
          title: "Confirmed",
          body: "Test Appointment has been confirmed",
          uId: res[0].uId,
          routeTo: "/LabTestAppListPage",
          sendBy: "user",
          sendFrom: "${widget.appointmentDetails!.pName}",
          sendTo: "Admin");
      await NotificationService.addData(notificationModel);
      _handleSendNotificationConfirm(res[0].uId);
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleVisitedBtn() async {
    setState(() {
      _isLoading = true;
    });
    final res = await LabTestAppService.updateStatusData(
      widget.appointmentDetails!.id.toString(),
      "2",
    );
    if (res == "success") {
      final res =
          await UserService.getUserByuid(widget.appointmentDetails!.uid);
      final notificationModel = NotificationModel(
          title: "Visited",
          body: "Tank you for visit",
          uId: res[0].uId,
          routeTo: "/LabTestAppListPage",
          sendBy: "user",
          sendFrom: "${widget.appointmentDetails!.pName}",
          sendTo: "Admin");
      await NotificationService.addData(notificationModel);
      _handleSendNotificationVisited(res[0].uId);
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleSendNotificationVisited(uid) async {
    //send local notification

    await HandleLocalNotification.showNotification(
      "Visited",
      "Thank you for visit", // body
    );
    await UpdateData.updateIsAnyNotification("usersList", uid, true);

    //send notification to admin app for booking confirmati
    if (widget.foAdmin)
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAllAppListPage', ModalRoute.withName('/HomePage'));
    else
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAppListPage', ModalRoute.withName('/HomePage'));
  }

  void _handleSendNotificationConfirm(uid) async {
    //send local notification

    await HandleLocalNotification.showNotification(
      "Confirmed",
      "Test Appointment has been confirmed", // body
    );
    await UpdateData.updateIsAnyNotification("usersList", uid, true);

    //send notification to admin app for booking confirmati
    if (widget.foAdmin)
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAllAppListPage', ModalRoute.withName('/HomePage'));
    else
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAppListPage', ModalRoute.withName('/HomePage'));
  }

  void _handleSendNotification(uid) async {
    //send local notification

    await HandleLocalNotification.showNotification(
      "Canceled",
      "Test Appointment has been canceled", // body
    );
    await UpdateData.updateIsAnyNotification("usersList", uid, true);

    //send notification to admin app for booking confirmati
    if (widget.foAdmin)
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAllAppListPage', ModalRoute.withName('/HomePage'));
    else
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/LabTestAppListPage', ModalRoute.withName('/HomePage'));
  }
}
