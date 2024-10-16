import 'package:demoadmin/model/appointmentModel.dart';
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/screens/userScreen/registerNewUserPage.dart';
import 'package:demoadmin/screens/walkin/walkinDepartment.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/checkScreenAdap.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KioskHomePage extends StatefulWidget {
  const KioskHomePage({Key? key}) : super(key: key);

  @override
  _KioskHomePageState createState() => _KioskHomePageState();
}

class _KioskHomePageState extends State<KioskHomePage> {
  String clinicName = "";
  String clinicLName = "";
  String imageUrl = "";
  String kioskT1 = "";
  String kioskT2 = "";
  String kioskImage = "";
  @override
  void initState() {
    // TODO: implement initState
    setData();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (CheckDeviceScreen().CheckDeviceScreenPT())
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.portraitDown,
    // ]);
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Container(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 1000,
                        height: 600,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [
                              Colors.transparent,
                              Colors
                                  .black // I don't know what Color this will be, so I can't use this
                            ])),
                      ),
                    ),

                    Positioned(
                      top: CheckDeviceScreen().CheckDeviceScreenPT() ? 20 : 40,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CheckDeviceScreen().CheckDeviceScreenPT()
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 40.0, top: 10),
                                  child: IconButton(
                                      onPressed: () {
                                        openPassD();
                                      },
                                      icon: Icon(
                                        Icons.login,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                )
                              : IconButton(
                                  onPressed: () {
                                    openPassD();
                                  },
                                  icon: Icon(Icons.login,
                                      size: 30, color: Colors.white))
                        ],
                      ),
                    ),
                    Positioned(
                        top: 100,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              kioskT1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      CheckDeviceScreen().CheckDeviceScreenPT()
                                          ? 40
                                          : 30,
                                  fontFamily: "OpenSans-Bold",
                                  color: Colors.white),
                            ),
                            Text(
                              kioskT2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      CheckDeviceScreen().CheckDeviceScreenPT()
                                          ? 25
                                          : 20,
                                  fontFamily: "OpenSans-SemiBold",
                                  color: Colors.white),
                            ),
                          ],
                        )),
                    Positioned(
                      top: 300,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          cardBtn("Walk-in", () {
                            openWalkinApp();
                          }, "assets/icons/Walk-in.png"),
                          SizedBox(
                              width: CheckDeviceScreen().CheckDeviceScreenPT()
                                  ? 30
                                  : 10),
                          cardBtn("Check-in Now", () {
                            openPhnD();
                          }, "assets/icons/Tickets.png")
                        ],
                      ),
                    )

                    // Text("Sub Ttitle",style: TextStyle(
                    //     fontSize: 20,
                    //     fontFamily: "OpenSans-SemiBold"
                    // ),),
                    // Container(
                    //     height:300,
                    //     child:kioskImage==""?ImageBoxFillWidget(imageUrl: "https://1pfbkp23cli23tq36f2bt21b-wpengine.netdna-ssl.com/wp-content/uploads/2019/10/Delta-Kiosk_-1024x640.jpg",): ImageBoxFillWidget(imageUrl: kioskImage,)),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          //kioskImage==""?ImageBoxFillWidget(imageUrl: "https://1pfbkp23cli23tq36f2bt21b-wpengine.netdna-ssl.com/wp-content/uploads/2019/10/Delta-Kiosk_-1024x640.jpg",): ImageBoxFillWidget(imageUrl: kioskImage,)
                          NetworkImage(kioskImage == ""
                              ? "https://1pfbkp23cli23tq36f2bt21b-wpengine.netdna-ssl.com/wp-content/uploads/2019/10/Delta-Kiosk_-1024x640.jpg"
                              : kioskImage),
                      fit: BoxFit.cover))),
        ));
  }

  cardBtn(title, onTap, assetPath) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFF414370),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 10,
        child: Padding(
          padding: CheckDeviceScreen().CheckDeviceScreenPT()
              ? const EdgeInsets.all(50.0)
              : const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                assetPath,
                color: Colors.white,
                height: CheckDeviceScreen().CheckDeviceScreenPT() ? 160 : 60,
                width: CheckDeviceScreen().CheckDeviceScreenPT() ? 160 : 60,
              ),
              //  Icon(Icons.person,size: 40,),
              SizedBox(
                  height: CheckDeviceScreen().CheckDeviceScreenPT() ? 20 : 10),
              Container(
                height: CheckDeviceScreen().CheckDeviceScreenPT() ? 5 : 2,
                width: CheckDeviceScreen().CheckDeviceScreenPT()
                    ? 100
                    : 100, //double.infinity,
                color: Color(0xFF00CAFC),
              ),
              SizedBox(
                  height: CheckDeviceScreen().CheckDeviceScreenPT() ? 20 : 10),
              Text(
                title,
                style: TextStyle(
                    fontSize:
                        CheckDeviceScreen().CheckDeviceScreenPT() ? 25 : 15,
                    color: Colors.white,
                    letterSpacing: 2,
                    fontFamily: "OpenSans-SemiBold"),
              )
            ],
          ),
        ),
      ),
    );
  }

  openPassD() {
    TextEditingController passCont = TextEditingController();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
          key: _formKey,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: new Text(
              "Enter exit key",
              style: TextStyle(
                  fontSize:
                      CheckDeviceScreen().CheckDeviceScreenPT() ? 30 : 16),
            ),
            content: Container(
              child: CheckDeviceScreen().CheckDeviceScreenPT()
                  ? InputFields.intInputFormFieldTablet(
                      context, 'Enter Kiosk exit key', passCont, (item) {
                      return item.length == 0 ? "Enter key" : null;
                    })
                  : InputFields.intInputFormField(
                      context, 'Enter Kiosk exit key', passCont, (item) {
                      return item.length == 0 ? "Enter key" : null;
                    }),
            ),
            actions: <Widget>[
              Padding(
                padding: CheckDeviceScreen().CheckDeviceScreenPT()
                    ? EdgeInsets.only(left: 100.0, bottom: 40, top: 30)
                    : EdgeInsets.only(left: 100.0, bottom: 10, top: 0),
                child: new ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: btnColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        "OK",
                        style: TextStyle(
                            fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                                ? 30
                                : 16),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (passCont.text == "12345678") {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setBool("kioskmode", false);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else
                          ToastMsg.showToastMsg("Wrong key");
                      }

                      // onPressed();
                    }),
              ),
              Padding(
                padding: CheckDeviceScreen().CheckDeviceScreenPT()
                    ? EdgeInsets.only(left: 10.0, bottom: 40, top: 30)
                    : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: btnColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                                ? 30
                                : 16),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      // onPressed();
                    }),
              ),
              // usually buttons at the bottom of the dialog
            ],
          ),
        );
      },
    );
  }

  openPhnD() {
    bool isLoading = false;
    TextEditingController passCont = TextEditingController();
    //  passCont.text="8889990643";
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
          key: _formKey,
          child: StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: new Text(
                  "Check-in now!",
                  style: TextStyle(
                      fontSize:
                          CheckDeviceScreen().CheckDeviceScreenPT() ? 30 : 16),
                ),
                content: isLoading
                    ? Container(
                        height: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 300
                            : 100,
                        child: LoadingIndicatorWidget())
                    : CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.intInputFormFieldTablet(
                            context, 'Enter Phone Number', passCont, (item) {
                            return item.length == 0 ? "Enter Number" : null;
                          })
                        : InputFields.intInputFormField(
                            context, 'Enter Phone Number', passCont, (item) {
                            return item.length == 0 ? "Enter Number" : null;
                          }),
                actions: isLoading
                    ? null
                    : <Widget>[
                        Padding(
                          padding: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? EdgeInsets.only(
                                  left: 100.0, bottom: 40, top: 30)
                              : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
                          child: new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: CheckDeviceScreen()
                                              .CheckDeviceScreenPT()
                                          ? 30
                                          : 16),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  List allAppId = [];

                                  final date = DateTime.now();
                                  final String sendDate =
                                      date.month.toString() +
                                          "-" +
                                          date.day.toString() +
                                          "-" +
                                          date.year.toString();
                                  final res =
                                      await AppointmentService.getAppByPhn(
                                          passCont.text, sendDate);

                                  if (res.length == 0) {
                                    ToastMsg.showToastMsg(
                                        "No appointment found");
                                  } else if (res.length > 0) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String frontDeskClinicId =
                                        prefs.getString("fdClinicId") ?? "";
                                    res.forEach((element) {
                                      if (frontDeskClinicId ==
                                          element.clinicId.toString()) {
                                        allAppId.add({
                                          "appId": element.id.toString(),
                                          "doctId": element.doctId.toString(),
                                          "dateC": element.dateC.toString(),
                                          "appDate": element.appointmentDate,
                                          "time": element.appointmentTime,
                                          "uid": element.uId,
                                          "uName": element.uName
                                        });
                                      }
                                    });

                                    for (int i = 0; i < allAppId.length;) {
                                      final res = await AppointmentService
                                          .getTokenByAppId(
                                              allAppId[i]['appId']);
                                      if (res.length == 0) {
                                        //print(allAppId[i]);
                                        final appointmentModel =
                                            AppointmentModel(
                                                id: allAppId[i]['appId'],
                                                appointmentStatus: "Confirmed");
                                        final res = await AppointmentService
                                            .updateStatus(appointmentModel);
                                        if (res == "success") {
                                          final getToekn =
                                              await AppointmentService.getToken(
                                                  allAppId[i]['doctId'],
                                                  allAppId[i]['dateC']);
                                          print(getToekn);
                                          if (getToekn.length == 0) {
                                            final addedToken =
                                                await AppointmentService
                                                    .addToken(
                                                        doctId: allAppId[i]
                                                            ['doctId'],
                                                        appId: allAppId[i]
                                                            ['appId'],
                                                        tokenNum: "1",
                                                        date: allAppId[i]
                                                            ['dateC'],
                                                        tokenType: "0");
                                            if (addedToken == "success")
                                              await _sendNotification(
                                                  "Appointment Checkedin",
                                                  "1",
                                                  allAppId[i]['appDate'],
                                                  allAppId[i]['time'],
                                                  allAppId[i]['uid'],
                                                  allAppId[i]['uName'],
                                                  allAppId[i]['appId']);
                                          } else if (getToekn.length > 0) {
                                            int tokenNum = int.parse(getToekn[
                                                        getToekn.length - 1]
                                                    .tokenNum) +
                                                1;
                                            //print("tnum $getToekn[getToekn.length-1].tokenNum $tokenNum");
                                            final addedToken =
                                                await AppointmentService
                                                    .addToken(
                                                        doctId: allAppId[i]
                                                            ['doctId'],
                                                        appId: allAppId[i]
                                                            ['appId'],
                                                        tokenNum:
                                                            tokenNum.toString(),
                                                        date: allAppId[i]
                                                            ['dateC'],
                                                        tokenType: "0");
                                            if (addedToken == "success")
                                              await _sendNotification(
                                                  "Appointment Checkedin",
                                                  tokenNum.toString(),
                                                  allAppId[i]['appDate'],
                                                  allAppId[i]['time'],
                                                  allAppId[i]['uid'],
                                                  allAppId[i]['uName'],
                                                  allAppId[i]['appId']);
                                          }

                                          if (i == allAppId.length - 1) {
                                            Navigator.pop(context);
                                            successPopUp();
                                          }
                                          i++;
                                        } else {
                                          ToastMsg.showToastMsg(
                                              "Something went wrong");
                                          break;
                                        }
                                      } else if (res.length > 0) {
                                        // print("miiiiiiiiiiiiiiiiiiiiiiiiiiiii $i ${allAppId.length-1}");
                                        if (i == allAppId.length - 1) {
                                          Navigator.pop(context);
                                          alreadyGetTokenPopUp();
                                        }
                                        i++;
                                      } else {
                                        ToastMsg.showToastMsg(
                                            "Something went wrong");
                                        break;
                                      }
                                    }
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                  //   Navigator.of(context).pop();
                                }
                                // onPressed();
                              }),
                        ),
                        Padding(
                          padding: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? EdgeInsets.only(left: 10.0, bottom: 40, top: 30)
                              : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: CheckDeviceScreen()
                                              .CheckDeviceScreenPT()
                                          ? 30
                                          : 16),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                // onPressed();
                              }),
                        ),
                        // usually buttons at the bottom of the dialog
                      ],
              ),
            );
          }),
        );
      },
    );
  }

  openWalkinApp() {
    bool isLoading = false;
    TextEditingController passCont = TextEditingController();
    //passCont.text="8889990643";
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
          key: _formKey,
          child: StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: Container(
                  child: new Text(
                    "Walk-in Token",
                    style: TextStyle(
                        fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 30
                            : 16),
                  ),
                ),
                content: isLoading
                    ? Container(
                        height: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 300
                            : 100,
                        child: LoadingIndicatorWidget())
                    : CheckDeviceScreen().CheckDeviceScreenPT()
                        ? InputFields.intInputFormFieldTablet(
                            context, 'Enter Phone Number', passCont, (item) {
                            return item.length == 0 ? "Enter Number" : null;
                          })
                        : InputFields.intInputFormField(
                            context, 'Enter Phone Number', passCont, (item) {
                            return item.length == 0 ? "Enter Number" : null;
                          }),
                actions: isLoading
                    ? null
                    : <Widget>[
                        Padding(
                          padding: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? EdgeInsets.only(
                                  left: 100.0, bottom: 40, top: 30)
                              : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
                          child: new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: CheckDeviceScreen()
                                              .CheckDeviceScreenPT()
                                          ? 30
                                          : 16),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final getUserDetails =
                                      await UserService.getDataByPhn(
                                          passCont.text);
                                  if (getUserDetails.length == 0) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterNewUsersPage(
                                                phn: passCont.text),
                                      ),
                                    );
                                  }
                                  //     ToastMsg.showToastMsg("No user found");
                                  else if (getUserDetails.length > 0) {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    final clinicId =
                                        preferences.getString("fdClinicId");
                                    final getClinicData =
                                        await ClinicService.getDataByClinicId(
                                            clinicId ?? "");
                                    if (getClinicData.isNotEmpty) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WalkinDepartmentPage(
                                                  userModel: getUserDetails[0],
                                                  clinicId: getClinicData[0]
                                                      .id
                                                      .toString(),
                                                  cityId: getClinicData[0]
                                                      .cityId
                                                      .toString(),
                                                  cityName:
                                                      getClinicData[0].cityName,
                                                  clinicLocationName:
                                                      getClinicData[0]
                                                          .locationName,
                                                  clinicName:
                                                      getClinicData[0].title),
                                        ),
                                      );
                                    } else
                                      ToastMsg.showToastMsg(
                                          "Something went wrong");
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  //   Navigator.of(context).pop();
                                }
                                // onPressed();
                              }),
                        ),
                        Padding(
                          padding: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? EdgeInsets.only(left: 10.0, bottom: 40, top: 30)
                              : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontFamily: "OpenSans-SemiBold",
                                      fontSize: CheckDeviceScreen()
                                              .CheckDeviceScreenPT()
                                          ? 30
                                          : 16),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                // onPressed();
                              }),
                        ),
                        // usually buttons at the bottom of the dialog
                      ],
              ),
            );
          }),
        );
      },
    );
  }

  _sendNotification(
      String title, tokenNum, date, time, uid, uName, appId) async {
    String body = "";
    switch (title) {
      case "Confirmed":
        {
          body =
              "Your appointment has been confirmed for date: $date} time: ${time}";
          break;
        }
      case "Appointment Checkedin":
        {
          body =
              "Your Token Number is A-$tokenNum for appointment date: ${date} time: ${time}";
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
        uId: uid,
        routeTo: "/Appointmentstatus",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo: uName);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res =
          await UserService.getUserById(uid); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification("usersList", uid, true);
    }
  }

  void setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("kioskmode", true);
    setState(() {
      clinicName = preferences.getString("fclinicName") ?? "";
      clinicLName = preferences.getString("fclinicLName") ?? "";
      imageUrl = preferences.getString("fclinicImage") ?? "";
      imageUrl = preferences.getString("fclinicImage") ?? "";

      kioskT1 = preferences.getString("fdkt1") ?? "";
      kioskT2 = preferences.getString("fdkt2") ?? "";
      kioskImage = preferences.getString("fdkt1image") ?? "";
    });
  }

  alreadyGetTokenPopUp() {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text(
            "Token Generated",
            style: TextStyle(
                fontSize: CheckDeviceScreen().CheckDeviceScreenPT() ? 30 : 16),
          ),
          content: Text(
            "Thank you, Token has been already generated for all your appointments today.",
            style: TextStyle(
                fontSize: CheckDeviceScreen().CheckDeviceScreenPT() ? 25 : 16),
          ),
          actions: <Widget>[
            Padding(
              padding: CheckDeviceScreen().CheckDeviceScreenPT()
                  ? EdgeInsets.only(left: 10.0, bottom: 40, top: 30)
                  : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
              child: new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Back",
                      style: TextStyle(
                          fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? 30
                              : 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // onPressed();
                  }),
            ),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  successPopUp() {
    return showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Text("Token Generated",
              style: TextStyle(
                  fontSize:
                      CheckDeviceScreen().CheckDeviceScreenPT() ? 30 : 16)),
          content: Text(
              "Thank you, Token generated for all your appointments today.",
              style: TextStyle(
                  fontSize:
                      CheckDeviceScreen().CheckDeviceScreenPT() ? 25 : 16)),
          actions: <Widget>[
            Padding(
              padding: CheckDeviceScreen().CheckDeviceScreenPT()
                  ? EdgeInsets.only(left: 10.0, bottom: 40, top: 30)
                  : EdgeInsets.only(left: 10.0, bottom: 10, top: 0),
              child: new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      "Back",
                      style: TextStyle(
                          fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                              ? 30
                              : 16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // onPressed();
                  }),
            ),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }
}
