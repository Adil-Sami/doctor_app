import 'package:demoadmin/screens/pharmacy/pharmacyListPage.dart';
import 'package:demoadmin/service/cityService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/imageWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class ChoosePharmaCityListPage extends StatefulWidget {
  @override
  _ChoosePharmaCityListPageState createState() => _ChoosePharmaCityListPageState();
}

class _ChoosePharmaCityListPageState extends State<ChoosePharmaCityListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Cities"),
      body: FutureBuilder(
          future: CityService.getData(), //fetch images form database
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
            builder: (context) => PharmacyListPage(
              cityId: listDetails.id,
              cityName: listDetails.title,
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
                        listDetails.title,
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