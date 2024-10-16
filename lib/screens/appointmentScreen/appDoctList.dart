import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/screens/appointmentScreen/appApplointmentPage.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';

class ChooseDoctorsPage extends StatefulWidget {
  final deptId;
  final deptName;
  final clinicId;
  final clinicName;
  final cityId;
  final cityName;
  final clinicLocationName;
  final userModel;
  ChooseDoctorsPage(
      {this.deptId,
      this.deptName,
      this.clinicId,
      this.clinicName,
      this.clinicLocationName,
      this.cityName,
      this.cityId,
      this.userModel});
  @override
  _ChooseDoctorsPageState createState() => _ChooseDoctorsPageState();
}

class _ChooseDoctorsPageState extends State<ChooseDoctorsPage> {
  bool _isLoading=true;
  List<DrProfileModel>drList=[];

  @override
  void initState() {
    // TODO: implement initState
    getAndSetData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.deptName),
      body: _isLoading?LoadingIndicatorWidget():
      drList.length==0?NoDataWidget():
      _buildContent(drList),
    );
  }

  _buildContent(listDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .6,
        crossAxisCount: 2,
        children: List.generate(listDetails.length, (index) {
          return _cardImg(listDetails[
              index]); //send type details and index with increment one
        }),
      ),
    );
  }

  _cardImg(listDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppAppointmentPage(
              dayCode: listDetails.dayCode,
              serviceTime: listDetails.serviceTime,
              cclt: listDetails.clt,
              copt: listDetails.opt,
              doctId: listDetails.id,
              lunchCloTime: listDetails.lunchClosingTime,
              lunchOpTime: listDetails.lunchOpeningTime,
              closingDate: listDetails.closingDate,
              deptName: widget.deptName,
              hospitalName: listDetails.hName,
              doctName: listDetails.firstName + " " + listDetails.lastName,
              stopBooking: listDetails.stopBooking,
              fee: listDetails.fee,
              clinicId: widget.clinicId,
              cityId: widget.cityId,
              deptId: widget.deptId,
              cityName: widget.cityName,
              clinicName: widget.clinicName,
              userModel: widget.userModel,
                payLaterActive: listDetails.payLater,
                payNowActive: listDetails.payNow,
                videoActive: listDetails.video_active,
                walkinActive: listDetails.walkin_active,
                vspd: listDetails.vspd,
                wspd: listDetails.wspdp
            ),
          ),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 90,
                  child: listDetails.profileImageUrl == "" ||
                          listDetails.profileImageUrl == null
                      ? Icon(Icons.image)
                      : ImageBoxFillWidget(
                          imageUrl: listDetails.profileImageUrl)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 90,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listDetails.firstName +
                                " " +
                                listDetails.lastName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                          ),
                          Text(
                            listDetails.hName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          )),
    );
  }

  void getAndSetData()async {
    setState(() {
      _isLoading=true;
    });
    final getDrList=await DrProfileService.getDataById(widget.deptId, widget.clinicId,
        widget.cityId);
    if(getDrList.isNotEmpty){
      for(int i=0;i<getDrList.length;i++){
        if(getDrList[i].active=="1"){
          setState(() {
            drList.add(getDrList[i]);
          });
        }
      }
    }
    setState(() {
      _isLoading=false;
    });

  }
}
