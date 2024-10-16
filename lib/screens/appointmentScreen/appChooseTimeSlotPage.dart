import 'package:demoadmin/model/doctTimeSlotModel.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/closingDateService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/setData/screenArgs.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class AppChooseTimeSlotPage extends StatefulWidget {
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
  final vspd;
  final wspd;
  final payNowActive;
  final payLaterActive;

  const AppChooseTimeSlotPage(
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
      this.wspd,
      this.payLaterActive,
      this.payNowActive,
      this.vspd})
      : super(key: key);

  @override
  _AppChooseTimeSlotPageState createState() => _AppChooseTimeSlotPageState();
}

class _AppChooseTimeSlotPageState extends State<AppChooseTimeSlotPage> {
  List<DoctorTimeSlotModel> drTimeSlots=[];
  int filledSlot=0;
  bool _isLoading = false;

  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];
  ScrollController scrollController=ScrollController();
  List _dayCode = [];


  @override
  void initState() {
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate(); //Initialize start time
    // await _getAndSetbookedTimeSlots();
    // await _getAndSetOpeningClosingTime();
    await _setClosingDate();
    // _getAndsetTimeSlots(
    //     _openingTimeHour, _openingTimeMin, _closingTimeHour, _closingTimeMin);

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
        appBar: IAppBars.commonAppBar(context, "Book appointment"),
        // bottomNavigationBar: BottomNavBarWidget(
        //   title: "Next",
        //   onPressed: () {
        //     Navigator.pushNamed(context, "/RegisterPatientPage",
        //         arguments: ChooseTimeScrArg(
        //             widget.serviceName,
        //             widget.serviceTimeMin,
        //             _setTime,
        //             _selectedDate,
        //             widget.doctName,
        //             widget.deptName,
        //             widget.hospitalName,
        //             widget.doctId,
        //             widget.fee,
        //             widget.deptId,
        //             widget.cityId,
        //             widget.clinicId,
        //             widget.clinicName,
        //             widget.cityName,
        //             widget.userModel.firstName,
        //             widget.userModel.lastName,
        //             widget.userModel.phone,
        //             widget.userModel.email,
        //             widget.userModel.age,
        //             widget.userModel.gender,
        //             widget.userModel.city,
        //             widget.userModel.uId
        //         ));
        //   },
        //   isEnableBtn: _setTime == "" ? false : true,
        // ),
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
                      children: <Widget>[
                        _buildCalendar(),
                        Divider(),
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
                                : !checkSlotExists()?
                        Text(
                          "Sorry! no any slots available in this date",
                          style: TextStyle(
                            fontFamily: 'OpenSans-SemiBold',
                            fontSize: 14,
                          ),
                        )

                            :Column(
                          children: [
                            Text( widget.serviceName=="Offline"?"Walk-in Appointment ${filledSlot}/${widget.wspd} Slots":"Video Consultant ${filledSlot}/${widget.vspd} Slots",  style: TextStyle(
                              fontFamily: 'OpenSans-SemiBold',
                              fontSize: 14,
                            )),
                            ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: drTimeSlots.length,
                                itemBuilder: (context, index) {
                                  final slotType=widget.serviceName=="Online"?"1":"0";
                                  return  drTimeSlots[index].dayCode==_selectedDay.toString()&&drTimeSlots[index].slotType==slotType?
                                  Card(
                                    color: Colors.grey.shade100,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 1,
                                    child: ListTile(
                                      title: Text(drTimeSlots[index].timeSlot,
                                        style: TextStyle(
                                          fontFamily: 'OpenSans-SemiBold',
                                          fontSize: 16,
                                        ),),
                                      trailing:ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            shape:
                                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                          ),
                                          onPressed: (){
                                                Navigator.pushNamed(context, "/RegisterPatientPage",
                                                    arguments: ChooseTimeScrArg(
                                                        widget.serviceName,
                                                        widget.serviceTimeMin,
                                                        drTimeSlots[index].timeSlot,
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
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                                            child: Text( "Book", style: TextStyle(fontSize: 14)),
                                          )),
                                    ),
                                  ):Container();

                                }),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget _buildCalendar() {
    return DatePicker(
      DateTime.now(),
      initialSelectedDate: DateTime.now(),
      selectionColor: appBarColor,
      selectedTextColor: Colors.white,
      daysCount: 7,
      onDateChange: (date) {
        // New date selected
        setState(() {
          final dateParse = DateTime.parse(date.toString());

          _selectedDate =
              "${dateParse.month}-${dateParse.day}-${dateParse.year}";
          _selectedDay = date.weekday;
          checkFilledSlot(_selectedDate);

        });
      },
    );
  }
  _setClosingDate() async {
    final res = await ClosingDateService.getData(
        widget.doctId); // ReadData.fetchSettings();
    if (res.isNotEmpty) {
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
    final getDrSlots=await DrProfileService.getDoctTimeSlot(widget.doctId);
    if(getDrSlots.isNotEmpty)
      setState(() {
        drTimeSlots=getDrSlots;
      });
  }
  bool checkSlotExists() {
    final slotType=widget.serviceName=="Online"?"1":"0";
    bool exists=false;
    for(int i=0;i<drTimeSlots.length;i++){
      if(drTimeSlots[i].dayCode==_selectedDay.toString()&&drTimeSlots[i].slotType==slotType)
      {
        exists=true;
        break;
      }
    }

    return exists;
  }
  void checkFilledSlot(selectedDate) async{
    setState(() {
      _isLoading=true;
    });
    final checkRes = await AppointmentService.getCheckPD(
        widget.doctId,
        selectedDate,
        widget.serviceName=="Online"?"true":"false");
    setState(() {
      filledSlot=checkRes.length;
    });

    setState(() {
      _isLoading=false;
    });
  }
}
