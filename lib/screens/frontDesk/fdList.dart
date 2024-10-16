
import 'package:demoadmin/screens/frontDesk/addFDPage.dart';
import 'package:demoadmin/screens/frontDesk/update_front_desk.dart';

import 'package:demoadmin/service/fdService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class FDListPage extends StatefulWidget {
  @override
  _FDListPageState createState() => _FDListPageState();
}

class _FDListPageState extends State<FDListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add New",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFDPage(),
            ),
          );
        },
        isEnableBtn: true,
      ),
      appBar: IAppBars.commonAppBar(context, "Front Desk"),
      body: FutureBuilder(
          future: FdService.getData(), //fetch images form database
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
            builder: (context) => UpdateFDPage(
              dataDetails: listDetails,
            ),
          ),
        );
      },
      child: Card(
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child:
                      listDetails.imageUrl == "" || listDetails.imageUrl == null
                          ? Icon(Icons.image)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ImageBoxFillWidget(
                                  imageUrl: listDetails.imageUrl))),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    listDetails.firstName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                  ),
                  Text(
                    listDetails.lastName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontFamily: "OpenSans-SemiBold"),
                  ),
                ],
              )
            ],
          ),
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
