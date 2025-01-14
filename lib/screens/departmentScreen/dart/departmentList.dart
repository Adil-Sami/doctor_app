import 'package:demoadmin/screens/departmentScreen/dart/addDepartment.dart';
import 'package:demoadmin/screens/departmentScreen/dart/editDepartment.dart';
import 'package:demoadmin/service/departmentService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class DepartmentListPage extends StatefulWidget {
  final cityId;
  final clinicId;
  DepartmentListPage({this.cityId, this.clinicId});
  @override
  _DepartmentListPageState createState() => _DepartmentListPageState();
}

class _DepartmentListPageState extends State<DepartmentListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "All Department"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add New",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDepartmentPage(
                cityId: widget.cityId,
                clinicId: widget.clinicId,
              ),
            ),
          );
        },
        isEnableBtn: true,
      ),
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
            builder: (context) => EditDepartmentPage(
              dataDetails: listDetails,
              clinicId: widget.clinicId,
              cityId: widget.cityId,
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
