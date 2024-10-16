import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class ReWalkInChooseTimeSlotsPage extends StatefulWidget {
  final serviceTimeMin;
  final appointmentId;
  final appointmentDate;
  final uId;
  final uName;
  final serviceName;
  final doctId;
  const ReWalkInChooseTimeSlotsPage(
      {Key? key,
      this.serviceTimeMin,
      this.appointmentId,
      this.appointmentDate,
      this.uId,
      this.uName,
      this.serviceName,
      this.doctId})
      : super(key: key);
  @override
  _ReWalkInChooseTimeSlotsPageState createState() =>
      _ReWalkInChooseTimeSlotsPageState();
}

class _ReWalkInChooseTimeSlotsPageState
    extends State<ReWalkInChooseTimeSlotsPage> {
  bool _isLoading = false;
  bool _isEnableBtn = false;
  String _setTime = "";
  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];

  List _dayCode = [];


  @override
  void initState() {
    _setTime =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate(); //Initialize start time
    //await _getAndSetbookedTimeSlots();
   // await _getAndSetOpeningClosingTime();
    //await _setClosingDate();
    // _getAndSetTimeSlots(
    //     _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
    setState(() {
      _isEnableBtn = true;
    });
    setState(() {
      _isLoading = false;
    });
  }


  Future<String> _initializeDate() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.month}-${dateParse.day}-${dateParse.year}";

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Select Time"),
      bottomNavigationBar: BottomNavBarWidget(
        onPressed: _takeConfirmation,
        title: "Update",
        isEnableBtn: _isEnableBtn && !_isLoading,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                child: SingleChildScrollView(
                  // controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      _buildCalendar(),
                      Divider(),
                      _isLoading
                          ? LoadingIndicatorWidget()
                          : _closingDate.contains(_selectedDate) ||
                                  _dayCode.contains(_selectedDay)
                              ? Center(
                                  child: Text(
                                  "sorry! we don't take appointments in this day",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans-SemiBold',
                                    fontSize: 14,
                                  ),
                                ))
                              : CalDateWidget(selectedDate: _selectedDate)
                      // Column(
                      //   children: <Widget>[
                      //     _morningTimeSlotsList.length == 0
                      //         ? Container()
                      //         : Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text("Morning Time Slot",
                      //           style: TextStyle(
                      //             fontFamily:
                      //             'OpenSans-SemiBold',
                      //             fontSize: 14,
                      //           )),
                      //     ),
                      //     _morningTimeSlotsList.length == 0
                      //         ? Container()
                      //         : _slotsGridView(
                      //         _morningTimeSlotsList,
                      //         _bookedTimeSlots,
                      //         widget.serviceTimeMin),
                      //     _afternoonTimeSlotsList.length == 0
                      //         ? Container()
                      //         : Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text("Afternoon Time Slot",
                      //           style: TextStyle(
                      //             fontFamily:
                      //             'OpenSans-SemiBold',
                      //             fontSize: 14,
                      //           )),
                      //     ),
                      //     _afternoonTimeSlotsList.length == 0
                      //         ? Container()
                      //         : _slotsGridView(
                      //         _afternoonTimeSlotsList,
                      //         _bookedTimeSlots,
                      //         widget.serviceTimeMin),
                      //     _eveningTimeSlotsList.length == 0
                      //         ? Container()
                      //         : Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text("Evening Time Slot",
                      //           style: TextStyle(
                      //             fontFamily:
                      //             'OpenSans-SemiBold',
                      //             fontSize: 14,
                      //           )),
                      //     ),
                      //     _eveningTimeSlotsList.length == 0
                      //         ? Container()
                      //         : _slotsGridView(
                      //         _eveningTimeSlotsList,
                      //         _bookedTimeSlots,
                      //         widget.serviceTimeMin),
                      //   ],
                      // )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _takeConfirmation() {
    if (_closingDate.contains(_selectedDate) || _dayCode.contains(_selectedDay))
      ToastMsg.showToastMsg(
          "Doctor not taking appointment on $_selectedDate date");
    else
      DialogBoxes.confirmationBox(
          context, "Update", "Are you sure want to update", _handleUpdate);
  }

  _handleUpdate() async {
    setState(() {
      _isLoading = true;
      _isEnableBtn = false;
    });
    // final checkRes=await AppointmentService.getCheck( widget.doctId, _selectedDate, _setTime);
    // if(checkRes.length==0){
    //   final res = await UpdateData.updateToRescheduled(
    //       widget.appointmentId,
    //       widget.appointmentDate,
    //       _setTime,
    //       _selectedDate,
    //       widget.serviceTimeMin,
    //       widget.doctId);
    //  if (res == "success") {
    final getDralkinslot = await DrProfileService.getDataByDId(
        widget.doctId);
    int walkinslots = int.parse(getDralkinslot[0].wspd);
    List dateC = _selectedDate.toString().split("-");
    final cehckWalkin = await AppointmentService.getDrWalkinCheck(
        widget.doctId, _selectedDate);
    if (cehckWalkin.length < walkinslots) {
      final appointmentModel = AppointmentModel(
          id: widget.appointmentId,
          appointmentStatus: "Rescheduled",
          appointmentDate: _selectedDate,
          appointmentTime: "As per availability",
          dateC: dateC[2] + "-" + dateC[0] + "-" + dateC[1]);
      final isUpdated =
      await AppointmentService.updateDataResch(appointmentModel);
      if (isUpdated == "success") {
        _sendNotification();
        await AppointmentService.deleteTokenData(widget.appointmentId);
        ToastMsg.showToastMsg("Successfully Updated");
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/AppointmentListPage', ModalRoute.withName('/HomePage'));
      } else {
        ToastMsg.showToastMsg("Something went wrong");
      }
    }else{
      ToastMsg.showToastMsg(
          "Walk-in slots for the selected doctor is already finished for today");
    }

    // } else {
    //   ToastMsg.showToastMsg("Something went wrong");
    // }
    setState(() {
      _isLoading = false;
      _isEnableBtn = true;
    });
    // }
    //  else{
    //    setState(() {
    //      _isLoading = false;
    //      _isEnableBtn = true;
    //    });
    //    ToastMsg.showToastMsg("already booked, please rebook with different time or date");
    //  }
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: primaryColor,
      selectedTextColor: Colors.white,
      onDateChange: (date) {
        // New date selected

        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
        //  _reCallMethods();
          _selectedDay = date.weekday;
        });
      },
    );
  }

  void _sendNotification() async {
    final notificationModel = NotificationModel(
        title: "Rescheduled",
        body:
            "your appointment has been rescheduled to date $_selectedDate time $_setTime",
        uId: widget.uId,
        routeTo: "/Appointmentstatus",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: widget.uName);
    final msgAdded = await NotificationService.addData(notificationModel);

    if (msgAdded == "success") {
      final res = await UserService.getUserById(
          widget.uId); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, "Rescheduled",
          "your appointment has been rescheduled to date $_selectedDate time $_setTime");
      await UpdateData.updateIsAnyNotification("usersList", widget.uId, true);
    }
  }

// _setClosingDate() async {
//   final res = await ReadData.fetchSettings();
//   if (res != null) {
//     setState(() {
//       _closingDate = res["closingDate"];
//     });
//   }
// }
}
