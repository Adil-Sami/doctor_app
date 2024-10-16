import 'package:demoadmin/model/drProfielModel.dart';
import 'package:demoadmin/model/token_model.dart';
import 'package:demoadmin/service/appointmentService.dart';
import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
class AllTokenListPage extends StatefulWidget {
  const AllTokenListPage({Key? key}) : super(key: key);

  @override
  State<AllTokenListPage> createState() => _AllTokenListPageState();
}

class _AllTokenListPageState extends State<AllTokenListPage> {
  ScrollController _scrollController=ScrollController();
  DateTime dateTime=DateTime.now();
  String date="";
  bool _isLoading=false;
  List<DrProfileModel> drList=[];
  String? selectedDoctId;
  @override
  void initState() {
    date="${dateTime.year}-${dateTime.month}-${dateTime.day}";
    // TODO: implement initState
    getAndSetData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "Today Token $date"),
        body: _isLoading?LoadingIndicatorWidget():ListView(
          controller: _scrollController,
          children: [
            _doctorListDropDown(),
            FutureBuilder(
                future: AppointmentService.getAllTokenByDate(date,selectedDoctId??""), // fetch all images form the database
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return snapshot.data.length == 0
                        ? NoDataWidget()
                        : _buildListView(snapshot.data);
                  else if (snapshot.hasError)
                    return IErrorWidget(); //if any error then you can also use any other widget here
                  else
                    return LoadingIndicatorWidget();
                }),
          ],
        ));
  }

  _buildListView(dataList) {
    return ListView.builder(
      controller: _scrollController,
        itemCount: dataList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          TokenModel tokenModel=dataList[index];
      return Card(
          child: ListTile(
            isThreeLine: true,
              title: Text("Token Number: ${tokenModel.tokenNum}",
              style: TextStyle(
                fontFamily: "OpenSans-SemiBold",
              ),),
            subtitle:Column(
              children: [
                Row(
                  children: [
                    Text("Status: ${tokenModel.completed=="1"?"Visited":"Not Visited"}",
                      style: TextStyle(
                        fontFamily: "OpenSans-SemiBold",
                      ),),
                    SizedBox(width: 5),
                    CircleAvatar(
                        radius: 5,
                        backgroundColor:   tokenModel.completed=="1"? Colors.green:Colors.yellow)
                  ],
                ),

                Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: Center(
                            child: Text("Visited",
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                        onPressed:tokenModel.completed=="1"?null: (){
                          handleUpdate(tokenModel.tokenId,"1");
                        }),
                    SizedBox(width: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: Center(
                            child: Text("Not Visited",
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                        onPressed: tokenModel.completed=="0"?null:(){
                          handleUpdate(tokenModel.tokenId,"0");
                        })
                  ],
                ),
              ],
            ) ,

          ));
    });
  }
  _doctorListDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.only(left: 8,right: 8),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text("Select Doctor"),
            focusColor: Colors.white,
            value: selectedDoctId,
            style: TextStyle(color: Colors.black),
            iconEnabledColor: btnColor,
            items: drList.map(( itemss) {
              return DropdownMenuItem(
                value: itemss.id,
                child: Text(itemss.firstName  + itemss.lastName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDoctId = value.toString();

              });
            },
          ),
        ),
      ),
    );
  }
  handleUpdate(tokenId,status)async{
    setState(() {
      _isLoading=true;
    });
    final getRes=await AppointmentService.updateTokenStatusData(tokenId,status);
    if(getRes=="success")
      ToastMsg.showToastMsg("Success");
    else ToastMsg.showToastMsg("Something went wrong");
    setState(() {
      _isLoading=false;
    });


  }

  void getAndSetData() async{
    setState(() {
      _isLoading=true;
    });
    final res=await DrProfileService.getDoctors();
    for(int i=0;i<res.length;i++){
      if(res[i].active=="1"){ 
        setState(() {
          drList.add(res[i]);
        });
      }
    }
    setState(() {
      _isLoading=false;
    });
  }
}
