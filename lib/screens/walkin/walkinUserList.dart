import 'package:demoadmin/screens/userScreen/registerNewUserPage.dart';
import 'package:demoadmin/screens/walkin/walkinDepartment.dart';
import 'package:demoadmin/screens/walkin/walkinEditUser.dart';
import 'package:demoadmin/service/clinicService.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/inputField.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/bottomNavigationBarWidget.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkInUserListPage extends StatefulWidget {
  @override
  _WalkInUserListPageState createState() => _WalkInUserListPageState();
}

class _WalkInUserListPageState extends State<WalkInUserListPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Widget build(BuildContext context) {
    bool _isEnableBtn = true;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              openWalkinApp();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => RegisterNewUsersForAdminPage()),
              // );
            },
          ),
          backgroundColor: btnColor,
          onPressed: () {}),
      appBar: IAppBars.commonAppBar(context, "Walk-in users"),
      bottomNavigationBar: BottomNavTwoBarWidget(
        firstBtnOnPressed: _handleByNameBtn,
        firstTitle: "Search By Name",
        isenableBtn: _isEnableBtn,
        secondBtnOnPressed: _handleByIdBtn,
        secondTitle: "Search By ID",
      ),
      body: FutureBuilder(
          future: UserService.getData(),
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
    Navigator.pushNamed(context, "/SearchWalkinUserByNamePage");
  }

  _handleByIdBtn() {
    Navigator.pushNamed(context, "/SearchWalkinUserByIdPage");
  }

  Widget _buildUserList(userList) {
    return ListView.builder(
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
                          builder: (context) => WalkInEditUserProfilePage(
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
                        Text("Created at ${userList[index].createdTimeStamp}"),
                    //  isThreeLine: true,
                  ),
                ),
                Divider()
              ],
            ),
          );
        });
  }

  openWalkinApp() {
    bool isLoading = false;
    TextEditingController passCont = TextEditingController();
    //passCont.text="8889990643";
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
          key: _formKey,
          child: StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: new Text("Walk-in Token"),
                content: isLoading
                    ? Container(height: 100, child: LoadingIndicatorWidget())
                    : InputFields.intInputFormField(
                        context, 'Enter Phone Number', passCont, (item) {
                        return item.length == 0 ? "Enter Number" : null;
                      }),
                actions: isLoading
                    ? null
                    : <Widget>[
                        new ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: new Text("Continue"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                final getUserDetails =
                                    await UserService.getDataByPhn(
                                        passCont.text);
                                if (getUserDetails.length == 0) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterNewUsersPage(
                                              phn: passCont.text),
                                    ),
                                  );
                                }
                                //     ToastMsg.showToastMsg("No user found");
                                else if (getUserDetails.length > 0) {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  final clinicId =
                                      preferences.getString("fdClinicId");
                                  final getClinicData =
                                      await ClinicService.getDataByClinicId(
                                          clinicId ?? "");
                                  if (getClinicData.isNotEmpty) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WalkinDepartmentPage(
                                                userModel: getUserDetails[0],
                                                clinicId: getClinicData[0]
                                                    .id
                                                    .toString(),
                                                cityId: getClinicData[0]
                                                    .cityId
                                                    .toString(),
                                                cityName:
                                                    getClinicData[0].cityName,
                                                clinicLocationName:
                                                    getClinicData[0]
                                                        .locationName,
                                                clinicName:
                                                    getClinicData[0].title),
                                      ),
                                    );
                                  } else
                                    ToastMsg.showToastMsg(
                                        "Something went wrong");
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                //   Navigator.of(context).pop();
                              }
                              // onPressed();
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                            child: new Text("Cancel"),
                            onPressed: () async {
                              Navigator.of(context).pop();

                              // onPressed();
                            }),
                        // usually buttons at the bottom of the dialog
                      ],
              ),
            );
          }),
        );
      },
    );
  }
}
