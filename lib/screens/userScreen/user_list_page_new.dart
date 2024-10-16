import 'package:demoadmin/Provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPageNew extends StatefulWidget {
  const UserListPageNew({super.key});

  @override
  State<UserListPageNew> createState() => _UserListPageNewState();
}

class _UserListPageNewState extends State<UserListPageNew> {

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).userListPageNew();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          TextFormField(
            cursorColor: Colors.white,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Search"
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
              },
            ),
          ],
        ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) {

            if (provider.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: provider.data!.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Icon(
                                  Icons.person, color: Colors.grey, size: 30),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.data!.data[index].firstName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    provider.data!.data[index].phone,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Icon(Icons.message, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Icon(Icons.currency_rupee,color: Colors.black,)
          ),
        ),
      )
    );
  }
}
