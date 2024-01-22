import 'dart:convert';
import 'dart:math';

import 'package:chat_app/apis/APIs.dart';
import 'package:chat_app/apis/ChatUser.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<ChatUser> list = [];
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text("Chatify"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
            // Show a SnackBar with the "Logged Out!" message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logged Out!'),
              ),
            );
          }, icon: Icon(Icons.more_vert))

        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_comment_rounded),
      ),
      
      body: StreamBuilder(
        stream: Api.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
          //   if data is loading
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator(),);

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
         if(list.isNotEmpty){
           return ListView.builder(
             itemCount: list.length,
             physics: BouncingScrollPhysics(),
             itemBuilder: (context,index){
               // return 
               // Text('Name: ${list[index]}');
               return ChatUserCard(user: list[index],);

             }, );
         }else{
           return Text("No Connection Found!");
         }
        }
      ),
    );
  }
}
