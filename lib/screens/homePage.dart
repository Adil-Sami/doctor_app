import 'dart:async';
import 'package:demoadmin/service/Notification/handleLocalNotification.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/utilities/checkScreenAdap.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/readData.dart';
import 'package:demoadmin/utilities/clipPath.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../service/notification_services.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Locale? locale=Get.locale;
  ScrollController _gridScrollController = new ScrollController();
  bool _isLoading = false;
  String doctName = "";
  String doctId = "";
  String userType = "";
  String doctProfile = "";
  String fdName = "";
  String fdImage = "";
  bool locationEnabled=false;
  Timer? _timer;
  String pharmaId="";
  String labAttenderId="";
  String laName="";
  String laImage="";
  String pharmaName="";
  String pharmaImage="";
  List _widgetsList = [
    {
      "iconName": "assets/icons/appointments.png",
      "title": "Appointments",
      "navigation": "/AppointmentListPage"
    },
    {
      "iconName": "assets/icons/Services.png",
      "title": "Service",
      "navigation": "/ServicesPage"
    },

    {
      "iconName": "assets/icons/Notifications.png",
      "title": "Notification",
      "navigation": "/NotificationListPage"
    },
    {
      "iconName": "assets/icons/City.png",
      "title": "Cities",
      "navigation": "/CityListPage"
    },
    {
      "iconName": "assets/icons/Hospital.png",
      "title": "Clinic",
      "navigation": "/ChooseClinicCityListPage"
    },
    {
      "iconName": "assets/icons/Department.png",
      "title": "Department",
      "navigation": "/ChooseDeptCityListPage"
    },
    {
      "iconName": "assets/icons/Doctors.png",
      "title": "Doctors",
      "navigation": "/ChooseDoctCityListPage"
    },

    {
      "iconName": "assets/icons/Feedback.png",
      "title": "Feedback",
      "navigation": "/FeedbackListPage"
    },

    // {
    //   "iconName": "assets/icons/doct.svg",
    //   "title": "Profile",
    //   "navigation": "/EditProfilePage"
    // },

    {
      "iconName": "assets/icons/HealthBlog.png",
      "title": "Health Blog",
      "navigation": "/BlogPostPage"
      //"/TestimonialsPage"
    },
    {
      "iconName": "assets/icons/Gallery.png",
      "title": "Gallery",
      "navigation": "/EditGalleryPage"
    },
    // {
    //   "iconName": "assets/icons/timing.svg",
    //   "title": "Timing",
    //   "navigation": "/EditOpeningClosingTime"
    // },
    {
      "iconName": "assets/icons/Availability.png",
      "title": "Availability",
      "navigation": "/EditAvailabilityPage"
    },
    // {
    //   "iconName": "assets/icons/type.svg",
    //   "title": "Types",
    //   "navigation": "/AppointmentTypesPage"
    // },
    {
      "iconName": "assets/icons/Settings.png",
      "title": "Setting",
      "navigation": "/EditBookingTiming"
    },
    {
      "iconName": "assets/icons/Users.png",
      "title": "Users",
      "navigation": "/UsersListPage"
    },
    {
      "iconName": "assets/icons/Banner.png",
      "title": "Banner Image",
      "navigation": "/EditBannerImagesPage"
    },
    {
      "iconName": "assets/icons/Testimonial.png",
      "title": "Testimonials",
      "navigation": "/TestimonialsPage"
    },
    {
      "iconName": "assets/icons/Testimonial.png",
      "title": "Front Desk",
      "navigation": "/FDListPage"
    },
    {
      "iconName": "assets/icons/ManageDate.png",
      "title": "Today Token",
      "navigation": "/AllTokenListPage"
    },
    {
      "iconName": "assets/icons/wallet.png",
      "title": "Wallet",
      "navigation": "/UsersListWalletPage"
    },
    {
      "iconName": "assets/icons/youtube.png",
      "title": "Videos",
      "navigation": "/VideoListPage"
    },

    {
      "iconName": "assets/icons/pharmacy.png",
      "title": "Pharmacy",
      "navigation": "/ChoosePharmaCityListPage"
    },
    {
      "iconName": "assets/icons/pharmacy.png",
      "title": "Pharma Requests",
      "navigation": "/PharmaAllReqListPage"
    },
    {
      "iconName": "assets/icons/chemistry.png",
      "title": "Lab Attender",
      "navigation": "/LabCityListPage"
    },
    {
      "iconName": "assets/icons/chemistry.png",
      "title": "Lab Test",
      "navigation": "/LabTestCityListPage"
    },
    {
      "iconName": "assets/icons/chemistry.png",
      "title": "Lab Appointment",
      "navigation": "/LabTestAllAppListPage"
    },

  ];
