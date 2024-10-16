import 'package:demoadmin/service/closingDateService.dart';
import 'package:demoadmin/setData/screenArgs.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/checkScreenAdap.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class WalkinChooseTimeSlotPage extends StatefulWidget {
  final openingTime;
  final closingTime;
  final serviceName;
  final serviceTimeMin;
  final closedDay;
  final lunchOpTime;
  final lunchCloTime;
  final drClosingDate;
  final deptName;
  final doctName;
  final hospitalName;
  final doctId;
  final stopBooking;
  final fee;
  final clinicId;
  final cityId;
  final deptId;
  final cityName;
  final clinicName;
  final userModel;
  final payLaterActive;
  final payNowActive;
  final wspd;
  final vspd;
  final videoActive;
  final walkinActive;

  const WalkinChooseTimeSlotPage(
      {Key? key,
      this.openingTime,
      this.closingTime,
      this.serviceName,
      this.serviceTimeMin,
      this.closedDay,
      this.lunchOpTime,
      this.lunchCloTime,
      this.drClosingDate,
      this.deptName,
      this.hospitalName,
      this.doctName,
      this.doctId,
      this.stopBooking,
      this.fee,
      this.cityId,
      this.clinicId,
      this.deptId,
      this.cityName,
      this.clinicName,
      this.userModel,
        this.vspd,
        this.payNowActive,
        this.payLaterActive,
        this.wspd,
        this.videoActive,
        this.walkinActive})
      : super(key: key);

  @override
  _WalkinChooseTimeSlotPageState createState() =>
      _WalkinChooseTimeSlotPageState();
}

class _WalkinChooseTimeSlotPageState extends State<WalkinChooseTimeSlotPage> {
  bool _isLoading = false;
  String _setTime = "";
  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];
  String currentTime = "";
  List _dayCode = [];




  @override
  void initState() {
    currentTime =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    _setTime = currentTime;
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate(); //Initialize start time
    await _getAndSetbookedTimeSlots();
    await _setClosingDate();
    // _getAndsetTimeSlots(
    //     _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);

    setState(() {
      _isLoading = false;
    });
  }

  // _reCallMethodes() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await _getAndSetbookedTimeSlots();
  //   _getAndsetTimeSlots(
  //       _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Future<String> _initializeDate() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.month}-${dateParse.day}-${dateParse.year}";

    return formattedDate;
  }

  Future<void> _getAndSetbookedTimeSlots() async {
    // _bookedTimeSlots =
    //     await ReadData.fetchBookedTime(_selectedDate, widget.doctId);
    // await ReadData().fetchBookedTime(GlobalVariables.selectedClinicId);
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CheckDeviceScreen().CheckDeviceScreenPT()
            ? IAppBars.commonAppBarKiosk(context, "Book appointment")
            : IAppBars.commonAppBar(context, "Book appointment"),
        bottomNavigationBar: BottomNavBarWidget(
          title: "Next",
          onPressed: () {
            if (_closingDate.contains(_selectedDate) ||
                _dayCode.contains(_selectedDay))
              ToastMsg.showToastMsg(
                  "Doctor not taking appointment on $_selectedDate date");
            else
              Navigator.pushNamed(context, "/WalkinRegisterPatient",
                  arguments: ChooseTimeScrArg(
                      widget.serviceName,
                      "0",
                      "As per availability",
                      _selectedDate,
                      widget.doctName,
                      widget.deptName,
                      widget.hospitalName,
                      widget.doctId,
                      widget.fee,
                      widget.deptId,
                      widget.cityId,
                      widget.clinicId,
                      widget.clinicName,
                      widget.cityName,
                      widget.userModel.firstName,
                      widget.userModel.lastName,
                      widget.userModel.phone,
                      widget.userModel.email,
                      widget.userModel.age,
                      widget.userModel.gender,
                      widget.userModel.city,
                      widget.userModel.uId,
                      widget.payNowActive,
                      widget.payLaterActive,
                      widget.wspd,
                      widget.vspd
                  ));
          },
          isEnableBtn: _setTime == "" ? false : true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                  child: SingleChildScrollView(
                    // controller: _scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //    _buildCalendar(),
                        //  Divider(),
                        _isLoading
                            ? LoadingIndicatorWidget()
                            : _closingDate.contains(_selectedDate) ||
                                    _dayCode.contains(_selectedDay)
                                ? Center(
                                    child: Text(
                                    "Sorry! we can't take appointments in this day",
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
                        //       padding:
                        //       const EdgeInsets.only(
                        //           top: 20.0),
                        //       child: Text(
                        //           "Morning Time Slot",
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
                        //     _afternoonTimeSlotsList.length ==
                        //         0
                        //         ? Container()
                        //         : Padding(
                        //       padding:
                        //       const EdgeInsets.only(
                        //           top: 20.0),
                        //       child: Text(
                        //           "Afternoon Time Slot",
                        //           style: TextStyle(
                        //             fontFamily:
                        //             'OpenSans-SemiBold',
                        //             fontSize: 14,
                        //           )),
                        //     ),
                        //     _afternoonTimeSlotsList.length ==
                        //         0
                        //         ? Container()
                        //         : _slotsGridView(
                        //         _afternoonTimeSlotsList,
                        //         _bookedTimeSlots,
                        //         widget.serviceTimeMin),
                        //     _eveningTimeSlotsList.length == 0
                        //         ? Container()
                        //         : Padding(
                        //       padding:
                        //       const EdgeInsets.only(
                        //           top: 20.0),
                        //       child: Text(
                        //           "Evening Time Slot",
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
        ));
  }


  _setClosingDate() async {
    final res = await ClosingDateService.getData(
        widget.doctId); // ReadData.fetchSettings();
    if (res != "null") {
      for (var e in res)
        setState(() {
          _closingDate.add(e.date);
          //res["closingDate"];
        });
    }
    if (widget.drClosingDate != "" && widget.drClosingDate != null) {
      final coledDatArr = (widget.drClosingDate).split(',');
      for (var element in coledDatArr) {
        _closingDate.add(int.parse(element));
      }
    }
  }
}
