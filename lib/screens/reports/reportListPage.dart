
import 'package:demoadmin/screens/reports/addReports.dart';
import 'package:demoadmin/screens/reports/updateReportsPage.dart';
import 'package:demoadmin/service/reporstService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  final userID;
  final userName;
  ReportListPage({this.userID,this.userName});
  @override
  _ReportListPageeState createState() => _ReportListPageeState();
}

class _ReportListPageeState extends State<ReportListPage> {
  final ScrollController _scrollController = new ScrollController();
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, widget.userName),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add Report",
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddReportPage(
                    uid: widget.userID,
                ),
              )
          );
        },
        isEnableBtn: true,
      ),
      body:  FutureBuilder(
          future: ReportService.getData(widget.userID),
          //ReadData.fetchNotification(FirebaseAuth.instance.currentUser.uid),//fetch all times
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 8, right: 8),
                  child: _buildCard(snapshot.data));
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  Widget _buildCard(prescriptionDetails) {
    // _itemLength=notificationDetails.length;
    return ListView.builder(
        controller: _scrollController,
        itemCount: prescriptionDetails.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateReportPage(
                      uid: widget.userID,
                        reportModel:prescriptionDetails[index] ),
                  )
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(prescriptionDetails[index].title,
                      style: TextStyle(
                        fontFamily: 'OpenSans-Bold',
                        fontSize: 14.0,
                      )),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: iconsColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
