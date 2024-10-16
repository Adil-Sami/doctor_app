
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/appbars.dart';
import 'package:demoadmin/widgets/errorWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:demoadmin/model/wallet_history_model.dart';
class AllHistoryWalletPage extends StatefulWidget {

  const AllHistoryWalletPage({Key? key}) : super(key: key);

  @override
  State<AllHistoryWalletPage> createState() => _AllHistoryWalletPageState();
}

class _AllHistoryWalletPageState extends State<AllHistoryWalletPage> {


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IAppBars.commonAppBar(context, "All Transaction"),
        body:      FutureBuilder(
            future: UserService.getWalletAllHistory(), //fetch images form database
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

    );
  }

  _buildListView(data) {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          UserWalletHistoryModel userWalletHistoryModel=data[index];
          return Card(
            elevation: .3,
            child: ListTile(
                contentPadding: EdgeInsets.all(10),
                onTap: (){
                  print(userWalletHistoryModel.id);
                },
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
                    SizedBox(height: 5),
                    Text("${userWalletHistoryModel.firstName??""} ${userWalletHistoryModel.lastName??""}"),
                    SizedBox(height: 5),
                    Text(userWalletHistoryModel.phone??""),

                  ],
                )),
          );
        });
  }


}
