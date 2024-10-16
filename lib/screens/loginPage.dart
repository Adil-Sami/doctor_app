import 'package:demoadmin/service/drProfileService.dart';
import 'package:demoadmin/service/fdService.dart';
import 'package:demoadmin/service/labattenderService.dart';
import 'package:demoadmin/service/pharmaService.dart';
import 'package:demoadmin/service/sendMailService.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/service/authService/authService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isEmailVerificationSend = false;
  // bool _passEmailSending=false;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int loginType = 0;
  bool logInLoading = false;
  String userType = "";
  String doctId = "";
  String fdId = "";
  String pharmaId = "";
  String labAttenderID = "";
  @override
  void initState() {
    _userIdController.text="";
    _passwordController.text="";
    // TODO: implement initState


    checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: logInLoading
          ? LoadingIndicatorWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF01beb2),
                  Color(0xFF04A99E),
                ],
              )),
              child: Center(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _adminImage(),
                    Text(
                      "Admin App",
                      style: TextStyle(
                          fontFamily: 'OpenSans-Bold',
                          fontSize: 20.0,
                          color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   "Login as",
                        //   style: TextStyle(color: Colors.white),
                        // ),
                        Radio(
                          activeColor: Colors.white,
                          value: 0,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: 1,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Doctor",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: 2,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Front Desk",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.white,
                          value: 3,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Pharmacy",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                        Radio(
                          activeColor: Colors.white,
                          value: 4,
                          groupValue: loginType,
                          onChanged: (int? value) {
                            setState(() {
                              loginType = value!;
                            });
                          },
                        ),
                        Text(
                          "Lab Attender",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "OpenSans-SemiBold"),
                        ),
                      ],
                    ),
                    _cardContent(),
                    _isLoading ? Container() : passwordResetBtn(),
                    Text("${"Demo Admin Id:"} admin@gmail.com \n ${"Password:"} 123456",
                    style: TextStyle(color: Colors.white,fontSize: 16),),
                    SizedBox(height: 10),
                    Text("${"Doctor Id:"} doctor@gmail.com \n ${"Password:"}: 12345678Aa@",
                      style: TextStyle(color: Colors.white,fontSize: 16),),
                    SizedBox(height: 10),
                    Text("${"Front Desk Id:"} frontdesk@gmail.com \n ${"Password:"}: 12345678Aa@",
                      style: TextStyle(color: Colors.white,fontSize: 16),),
                    // SizedBox(height: 10),
                    // Text("${"Pharmacy Id:"} pharmacy@gmail.com \n ${"Password:"}: 12345678Aa@",
                    //   style: TextStyle(color: Colors.white,fontSize: 16),),
                    // SizedBox(height: 10),
                    // Text("${"Lab Attender Id:"} labattender@gmail.com \n Password: 12345678Aa@",
                    //   style: TextStyle(color: Colors.white,fontSize: 16),),

                  ],
                ),
              ))),
    );
  }

  Widget passwordResetBtn() {
    return TextButton(
        onPressed: _isEmailVerificationSend
            ? null
            : () async {
                if (loginType == 1) {
                  if (_userIdController.text == "") {
                    ToastMsg.showToastMsg("please enter email address");
                  } else {
                    setState(() {
                      _isLoading = true;
                    });
                    final res =
                        await DrProfileService.getPass(_userIdController.text);
                    if (res == "error") {
                      ToastMsg.showToastMsg("Something went wrong");
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      if (res.length > 0) {
                        final mailRes = await SMTPService.sentMail(
                            _userIdController.text, res[0]['pass']);
                        if (mailRes == "success") {
                          ToastMsg.showToastMsg(
                              "${"password has been sent to"} ${_userIdController.text}");
                          setState(() {
                            _isLoading = false;
                          });
                        } else {
                          ToastMsg.showToastMsg("Something went wrong");
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        ToastMsg.showToastMsg("please enter a correct mail");
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  }
                }
                else if (loginType == 0) {
                  if (_userIdController.text.contains("@")) {
                    setState(() {
                      _isEmailVerificationSend = true;
                    });
                    ToastMsg.showToastMsg("Sending");
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _userIdController.text)
                          .then((value) {
                        setState(() {
                          _isEmailVerificationSend = false;
                          ToastMsg.showToastMsg(
                              "${"verification link has been sent to"} ${_userIdController.text} ");
                        });
                      });
                    } on FirebaseAuthException catch (e) {
                      ToastMsg.showToastMsg("${e.message}");
                      setState(() {
                        _isEmailVerificationSend = false;
                      });
                    }
                  } else
                    ToastMsg.showToastMsg("Enter a valid email");
                }
              },
        child: Text("Forget or Reset Password",
            style: TextStyle(
              fontSize: 14,
              decoration: TextDecoration.underline,
              color: Colors.white,
            )));
  }

  Widget _userIdField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        controller: _userIdController,
        validator: (item) {
          Pattern pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = new RegExp(pattern.toString());
          if (!regex.hasMatch(item!) || item == "null")
            return 'Enter a valid email address';
          else
            return null;
          // return item.contains('@') ? null : "Enter correct email";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
            ),
            labelText: "User Id",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: TextFormField(
        cursorColor: primaryColor,
        obscureText: true,
        controller: _passwordController,
        validator: (item) {
          return item!.length > 0 ? null : "Enter password";
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            labelText: "Password",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
            )),
      ),
    );
  }

  Widget _adminImage() {
    return SizedBox(
      height: 120,
      width: 120,
      child: ClipOval(
        child: Image.asset(
          "assets/icons/dr.png",
        ),
      ),
    );
  }

  Widget _cardContent() {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 250,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _userIdField(),
                _passwordField(),
                _isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingIndicatorWidget(),
                      )
                    : _loginBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginBtn() {
    return LoginButtonsWidget(
      onPressed: _handleLogIn,
      title: "Login",
    );
  }

  void _handleLogIn() async {
    print(loginType);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (loginType == 0) {
        final res = await AuthService.signIn(
            _userIdController.text, _passwordController.text);
        if (res) {
          //    final FirebaseAuth auth = FirebaseAuth.instance;
          await setData();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userType", "admin");
          userType = "admin";
          prefs.setBool("isLoggedIn", true);
          Navigator.of(context).pushReplacementNamed("/HomePage");
          ToastMsg.showToastMsg("Logged in");
        } else {
          ToastMsg.showToastMsg("Smoothing went wrong");
        }
        setState(() {
          _isLoading = false;
        });
      } else if (loginType == 1) {
        _handlePhpLogin();
      } else if (loginType == 2) {
        _handleFDPhpLogin();
      }
      else if(loginType==3){
        _handlePhpPharmacyLogin();
      }
      else if(loginType==4){
        _handlePhpLabAttenderLogin();
      }
    }
  }
  void _handlePhpPharmacyLogin() async {
    final res = await PharmacyService.getCredential(
        _userIdController.text, _passwordController.text);
    //  print(res);
    if (res.length == 0) {
      ToastMsg.showToastMsg("Wrong id or password");
      setState(() {
        _isLoading = false;
      });
    } else if (res.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userType", "pharma");
      userType = "pharma";
      pharmaId = res[0].id;
      prefs.setString("pharmaName", res[0].title);
      prefs.setString("pharmaImage", res[0].imageUrl);

      prefs.setString("pharmaId", res[0].id);
      prefs.setBool("isLoggedIn", true);
      await setData();
      Navigator.of(context).pushReplacementNamed("/HomePage");
      ToastMsg.showToastMsg("Logged in");
    }
  }
  void _handlePhpLabAttenderLogin() async {
    final res = await LabAttenderService.getCredential(
        _userIdController.text, _passwordController.text);
    //  print(res);
    if (res.length == 0) {
      ToastMsg.showToastMsg("Wrong id or password");
      setState(() {
        _isLoading = false;
      });
    } else if (res.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userType", "labattender");
      userType = "labattender";
      labAttenderID = res[0].id.toString();
      prefs.setString("laName", res[0].name);
      prefs.setString("laImage", res[0].imageUrl);
      prefs.setString("laId", res[0].id);
      prefs.setString("lacId", res[0].clinicID.toString());
      prefs.setBool("isLoggedIn", true);
      await setData();
      Navigator.of(context).pushReplacementNamed("/HomePage");
      ToastMsg.showToastMsg("Logged in");
    }
  }

  setData() async {
    String fcm = "";

    try {
      fcm = await FirebaseMessaging.instance.getToken() ?? "";
      if (userType == "admin")
        await DrProfileService.updateFcmId(fcm);
      else if (userType == "doctor")
        await DrProfileService.updateDoctFcmId(fcm, doctId);
      else if (userType == "frontdesk")
        await FdService.updateFDFcmId(fcm, fdId);
      else if (userType == "pharma")
        await PharmacyService.updateFcmId(fcm, pharmaId);
      else if (userType == "labattender")
        await LabAttenderService.updateFcmId(fcm, labAttenderID);
    } catch (e) {
      print(e);
    }
  }

  void _handleFDPhpLogin() async {
    final res = await FdService.getCredential(
        _userIdController.text, _passwordController.text);
    if (res != "null") {
      if (res.length == 0) {
        ToastMsg.showToastMsg("Wrong id or password");
        setState(() {
          _isLoading = false;
        });
      } else if (res.length > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userType", "frontdesk");
        userType = "frontdesk";
        fdId = res[0].id;
        prefs.setString("fdName", res[0].firstName + " " + res[0].lastName);
        prefs.setString("fdImage", res[0].imageUrl);
        prefs.setString("fdId", res[0].id);
        prefs.setString("fdClinicId", res[0].clinicId.toString());
        prefs.setString("fclinicName", res[0].clinicName);
        prefs.setString("fclinicLName", res[0].lName);
        prefs.setString("fclinicImage", res[0].cImageUrl);
        prefs.setString("fdkt1", res[0].kt1 ?? "");
        prefs.setString("fdkt2", res[0].kt2 ?? "");
        prefs.setString("fdkt1image", res[0].ktImage ?? "");

        prefs.setBool("isLoggedIn", true);
        await setData();
        Navigator.of(context).pushReplacementNamed("/HomePage");
        ToastMsg.showToastMsg("Logged in");
      }
    }
  }

  void _handlePhpLogin() async {
    final res = await DrProfileService.getCredential(
        _userIdController.text, _passwordController.text);
    print(res);
    if (res != "null") {
      if (res.length == 0) {
        ToastMsg.showToastMsg("Wrong id or password");
        setState(() {
          _isLoading = false;
        });
      } else if (res.length > 0) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userType", "doctor");
        userType = "doctor";
        doctId = res[0].id;
        prefs.setString("doctName", res[0].firstName + " " + res[0].lastName);
        prefs.setString("doctImage", res[0].profileImageUrl);

        prefs.setString("doctId", res[0].id);
        prefs.setBool("isLoggedIn", true);
        await setData();
        Navigator.of(context).pushReplacementNamed("/HomePage");
        ToastMsg.showToastMsg("Logged in");
      }
    }
  }

  void checkLoginStatus() async {
    //   Navigator.pushNamed(context, "/LoginPage");
    setState(() {
      logInLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") != null) {
      if (prefs.getBool("isLoggedIn")!) {
        Navigator.of(context).pushReplacementNamed("/HomePage");
      } else {
        setState(() {
          logInLoading = false;
        });
      }
    }
    setState(() {
      logInLoading = false;
    });
  }

}
