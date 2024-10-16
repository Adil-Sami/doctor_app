import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/doctTimeSlotModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';

class ChooseTimeSlotsPage extends StatefulWidget {
  final serviceTimeMin;
  final appointmentId;
  final appointmentDate;
  final uId;
  final uName;
  final serviceName;
  final doctId;
  const ChooseTimeSlotsPage(
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
  _ChooseTimeSlotsPageState createState() => _ChooseTimeSlotsPageState();
}

class _ChooseTimeSlotsPageState extends State<ChooseTimeSlotsPage> {
  ScrollController scrollController=ScrollController();
  bool _isLoading = false;
  String _setTime = "";
  var _selectedDate;
  var _selectedDay = DateTime.now().weekday;
  List _closingDate = [];

  List<DoctorTimeSlotModel> drTimeSlots=[];
  List _dayCode = [];

  String payNowActive="true";
  String payLaterActive="true";
  String wspdp="0";
  String vspd="0";
  int filledSlot=0;

  @override
  void initState() {
    super.initState();
    _getAndSetAllInitialData();
  }

  _getAndSetAllInitialData() async {
    setState(() {
      _isLoading = true;
    });

    _selectedDate = await _initializeDate();
    final getDrSlots=await DrProfileService.getDoctTimeSlot(widget.doctId);
    if(getDrSlots.isNotEmpty)
      setState(() {
        drTimeSlots=getDrSlots;
      });//Initialize start time
    final getDrDetails=await DrProfileService.getDataByDId(widget.doctId);
    if(getDrDetails.isNotEmpty){
      payLaterActive=getDrDetails[0].payLater;
      payNowActive=getDrDetails[0].payNow;
      wspdp=getDrDetails[0].wspdp;
      vspd=getDrDetails[0].vspd;
    }

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
      // bottomNavigationBar: BottomNavBarWidget(
      //   onPressed: _takeConfirmation,
      //   title: "Update",
      //   isEnableBtn: _isEnableBtn,
      // ),
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
                              : !checkSlotExists()?
                      Text(
                        "Sorry! no any slots available in this date",
                        style: TextStyle(
                          fontFamily: 'OpenSans-SemiBold',
                          fontSize: 14,
                        ),
                      ):
                      Column(
                        children: [
                          Text( widget.serviceName=="Offline"?"Walk-in Appointment ${filledSlot}/${wspdp} Slots":"Video Consultant ${filledSlot}/${vspd} Slots",  style: TextStyle(
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
                                          _handleUpdate(drTimeSlots[index].timeSlot);

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
      ),
    );
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


  _handleUpdate(timeSlot) async {
    setState(() {
      _isLoading = true;
    });
    final checkRes = await AppointmentService.getCheckPD(
        widget.doctId, _selectedDate,widget.serviceName=="Online"?"true":"false");
    if (checkRes.length<int.parse(wspdp)) {
      // final res = await UpdateData.updateToRescheduled(
      //     widget.appointmentId,
      //     widget.appointmentDate,
      //     _setTime,
      //     _selectedDate,
      //     widget.serviceTimeMin,
      //     widget.doctId);
    //  if (res == "success") {
        List dateC = _selectedDate.toString().split("-");
        final appointmentModel = AppointmentModel(
            id: widget.appointmentId,
            appointmentStatus: "Rescheduled",
            appointmentDate: _selectedDate,
            appointmentTime: timeSlot,
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
      // }
      // else {
      //   ToastMsg.showToastMsg("Something went wrong");
      // }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ToastMsg.showToastMsg(
          "All slots are filled,please rebook with different date");
    }
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
          _selectedDay = date.weekday;
          checkFilledSlot(_selectedDate);
        });
      },
    );
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
