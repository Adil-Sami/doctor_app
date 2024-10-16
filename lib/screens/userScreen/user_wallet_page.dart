
import 'package:demoadmin/model/notificationModel.dart';
import 'package:demoadmin/service/Notification/handleFirebaseNotification.dart';
import 'package:demoadmin/service/notificationService.dart';
import 'package:demoadmin/service/updateData.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/utilities/dialogBox.dart';
import 'package:demoadmin/utilities/toastMsg.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demoadmin/model/wallet_history_model.dart';
class WalletPage extends StatefulWidget {
  final userID;
  const WalletPage({Key? key,this.userID}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? _selectedCredit ;
  String?   fcmId;
  bool _isLoading=false;
  ScrollController _scrollController=ScrollController();
  TextEditingController _textEditingController=TextEditingController();
  TextEditingController _desc=TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String amount="0";
  String userName="User Wallet";

  String? prAmount;
  @override
  void initState() {
    // TODO: implement initState
    _textEditingController.text="1000";
    _desc.text="Credited By Admin";
    getAndSetData();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBars.commonAppBar(context, userName),
      body: _isLoading?LoadingIndicatorWidget() :
      ListView(
        padding: EdgeInsets.all(5),
        controller: _scrollController,
        children: [
          buildBalanceCard(),
          buildAddMoneyContainer(),
          Divider(),
          Card(
            color: Colors.grey.shade50,
            child: ListTile(
              title: Text("Wallet History"),
            ),
          ),

          FutureBuilder(
              future: UserService.getWalletHistory(widget.userID), //fetch images form database
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData)
                  return snapshot.data.length == 0
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("No Transaction History Found",textAlign: TextAlign.center,),
                  )
                      : _buildListView(snapshot.data);
                else if (snapshot.hasError)
                  return IErrorWidget(); //if any error then you can also use any other widget here
                else
                  return LoadingIndicatorWidget();
              }),


    ],
    ));
  }

  _buildListView(data) {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: data.length,
        controller: _scrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          UserWalletHistoryModel userWalletHistoryModel=data[index];
          return Card(
            elevation: .3,
            child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text("${userWalletHistoryModel.status=="0"?"Credited":"Deducted"} \u{20B9}${userWalletHistoryModel.amount??""}",
                style: TextStyle(
                  color: userWalletHistoryModel.status=="0"?Colors.green:Colors.red
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(userWalletHistoryModel.description??""),
                    SizedBox(height: 5),
                    Text(userWalletHistoryModel.dateTTime??""),
                  ],
                )),
          );
        });
  }

  buildBalanceCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Color(0xFF414370),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded,color: Color(0xFF00CAFC),),
                    SizedBox(width: 5),
                    Text(
                        "Wallet Balance",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "OpenSans-SemiBold"
                          // "OpenSans-SemiBold"
                        )),
                  ],
                ),
        Text("\u{20B9}$amount",style: TextStyle(
            fontSize: 17,
            color: Colors.white
        ))


              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  buildAddMoneyContainer() {
    return Card(
      elevation: 5,
    //  color: appBa,
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Add Money To Wallet",style: TextStyle(
                  fontFamily: "OpenSans-SemiBold",
                  fontSize: 16
              ),),
              SizedBox(height: 10),
              Container(
                decoration:BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ]),
                child: TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    cursorColor: btnColor,
                    controller: _textEditingController,
                    validator: (item){
                      if(item!.length==0){
                        return "Enter Amount";

                      }else if(item.length>0){
                        if(_textEditingController.text=="0"||int.parse(_textEditingController.text)>10000){
                          return "Enter a amount between 1 to 10,000 only";
                        }else{
                          return null;
                        }
                      }else return null;

                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: "\u{20B9}",
                      //   labelText: lableText,
                      hintText: "1000",
                      fillColor: Colors.white,
                      filled: true,
                      // labelStyle: TextStyle(
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.w500
                      // ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide:const BorderSide(color: Colors.red, width: 2.0)),
                    )
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration:BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ]),
                child: TextFormField(
                    cursorColor: btnColor,
                    controller: _desc,
                    validator: (item){
                      if(item!.length>0){
                        return null;
                      }else if(item.length==0){
                      return "Enter Description";
                      }else return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Credited By Admin",
                      fillColor: Colors.white,
                      filled: true,
                      // labelStyle: TextStyle(
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.w500
                      // ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide:const BorderSide(color: Colors.red, width: 2.0)),
                    )
                ),
              ),

              _genderDropDown(),
              SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: btnColor,
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      if(_selectedCredit!=null){
                        DialogBoxes.confirmationBox(context, "$_selectedCredit", "Are you sure want to $_selectedCredit Amount Rs. ${_textEditingController.text}", _handleUpdateData);

                      }else{ToastMsg.showToastMsg("Please select Transaction Type");}
                     // print(widget.userID);
                     //  DialogBoxes.confirmationBox(context, "Confrim", subTitle, onPressed)
                     //  _handleUpdateData("xxxxxx");
                    }
                  },
                  child: Text("Proceed To Add", style: TextStyle(fontSize: 14)))

            ],
          ),
        ),
      ),
    );
  }
  _genderDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: _selectedCredit,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: btnColor,
        items: <String>[
          'Credit',
          'Debit',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Transaction Type",
        ),
        onChanged: (String? value) {
          setState(() {
            if(value=="Debit"){
              print("kokoko");
              setState(() {
                _desc.text="Debited By Admin";
              });
             }
            else if(value=="Credit")
              setState(() {
                _desc.text="Credited By Admin";
              });

            print(value);
            _selectedCredit = value!;
          });
        },
      ),
    );
  }

  void _handleUpdateData() async{
    setState(() {
      _isLoading=true;
    });
    final getRes=await UserService.addDataWallet(
      userId: widget.userID,
        payment_id: "xxxxxx",
        amount: _textEditingController.text,
        status: _selectedCredit=="Credit"?"0":"1",
        prAmount: amount,
        desc:_desc.text);
    print(getRes);
    if(getRes=="error"){ToastMsg.showToastMsg("Something went wrong");}
    else if(getRes=="success"){
      _sendNotification();
      ToastMsg.showToastMsg("Success");
    }
    getAndSetData();

    setState(() {
      _isLoading=false;
    });
  }

  _sendNotification() async {
    String body = "Rs ${_textEditingController.text} $_selectedCredit to wallet successfully";
    String title=_selectedCredit??"Wallet";
    final patientName=userName;
    //await SMTPService.sentMailForApp(widget.appointmentDetails.pEmail, title, body, _clinicNameController.text, widget.appointmentDetails.doctName, formatedDate, widget.appointmentDetails.appointmentTime, patientName,widget.appointmentDetails.id.toString(), _paymentStatusController.text, _phnController.text, _serviceName2Controller.text);
    final notificationModel = NotificationModel(
        title: title,
        body: body,
        uId: widget.userID.toString(),
        routeTo: "",
        sendBy: "admin",
        sendFrom: "Admin",
        sendTo:patientName);
    final msgAdded = await NotificationService.addData(notificationModel);
    if (msgAdded == "success") {
      final res = await UserService.getUserById(
         widget.userID.toString()); //get fcm id of specific user

      HandleFirebaseNotification.sendPushMessage(res[0].fcmId, title, body);
      await UpdateData.updateIsAnyNotification(
          "usersList", widget.userID, true);
    }
  }
  void getAndSetData() async{
    setState(() {
      _isLoading=true;
    });
    final userData=await UserService.getUserById(widget.userID);

    if(userData.isNotEmpty){
      userName=userData[0].firstName+" "+userData[0].lastName;
      amount=userData[0].amount??"0";
      fcmId=userData[0].fcmId??"";
    }
    setState(() {
      _isLoading=false;
    });


  }

}
