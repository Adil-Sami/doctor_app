import 'package:demoadmin/screens/userScreen/editUserProfilePage.dart';
import 'package:demoadmin/screens/userScreen/user_wallet_page.dart';
import 'package:demoadmin/service/userService.dart';
import 'package:demoadmin/utilities/colors.dart';
import 'package:demoadmin/widgets/boxWidget.dart';
import 'package:demoadmin/widgets/buttonsWidget.dart';
import 'package:demoadmin/widgets/loadingIndicator.dart';
import 'package:demoadmin/widgets/noDataWidget.dart';
import 'package:flutter/material.dart';

class SearchUserByNamePage extends StatefulWidget {
  final bool? walletSearch;
  const SearchUserByNamePage({Key? key, this.walletSearch}) : super(key: key);
  @override
  _SearchUserByNamePageState createState() => _SearchUserByNamePageState();
}

class _SearchUserByNamePageState extends State<SearchUserByNamePage> {
  List _userList = [];
  bool _isLoading = false;
  bool _isEnableBtn = true;
  bool _isSearchedBefore = false;

  TextEditingController _searchByNameController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose

    _searchByNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: SearchBoxWidget(
          controller: _searchByNameController,
          hintText: "Search user name",
          validatorText: "Enter Name",
        ),
        actions: [
          SearchBtnWidget(
            onPressed: _handleSearchBtn,
            isEnableBtn: _isEnableBtn,
          )
        ],
      ),
      body: Container(
        child: _cardListBuilder(),
      ),
    );
  }

  Widget _cardListBuilder() {
    return ListView(
      children: [
        //_buildUpperBoxContainer(),
        !_isSearchedBefore
            ? Container()
            : _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingIndicatorWidget(),
                  )
                : this._userList.length > 0
                    ? ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: this._userList.length,
                        itemBuilder: (context, index) {
                          return _buildChatList(this._userList[index]);
                        },
                      )
                    : NoDataWidget()
      ],
    );
  }

  Widget _buildChatList(userList) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.walletSearch ?? false) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalletPage(userID: userList.uId)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditUserProfilePage(userDetails: userList)),
                );
              }
            },
            child: ListTile(
              leading: CircularUserImageWidget(userList: userList),
              title: Text("${userList.firstName} ${userList.lastName}"),
              //         DateFormat _dateFormat = DateFormat('y-MM-d');
              // String formattedDate =  _dateFormat.format(dateTime);
              subtitle: Text("Created at ${userList.createdTimeStamp}"),
              //  isThreeLine: true,
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  _handleSearchBtn() async {
    final pattern = RegExp('\\s+'); //remove all space
    String searchByName = _searchByNameController.text
        .toLowerCase()
        .replaceAll(pattern, ""); //lowercase all letter and remove all space
    if (searchByName != "") {
      setState(() {
        _isLoading = true;
        _isSearchedBefore = true;
      });

      final res = await UserService.getUserByName(searchByName);

      setState(() {
        _userList = res;
        _isLoading = false;
      });
    }
  }
}