@override
  void dispose() {
    // TODO: implement dispose
  _timer!.cancel();
    super.dispose();
  }

  NotificationServices services = NotificationServices();

  @override
  void initState() {

    // TODO: implement initState

    services.notificationSettings();
    services.GetDeviceToken().then((value) => {

      print('device token'),
      print(value),
      // Utils().toastmessage(value.toString()),
    }).onError((error, stackTrace) => {
      // Utils().toastmessage(error.toString()),
    });
    services.IsDeviceTokenRefresh();
    services.Firebaseinit(context);
    services.SetUpInteractMessage(context);


    HandleFirebaseNotification.handleNotifications(
        context); //initialize firebase messaging
    HandleLocalNotification.initializeFlutterNotification(
        context); //initialize local notification
    getKiosk();
    getAndSetData();
    super.initState();
  }

  getKiosk() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final isKioskMode = preferences.getBool("kioskmode");
    if (isKioskMode != null && isKioskMode == true) {
      Navigator.pushNamed(context, "/KioskHomePage");
    }
    // final res = await FirebaseMessaging.instance.getToken();
    // print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? LoadingIndicatorWidget()
          : Stack(
              children: [
                Positioned(
                    top: 0, left: 0, right: 0, child: _bottomCircularBox()),
                Positioned.fill(
                  child: _adminImageAndText(),
                ),

                Positioned(
                    top: 40,
                    right: CheckDeviceScreen().CheckDeviceScreenPT() ? 60 : 20,
                    child: SignOutBtnWidget()),
                Positioned(
                    top: CheckDeviceScreen().CheckDeviceScreenPT() ? 300 : 200,
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: CheckDeviceScreen().CheckDeviceScreenPT()
                        ? _buildGridViewTablet()
                        : _buildGridView())
              ],
            ),
    );
  }

  Widget _buildGridViewTablet() {
    return GridView.count(
      //  physics: ScrollPhysics(),
      controller: _gridScrollController,
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(_widgetsList.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, _widgetsList[index]["navigation"]);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgetsList[index]["title"] == "Notification"
                    ? _buildNotificationIconTablet(
                        _widgetsList[index]["iconName"])
                    : Positioned(
                        bottom: 80,
                        left: 80,
                        right: 80,
                        top: 80,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset(_widgetsList[index]["iconName"]),
                        ),
                      ),
                //   SizedBox(height: 20),
                Positioned(
                  bottom: 20,
                  left: 5,
                  right: 5,
                  child: Text(
                   " ${_widgetsList[index]["title"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OpenSans-Bold',
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGridView() {
    return GridView.count(
      //  physics: ScrollPhysics(),
      controller: _gridScrollController,
      shrinkWrap: true,
      crossAxisCount: 3,
      children: List.generate(_widgetsList.length, (index) {
        return GestureDetector(
          onTap: () async{
            Navigator.pushNamed(context, _widgetsList[index]["navigation"]);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgetsList[index]["title"] == "Notification"
                    ? _buildNotificationIcon(_widgetsList[index]["iconName"])
                    : SizedBox(
                        height: 50,
                        width: 50,
                        child:  _widgetsList[index]["title"]=="Enable Location"?
                            locationEnabled? Image.asset("assets/icons/power.png"):
                            Image.asset("assets/icons/power-off.png")
                            : Image.asset(_widgetsList[index]["iconName"]),
                      ),
                SizedBox(height: 20),
                _widgetsList[index]["title"]=="Enable Location"?
                locationEnabled?Text(
                  "Location \n Enable",
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 12.0,
                  )):
                  Text(
              "Location \n Disable",
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 12.0,
                  ),)
                  :Text(
                  "${_widgetsList[index]["title"]}",
                  style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _bottomCircularBox() {
    return Container(
      alignment: Alignment.center,
      child: ClipPath(
        clipper: ClipPathClass(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: CheckDeviceScreen().CheckDeviceScreenPT() ? 500 : 300,
          decoration: BoxDecoration(gradient: gradientColor),
        ),
      ),
    );
  }

  Widget _adminImageAndText() {
    return Column(
      children: [
        SizedBox(height: 60),
        userType == "doctor"
            ? doctProfile == ""
                ? Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/dr.png",
                            height: CheckDeviceScreen().CheckDeviceScreenPT()
                                ? 180
                                : 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height:
                        CheckDeviceScreen().CheckDeviceScreenPT() ? 200 : 100,
                    width:
                        CheckDeviceScreen().CheckDeviceScreenPT() ? 200 : 100,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(doctProfile),
                            fit: BoxFit.cover)),
                  )
            : userType == "frontdesk"
                ? fdImage == ""
                    ? Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icons/dr.png",
                                height:
                                    CheckDeviceScreen().CheckDeviceScreenPT()
                                        ? 180
                                        : 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 200
                            : 100,
                        width: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 200
                            : 100,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(fdImage),
                                fit: BoxFit.cover)),
                      ):
        userType == "pharma"
            ? pharmaImage == ""
            ? Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/icons/dr.png",
                  height: 80,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        )
            : Container(
          height: 100,
          width: 100,
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(pharmaImage),
                  fit: BoxFit.cover)),
        ):
        userType == "labattender"
            ? laImage == ""
            ? Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
             child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/dr.png",
                      height: 80,
                      fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        )
            : Container(
          height: 100,
          width: 100,
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(laImage),
                  fit: BoxFit.cover)),
                )
                : Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/dr.png",
                            height: CheckDeviceScreen().CheckDeviceScreenPT()
                                ? 180
                                : 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
        SizedBox(height: 10),
        userType == "doctor"
            ? Text(
                doctName,
                style: TextStyle(
                    fontFamily: 'OpenSans-Bold',
                    fontSize:
                        CheckDeviceScreen().CheckDeviceScreenPT() ? 26 : 20.0,
                    color: Colors.white),
              )
            : userType == "frontdesk"
                ? Text(
                    fdName,
                    style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
                            ? 26
                            : 20.0,
                        color: Colors.white),
                  )
            :userType=="pharma"? Text(
          pharmaName,
          style: TextStyle(
              fontFamily: 'OpenSans-Bold',
              fontSize: 20.0,
              color: Colors.white),
        ):       userType == "labattender"
            ? Text(
          laName,
          style: TextStyle(
              fontFamily: 'OpenSans-Bold',
              fontSize: 20.0,
              color: Colors.white),
        ) :
        Text(
          "Admin App",
          style: TextStyle(
            fontFamily: 'OpenSans-Bold',
            fontSize: CheckDeviceScreen().CheckDeviceScreenPT()
              ? 26
              : 20.0,
                color: Colors.white),
        )
      ],
    );
  }

  Widget _buildNotificationIconTablet(widgetName) {
    return StreamBuilder(
        stream: userType == "doctor"
            ? ReadData.fetchDoctorsNotificationDotStatus(doctId)
            : ReadData.fetchNotificationDotStatus(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? Positioned(
                  bottom: 80,
                  left: 80,
                  right: 80,
                  top: 80,
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset(widgetName),
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                      bottom: 80,
                      left: 80,
                      right: 80,
                      top: 80,
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: Image.asset(widgetName),
                      ),
                    ),
                    snapshot.data["isAnyNotification"]
                        ? Positioned(
                            top: 50,
                            right: 100,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.red,
                            ))
                        : Positioned(top: 0, right: 0, child: Container())
                  ],
                );
        });
  }

  Widget _buildNotificationIcon(widgetName) {
    return StreamBuilder(
        stream: userType == "doctor"
            ? ReadData.fetchDoctorsNotificationDotStatus(doctId.toString())
        : userType == "pharma"?ReadData.fetchPharmaNotificationDotStatus(pharmaId):
        userType == "labattender"?ReadData.fetchLabAttenderNotificationDotStatus(labAttenderId)
            : ReadData.fetchNotificationDotStatus(),
        builder: (context, AsyncSnapshot snapshot) {
          return !snapshot.hasData
              ? SizedBox(
                  height: 45,
                  width: 45,
                  child: Image.asset(widgetName),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: Image.asset(widgetName),
                    ),
                    // snapshot.data["isAnyNotification"]
                    //     ? Positioned(
                    //         top: 0,
                    //         right: 0,
                    //         child: CircleAvatar(
                    //           radius: 5,
                    //           backgroundColor: Colors.red,
                    //         ))
                    //     : Positioned(top: 0, right: 0, child: Container())
                  ],
                );
        });
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final type = preferences.getString("userType");
    if (type == "doctor") {
      setState(() {
        userType = type ?? "";
        doctId = preferences.getString("doctId") ?? "";
        doctName = preferences.getString('doctName') ?? "";
        doctProfile = preferences.getString('doctImage') ?? "";
        _widgetsList.clear();
        _widgetsList.add(
          {
            "iconName": "assets/icons/appointments.png",
            "title": "Appointments",
            "navigation": "/AppointmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Doctors.png",
            "title": "Profile",
            "navigation": "/EditProfilePage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Notifications.png",
            "title": "Notification",
            "navigation": "/NotificationListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/ManageDate.png",
            "title": "Manage Date",
            "navigation": "/AddDateToCloseBookingPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Users.png",
            "title": "Users",
            "navigation": "/UsersListPageNew"
          },
        );
      });


      // if(drData[0].!=null&&)
    }
    else if (type == "frontdesk") {
      setState(() {
        userType = type ?? "";
        fdName = preferences.getString('fdName') ?? "";
        fdImage = preferences.getString('fdImage') ?? "";

        _widgetsList.clear();
        _widgetsList.add(
          {
            "iconName": "assets/icons/appointments.png",
            "title": "Appointments",
            "navigation": "/AppointmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Notifications.png",
            "title": "Notification",
            "navigation": "/NotificationListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Services.png",
            "title": "Service",
            "navigation": "/ServicesPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Department.png",
            "title": "Department",
            "navigation": "/FDDepartmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Availability.png",
            "title": "Availability",
            "navigation": "/EditAvailabilityPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Doctors.png",
            "title": "Doctors",
            "navigation": "/ChooseFDDoctDepartmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Users.png",
            "title": "User",
            "navigation": "/UsersListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Walk-in.png",
            "title": "Walk-in",
            "navigation": "/WalkInUserListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/Kiosk.png",
            "title": "Kiosk",
            "navigation": "/KioskHomePage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/ManageDate.png",
            "title": "Manage Date",
            "navigation": "/ChooseManageDoctDepartmentListPage"
          },
        );
        _widgetsList.add(
          {
            "iconName": "assets/icons/ManageDate.png",
            "title": "Today Token",
            "navigation": "/AllTokenListPage"
          },
        );
        // _widgetsList.add(
        //   {
        //     "iconName": "assets/icons/ManageDate.png",
        //     "title": "Workers",
        //     "navigation": "/WorkerListPage"
        //   },
        // );


      });
    }
    else if(type=="pharma")
    {
      userType = type ?? "";
      pharmaId = preferences.getString("pharmaId") ?? "";
      pharmaImage = preferences.getString("pharmaImage") ?? "";
      pharmaName = preferences.getString("pharmaName") ?? "";
      _widgetsList.clear();
      _widgetsList.add(
        {
          "iconName": "assets/icons/appointments.png",
          "title": "Appointments",
          "navigation": "/PharmaReqListPage"
        },
      );
      _widgetsList.add(
        {
          "iconName": "assets/icons/Notifications.png",
          "title": "Notification",
          "navigation": "/NotificationListPage"
        },
      );
      _widgetsList.add(
        {
          "iconName": "assets/icons/Users.png",
          "title": "Profile",
          "navigation": "/EditPharmacyUserPage"
        },
      );

    }
    else if(type=="labattender")
    {
      userType = type ?? "";
      labAttenderId = preferences.getString("laId") ?? "";
      laImage = preferences.getString("laImage") ?? "";
      laName = preferences.getString("laName") ?? "";
      _widgetsList.clear();


      //  );
      _widgetsList.add(
        {
          "iconName": "assets/icons/Notifications.png",
          "title": "Notification",
          "navigation": "/NotificationListPage"
        },
      );
      _widgetsList.add(
        {
          "iconName": "assets/icons/Users.png",
          "title": "Profile",
          "navigation": "/EditLabUserPage"
        },
      );
      _widgetsList.add(
        {
          "iconName": "assets/icons/appointments.png",
          "title": "Appointments",
          "navigation": "/LabTestAppListPage"
        },
      );


    }
    setState(() {
      _isLoading = false;
    });
  }

}
