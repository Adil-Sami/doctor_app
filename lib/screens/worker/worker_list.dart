import 'package:demoadmin/screens/userScreen/editUserProfilePage.dart';
import 'package:demoadmin/screens/userScreen/resgisterNewsUserForAdmin.dart';
import 'package:demoadmin/screens/worker/update_worker.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/service/workerService.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerListPage extends StatefulWidget {

  @override
  _WorkerListPageState createState() => _WorkerListPageState();
}

class _WorkerListPageState extends State<WorkerListPage> {
  String clinicId="";
  @override
  void initState() {
    // TODO: implement initState
    setFDId();
    super.initState();
  }
  Widget build(BuildContext context) {
    bool _isEnableBtn = true;
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, "Workers"),
      bottomNavigationBar: BottomNavBarWidget(
        title: "Add Worker",
        onPressed: () {
          Navigator.pushNamed(context, "/AddNewWorkerPage");
        },
        isEnableBtn: true,
      ),
      body: FutureBuilder(
          future: WorkerService.getData(clinicId),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData)
              return snapshot.data.length == 0
                  ? NoDataWidget()
                  : _buildUserList(snapshot.data);
            else if (snapshot.hasError)
              return IErrorWidget(); //if any error then you can also use any other widget here
            else
              return LoadingIndicatorWidget();
          }),
    );
  }

  _handleByNameBtn() {
    Navigator.pushNamed(context, "/SearchUserByNamePage");
  }

  Widget _buildUserList(userList) {
    return ListView.builder(
      padding: EdgeInsets.only(top:10),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateWorkerPage(
                              userDetails: userList[index])),
                    );
                  },
                  child: ListTile(
                    trailing: Icon(
                      Icons.arrow_right,
                      color: primaryColor,
                    ),

                    leading: CircularUserImageWidget(userList: userList[index]),
                    title: Text(
                        "${userList[index].firstName} ${userList[index].lastName}"),
                    //         DateFormat _dateFormat = DateFormat('y-MM-d');
                    // String formattedDate =  _dateFormat.format(dateTime);
                    subtitle:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone ${userList[index].phone}"),
                        Text("Created at ${userList[index].createdTimeStamp}"),
                      ],
                    ),
                    //  isThreeLine: true,
                  ),
                ),
                Divider()
              ],
            ),
          );
        });
  }
  void setFDId() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState((){
      clinicId= preferences.getString("fdClinicId")??"";
    });

  }
}
