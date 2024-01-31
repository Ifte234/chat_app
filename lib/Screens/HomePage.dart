import 'dart:convert';
import 'dart:math';

import 'package:chat_app/Screens/ProfilePage.dart';
import 'package:chat_app/Screens/SplashScreen.dart';
import 'package:chat_app/apis/APIs.dart';
import 'package:chat_app/apis/ChatUser.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  // var me ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Api.getSelfInfo();


    debugPrint('${Api.me}');
  }
  // For storing all users
  List<ChatUser> list = [];
  // For storing Search items
  final List<ChatUser> _searchuser = [];
  // for storing search items

  bool _isSearching = false ;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: _isSearching? TextFormField(
autofocus: true,
          // When search list changes update the search list
          onChanged: (val){
  _searchuser.clear();
          // Search Logic
            for(var i in list){
              if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                _searchuser.add(i);
                setState(() {
                  _searchuser;
                });
              }

            }

          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Name,Email...",

          ),
        ) : Text("Chatify App"),
        actions: [
          // Search Button / Icon
          InkWell(
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                _isSearching ? Icons.clear : Icons.search,
              ),
            ),
          ),
           IconButton(
              onPressed: () async {
                // debugPrint('${Api.me}');

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(user: Api.me)));
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add_comment_rounded),
      ),
      body: StreamBuilder(
          stream: Api.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //   if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(
                  child: CircularProgressIndicator(),
                );

              // if all or some data is loaded then show it;
              case ConnectionState.active:
              // TODO: Handle this case.
              case ConnectionState.done:
                // TODO: Handle this case.
                final data = snapshot.data!.docs;
                list = data.map((e) => ChatUser.fromJson(e.data())).toList();
            }
            // if(snapshot.hasData){
            //
            //   final data = snapshot.data?.docs;
            //   for(var i in data!){
            //     debugPrint("Ahmed");
            //     debugPrint("Data ${jsonEncode(i.data())}");
            //     list.add(i.data()['name']);
            //
            //   }

            // }
            if (list.isNotEmpty) {
              return ListView.builder(
                itemCount: _isSearching? _searchuser.length:list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // return
                  // Text('Name: ${list[index]}');
                  return ChatUserCard(
                    user: _isSearching? _searchuser[index] : list[index],
                  );
                },
              );
            } else {
              return Text("No Connection Found!");
            }
          }),
    );
  }
}



