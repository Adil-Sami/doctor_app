import 'package:demoadmin/Service/appointmentService.dart';
import 'package:demoadmin/service/assign_workers.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/pdfApi.dart';
import 'package:demoadmin/service/workerService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/attandence_service.dart';
import 'package:demoadmin/model/attendance_model.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:demoadmin/service/pdfs/pdfWorkerAtten.dart';

class WorkerAttPage extends StatefulWidget {
  final workerId;
  final workerName;
  final clinciId;

  const WorkerAttPage({Key? key,this.workerId,this.workerName,this.clinciId}) : super(key: key);

  @override
  State<WorkerAttPage> createState() => _WorkerAttPageState();
}

class _WorkerAttPageState extends State<WorkerAttPage> {
  DateRangePickerSelectionChangedArgs? argsDatePdf;
  String firstDate = "All";
  String lastDate = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: (){
                cDialogBoxPdf();
              },
            ),
            backgroundColor: btnColor,
            onPressed: () {}),
      appBar: IAppBars.commonAppBar(context, "Attendance"),
      body:   FutureBuilder(
          future: AttendanceService.getData(widget.workerId,widget.clinciId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length == 0
                  ?
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("No Attendance History"),
              )
                  : _buildUserList(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("");
            } else {
              return LoadingIndicatorWidget();
            }
          })
    );
  }
  _buildUserList(data) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context,index){
          AttendanceModel attendanceModel=data[index];
          return
            Card(
              child: ListTile(
                title:Text(attendanceModel.task_title) ,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text("Check-in Date: ${getDate(attendanceModel.time_stamp)}"),
                    const SizedBox(height: 5),
                    Text("Check-in Time: ${getTime(attendanceModel.time_stamp)}"),
                    const SizedBox(height: 5),
                    Text("Check-out Date: ${getDate(attendanceModel.end_time_stamp)}"),
                    const SizedBox(height: 5),
                    Text("Check-out Time: ${getTime(attendanceModel.end_time_stamp)}"),
                    const SizedBox(height: 10),
                    attendanceModel.end_time_stamp==null?Container():Text("Work Time: ${getWorkHour(attendanceModel.time_stamp,attendanceModel.end_time_stamp)}")
                  ],
                ),
              ),
            );
        });
  }
  cDialogBoxPdf() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(''),
            content: Container(
              //   height: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 250,
                    width: 250,
                    child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChangedPdf,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange: argsDatePdf == null
                            ? null
                            : PickerDateRange(
                            DateTime.now()
                                .subtract(const Duration(days: 4)),
                            DateTime.now().add(const Duration(days: 3)))),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("OK"),
                  onPressed: () {
                    if (argsDatePdf!.value.startDate != null &&
                        argsDatePdf!.value.endDate != null) {
                      var pickedStartDate = DateFormat('yyyy-MM-dd')
                          .format(argsDatePdf!.value.startDate);
                      var pickedEndDate = DateFormat('yyyy-MM-dd')
                          .format(argsDatePdf!.value.endDate);
                      // print(DateFormat('yyyy-MM-dd').format(argsDate!.value.startDate));
                      // print(DateFormat('yyyy-MM-dd').format(argsDate!.value.endDate));
                      setState(() {
                        //_selectedFirstDate = argsDate!.value.startDate;
                        //_selectedLastDate= argsDate!.value.endDate;
                        firstDate =
                            pickedStartDate; //_setTodayDateFormat(picked.first);
                        lastDate =
                            pickedEndDate; // _setTodayDateFormat(picked.last);
                      });

                      generatePdf();
                      Navigator.of(context).pop();
                    } else
                      ToastMsg.showToastMsg("select date range");
                  }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
  void _onSelectionChangedPdf(DateRangePickerSelectionChangedArgs args) {
    argsDatePdf = args;
  }
  void generatePdf() async {

    var status = await Permission.storage.request();


    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else if (status.isGranted) {
      String clinicName="";
      final clinicRes=await ClinicService.getDataByClinicId(widget.clinciId);
      if(clinicRes.isNotEmpty){
        clinicName=clinicRes[0].title;
      }
      final appModel = await AttendanceService.getReportData(
           firstDate, lastDate,widget.workerId,widget.clinciId);

      if(appModel.isNotEmpty) {
        final pdfFile = await WorkerAttReportApiPdf(clinicName: clinicName)
            .generateTable(appModel);
        PdfApi.openFile(pdfFile);
      }else{
        ToastMsg.showToastMsg("No Dara Found For Selected Date");
      }


    }

// You can can also directly ask the permission about its status.
  }
  String getDate(time_stamp) {
    if(time_stamp==null)
      return "--";
    final dateTime=DateTime.parse(time_stamp);
    final date="${dateTime.day}-${dateTime.month}-${dateTime.year}";
    return date.toString();
  }
  String getTime(time_stamp) {
    if(time_stamp==null)
      return "--";
    final dateTime=DateTime.parse(time_stamp);
    final time="${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    return time.toString();
  }


  getWorkHour(time_stamp, end_time_stamp) {
    final checkinTime=DateTime.parse(time_stamp);
    final checkoutTime=DateTime.parse(end_time_stamp);
    final timeDiff=checkoutTime.difference(checkinTime);
    return "${(timeDiff.inMinutes/60).toInt()}Hour:${(timeDiff.inMinutes%60).toInt()}Minute";
  }
}
