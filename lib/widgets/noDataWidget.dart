import 'package:demoadmin/utilities/checkScreenAdap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child:
                //Container(color: Colors.red,)
                SvgPicture.asset("assets/icons/nodata.svg",
                    semanticsLabel: 'Acme Logo'),
          ),
          SizedBox(height: 20),
          Text("No Data Found!",
              style: TextStyle(
                fontFamily: 'OpenSans-SemiBold',
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

class CalDateWidget extends StatelessWidget {
  final selectedDate;
  CalDateWidget({this.selectedDate});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: CheckDeviceScreen().CheckDeviceScreenPT() ? 400 : 250,
            width: CheckDeviceScreen().CheckDeviceScreenPT() ? 400 : 250,
            child:
                //Container(color: Colors.red,)
                SvgPicture.asset("assets/icons/booking.svg",
                    semanticsLabel: 'Acme Logo'),
          ),
          SizedBox(height: 20),
          Text("Appointment Date : ${this.selectedDate}",
              style: TextStyle(
                fontFamily: 'OpenSans-SemiBold',
                fontSize: CheckDeviceScreen().CheckDeviceScreenPT() ? 20 : 14,
              )),
        ],
      ),
    );
  }
}

class NoDoctorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child:
                //Container(color: Colors.red,)
                SvgPicture.asset("assets/icons/nodata.svg",
                    semanticsLabel: 'Acme Logo'),
          ),
          SizedBox(height: 20),
          Text("No Doctors available for Walk-in appointment!",
              style: TextStyle(
                fontFamily: 'OpenSans-SemiBold',
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

class NoBookingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child:
                //Container(color: Colors.red,)
                SvgPicture.asset("assets/icons/booking.svg",
                    semanticsLabel: 'Acme Logo'),
          ),
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
                "There is no anointment Found! please press book an appointment button and make a new appointment",
                style: TextStyle(
                  fontFamily: 'OpenSans-SemiBold',
                  fontSize: 14,
                )),
          ),
        ],
      ),
    );
  }
}
