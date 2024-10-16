import 'package:demoadmin/config.dart';
import 'package:demoadmin/service/closingDateService.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/datePicker.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:http/http.dart' as http;
import 'package:time_range_picker/time_range_picker.dart';

class ManageAddDateToCloseBookingPage extends StatefulWidget {
  final doctId;
  ManageAddDateToCloseBookingPage({this.doctId});
  @override
  _ManageAddDateToCloseBookingPageState createState() =>
      _ManageAddDateToCloseBookingPageState();
}

class _ManageAddDateToCloseBookingPageState
    extends State<ManageAddDateToCloseBookingPage> {
  bool _isLoading = false;
  String doctId = "";
  Map blockTime = Map();
  @override
  void initState() {
    getAndSetDoctId();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Choose Closing Date"),
        // bottomNavigationBar: BottomNavBarWidget(
        //   title: "Update",
        //   isEnableBtn: _isEnableBtn,
        //   onPressed: _takeConfirmation,
        // ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: primaryColor,
          onPressed: () async {
            final res = await DatePicker.datePicker(context);
            if (res != "") {
              _handleUpdate(res);
              // if (_date.contains(res))
              //   setState(() {
              //     _date.remove(res);
              //   });
              // else
              //   setState(() {
              //     _date.add(res);
              //   });
            }
          },
        ),
        body: _isLoading
            ? LoadingIndicatorWidget()
            : //_buildListTileCard(_data)
            FutureBuilder(
                future: ClosingDateService.getData(
                    doctId), // fetch all images form the database
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return snapshot.data.length == 0
                        ? NoDataWidget()
                        : _buildListTileCard(snapshot.data);
                  else if (snapshot.hasError)
                    return IErrorWidget(); //if any error then you can also use any other widget here
                  else
                    return LoadingIndicatorWidget();
                }));
  }


  _handleUpdate(date) async {
    // print(date);
    setState(() {
      _isLoading = true;

    });

    final res = await http.post(Uri.parse("$apiUrl/add_cdate"),
        body: {"doctId": doctId, "date": date});
    if (res.statusCode == 200) {
      //  print(res.body);
      if (res.body == "success") {
        ToastMsg.showToastMsg("Successfully updated");
      } else if (res.body == "already exists") {
        ToastMsg.showToastMsg("already exists");
      } else {
        ToastMsg.showToastMsg("Something went wrong");
      }
    }

    setState(() {
      _isLoading = false;

    });
  }

  Widget _buildListTileCard(date) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: date.length,
        itemBuilder: (context, index) {
          return Card(
              child: ExpansionTile(
            title: ListTile(
              title: Text("${date[index].date}"),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: primaryColor,
                ),
                onPressed: () {
                  DialogBoxes.confirmationBox(
                      context, "Delete", "Are you sure want to delete date",
                      () {
                    _handleDelete(date[index].id);
                  });
                },
              ),
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Block Full Day"),
                  date[index].allDay == "0"
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              if (date[index].allDay == "0")
                                _updateAllDay(date[index].id, "1");
                              //_data[index].allDay="1";
                              else if (date[index].allDay == "1")
                                _updateAllDay(date[index].id, "0");
                              // _data[index].allDay="0";
                            });
                          },
                          icon: Icon(
                            Icons.toggle_off_outlined,
                            size: 30,
                            color: Colors.red,
                          ))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              if (date[index].allDay == "0")
                                _updateAllDay(date[index].id, "1");
                              else if (date[index].allDay == "1")
                                _updateAllDay(date[index].id, "0");
                            });
                          },
                          icon: Icon(
                            Icons.toggle_on_outlined,
                            size: 30,
                            color: Colors.green,
                          ))
                ],
              ),
              ListView.builder(
                  itemCount: date[index].blockTime.length,
                  shrinkWrap: true,
                  itemBuilder: (context, indexes) {
                    return ListTile(
                        title: Text(date[index].blockTime[indexes]['opt'] +
                            " To " +
                            date[index].blockTime[indexes]['clt']),
                        trailing: IconButton(
                          onPressed: () {
                            _handleDeleteTime(
                                date[index].blockTime[indexes]['block_id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ));
                  }),
              date[index].allDay == "0"
                  ? ListTile(
                      onTap: () {
                        _addDates(date[index].id);
                      },
                      title: Text("Add Day"),
                      trailing: Icon(Icons.add),
                    )
                  : Container()
            ],
          ));
        });
  }

  _updateAllDay(id, status) async {
    setState(() {
      _isLoading = true;
    });
    print(id);
    print(status);
    final res = await ClosingDateService.updateAllday(id, status);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully update");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }
    setState(() {
      _isLoading = false;
    });
  }

  _handleDelete(String id) async {
    setState(() {
      _isLoading = true;

    });

    final res = await ClosingDateService.deleteData(id);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully deleted");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }

    setState(() {
      _isLoading = false;

    });
  }

  void getAndSetDoctId() async {
    setState(() {
      _isLoading = true;
    });
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    doctId = widget.doctId;
    final res = await ClosingDateService.getData(doctId);
    res.forEach((element) {
      setState(() {
        blockTime[element.date] = [];
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _addDates(dateId) async {
    TimeRange result = await showTimeRangePicker(
      // start:// TimeOfDay(
      // hour: int.parse(_clinicOpeningTime.substring(0, 2)),
      // minute: int.parse(_clinicOpeningTime.substring(3, 5))),
      // end: TimeOfDay(
      //     hour: int.parse(_clinicClosingTime.substring(0, 2)),
      //     minute: int.parse(_clinicClosingTime.substring(3, 5))),
      strokeColor: primaryColor,
      handlerColor: primaryColor,
      selectedColor: primaryColor,
      context: context,
    );
    if (result != "null") {
      //  setState(() {
      if (result.toString().substring(17, 22) ==
          result.toString().substring(37, 42)) {
        ToastMsg.showToastMsg("please select different times");
      } else {
        setState(() {
          _isLoading = true;
        });
        final opt = result.toString().substring(17, 22);
        final clt = result.toString().substring(37, 42);
        final res = await ClosingDateService.addBlockTimeManage(
            dateId, opt, clt, doctId);
        if (res == "already exists")
          ToastMsg.showToastMsg("already exists");
        else if (res == "success")
          ToastMsg.showToastMsg("Updated");
        else
          ToastMsg.showToastMsg("error");
        setState(() {
          _isLoading = false;
        });
        // setState(() {
        //   blockTime['$date'].add({
        //     "opt":opt,
        //     "clt":clt
        //   });
        // var days={
        //   "$date":[ {
        //     "opt":opt,
        //     "clt":clt
        //   }]
        // };
        //   print(blockTime);
        //
        // blockTime.add("$date":{
        //
        // });
        // });
        // _clinicOpeningTime = ;
        // _clinicClosingTime = result.toString().substring(37, 42);
        //_isEnableBtn = true;
      }
      // });
    }
  }

  void _handleDeleteTime(blockTime) async {
    setState(() {
      _isLoading = true;
    });

    final res = await ClosingDateService.deleteTime(blockTime);
    if (res == "success") {
      ToastMsg.showToastMsg("Successfully deleted");
    } else {
      ToastMsg.showToastMsg("Something went wrong");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
