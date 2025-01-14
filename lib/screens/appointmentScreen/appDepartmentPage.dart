import 'package:demoadmin/screens/appointmentScreen/appDoctList.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/Service/departmentService.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';

class AppChooseDepartmentPage extends StatefulWidget {
  final clinicId;
  final clinicName;
  final cityName;
  final cityId;
  final clinicLocationName;
  final userModel;
  AppChooseDepartmentPage(
      {this.clinicId,
      this.clinicName,
      this.clinicLocationName,
      this.cityId,
      this.cityName,
      this.userModel});
  @override
  _AppChooseDepartmentPageState createState() =>
      _AppChooseDepartmentPageState();
}

class _AppChooseDepartmentPageState extends State<AppChooseDepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.clinicName),
      body: FutureBuilder(
          future: DepartmentService.getData(
              widget.clinicId, widget.cityId), //fetch images form database
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildContent(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  _buildContent(listDetails) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: GridView.count(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        childAspectRatio: .9,
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
            builder: (context) => ChooseDoctorsPage(
                cityName: widget.cityName,
                cityId: widget.cityId,
                clinicLocationName: widget.clinicLocationName,
                clinicId: widget.clinicId,
                clinicName: widget.clinicName,
                deptId: listDetails.id,
                deptName: listDetails.name,
                userModel: widget.userModel),
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
                  bottom: 45,
                  child:
                      listDetails.imageUrl == "" || listDetails.imageUrl == null
                          ? Icon(Icons.image)
                          : ImageBoxFillWidget(imageUrl: listDetails.imageUrl)),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 45,
                    child: Center(
                      child: Text(
                        listDetails.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
