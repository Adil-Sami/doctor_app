
import 'package:demoadmin/screens/labTest/labTestAppDetailsPage.dart';
import 'package:demoadmin/service/labTestApppService.dart';
import 'package:demoadmin/service/pdfs/pdfLabTest.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LabTestAppListPage extends StatefulWidget {
  @override
  _LabTestAppListPageState createState() => _LabTestAppListPageState();
}

class _LabTestAppListPageState extends State<LabTestAppListPage> {
  final ScrollController _scrollController = new ScrollController();
  bool _isLoading=false;
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: appBarColor,
            onPressed: () {
              generatePdf();
            },
            child:  Icon(Icons.picture_as_pdf,size: 30,),),
        ),
      ),
      appBar: IAppBars.commonAppBar(context, "Lab Test Appointments"),
      // bottomNavigationBar:
      // BottomNavigationWidget(route: "/CityListPharmaPage", title: "New Request"),
      body:_isLoading?LoadingIndicatorWidget(): FutureBuilder(
          future: LabTestAppService.getData(),
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
                    builder: (context) => LabTestAppDetailsPage(
                      foAdmin: false,
                        appointmentDetails:prescriptionDetails[index] ),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prescriptionDetails[index].subTitle,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 14.0,
                          )),
                      Row(
                        children: [
                          Text("Status: ",  style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 14.0,
                          )),
                          Text(prescriptionDetails[index].status=="0"?
                          "Pending":prescriptionDetails[index].status=="1"?"Confirmed":
                          prescriptionDetails[index].status=="2"?"Visited": prescriptionDetails[index].status=="3"?"Canceled":"Not Updated",
                              style: TextStyle(
                                fontFamily: 'OpenSans-Bold',
                                fontSize: 14.0,
                              )
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.circle,size: 13,color: prescriptionDetails[index].status=="0"?
                          Colors.yellowAccent:prescriptionDetails[index].status=="1"?Colors.orange:
                          prescriptionDetails[index].status=="2"? Colors.green:prescriptionDetails[index].status=="3"?Colors.red:Colors.white,)
                        ],
                      ),
                      Text("Date: "+prescriptionDetails[index].createdTimeStamp,
                          style: TextStyle(
                            fontFamily: 'OpenSans-Bold',
                            fontSize: 14.0,
                          )),
                    ],
                  ),
                  title: Text(prescriptionDetails[index].testName,
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
  void generatePdf() async {
    setState(() {
      _isLoading=true;
    });

    var status = await Permission.storage.request();

    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else if (status.isGranted) {
      final getLabList= await LabTestAppService.getData();
      final pdfFile = await TestReportApiPdf.generateTable(getLabList);

      TestReportApiPdf.openFile(pdfFile);

    }
    setState(() {
      _isLoading=false;
    });
    //
  }
}