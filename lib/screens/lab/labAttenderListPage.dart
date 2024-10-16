import 'package:demoadmin/screens/lab/addLatAttender.dart';
import 'package:demoadmin/screens/lab/updateLabAttenderPage.dart';
import 'package:demoadmin/service/labattenderService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class LabAttenderListPage extends StatefulWidget {
  final clinicId;
  final clinicName;
  LabAttenderListPage({this.clinicId, this.clinicName});
  @override
  _LabAttenderListPageState createState() => _LabAttenderListPageState();
}

class _LabAttenderListPageState extends State<LabAttenderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add New",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLabAttenderPage(
                clinicName: widget.clinicName,
                clinicID: widget.clinicId,
              ),
            ),
          );
        },
        isEnableBtn: true,
      ),
      appBar: IAppBars.commonAppBar(context, widget.clinicName),
      body: FutureBuilder(
          future:
          LabAttenderService.getData(widget.clinicId), //fetch images form database
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
    return ListView.builder(
        itemCount: listDetails.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _cardImg(listDetails[index]);
        });
  }

  _cardImg(listDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditLabAttenderPage(
              dataDetails: listDetails,
              clinicId: widget.clinicId,
            ),
          ),
        );
      },
      child: Card(
        elevation: .5,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:ListTile(
              isThreeLine: true,
              // minLeadingWidth : 10,
              leading:
              Container(
                  width: 80,
                  child:
                  listDetails.imageUrl == "" || listDetails.imageUrl == null
                      ? Icon(Icons.image)
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageBoxFillWidget(
                          imageUrl: listDetails.imageUrl)
                  )
              ),
              title:    Text(
                listDetails.name,
                style: TextStyle(
                    fontSize: 14, fontFamily: "OpenSans-SemiBold"),
              ),
              subtitle:
            Text(
              listDetails.subTitle,
              style: TextStyle(
                  fontSize: 14, fontFamily: "OpenSans-SemiBold"),
            ),
            )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //
          //     SizedBox(width: 10),
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Text(
          //           listDetails.title,
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //               fontSize: 14, fontFamily: "OpenSans-SemiBold"),
          //         ),
          //         Text(
          //           listDetails.locationName,
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //               fontSize: 14, fontFamily: "OpenSans-SemiBold"),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ),
      ),
      // child: Card(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(10.0),
      //     ),
      //     child: Stack(
      //       children: [
      //         Positioned(
      //             top: 0,
      //             left: 0,
      //             right: 0,
      //             bottom: 45,
      //             child: ImageBoxFillWidget(imageUrl: listDetails.imageUrl)),
      //         Positioned(
      //             bottom: 0,
      //             left: 0,
      //             right: 0,
      //             child: Container(
      //               height: 45,
      //               child: Center(
      //                 child: Text(
      //                   listDetails.title,
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                       fontSize: 14, fontFamily: "OpenSans-SemiBold"),
      //                 ),
      //               ),
      //             )),
      //       ],
      //     )),
    );
  }
}
