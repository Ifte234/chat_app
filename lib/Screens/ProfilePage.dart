import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/auth/LoginScreen.dart';
import 'package:chat_app/apis/APIs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../apis/ChatUser.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Call selfInfo to initialize 'me' before accessing it in the widget
    Api.getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                //*************For User Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 10),
                  child: Stack(
                    children:[
                      //********User Image    *************
                      ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * 0.1),
                      child: CachedNetworkImage(
                        height: mq.height * 0.2,
                        width: 170,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(onPressed: (){},
                          elevation: 1,
                          shape: CircleBorder(),
                          color: Colors.white,
                        child: Icon(Icons.edit,color: Colors.blue,),
                        ),
                      )
                    ]
                  ),
                ),
            Text(widget.user.email),
                SizedBox(height: 80.0),
                // *************For Name****
                TextFormField(

                  onSaved: (val)=>Api.me.name=val ?? '',
                validator: (val) => val != null && val.isNotEmpty ? null:'Required Field',
                // controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.profile_circled,color: Colors.blue,),

                hintText: widget.user.name,
                labelText: 'Name',
                border: OutlineInputBorder(
                borderSide: BorderSide(
                color: Colors.blue, // Change the color as needed
                width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                Radius.circular(8.0),
                ),
                ),
                ),),

                SizedBox(height: 10.0),
                // *************For About****
                TextFormField(
                  onSaved: (val)=>Api.me.about=val ?? '',
                  validator: (val) => val != null && val.isNotEmpty ? null:'Required Field',

                  // controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline,color: Colors.blue,),
                    focusColor: Colors.blue,
                    hintText: widget.user.about,
                    labelText: 'About',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue, // Change the color as needed
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),),


                SizedBox(height: 10.0),
              //   ***********For Edit Button
          ElevatedButton.icon(
            onPressed: () {
              // Handle edit button tap here
              // You can add the logic to enable editing or navigate to an edit screen.
           if(_formkey.currentState!.validate()){

             _formkey.currentState?.save();
             Api.UpdateUserInfo().then((value){
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Profile has been Updated Successfully'),
                   duration: Duration(seconds: 2),
                   // action: SnackBarAction(
                   //   label: 'Undo',
                   //   onPressed: () {
                   //     // Perform some action when the "Undo" button is pressed
                   //     // (You can leave this empty if you don't want an action)
                   //   },
                   // ),
                 ),
               );
             });

           }
            },
            icon: Icon(Icons.edit,color: Colors.white,),
            label: Text(' Update',style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue, // Change the color as needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),)),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Handle logout button tap here
          // You can add the logic to perform logout actions.

          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Navigator.pop(context);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));

          // Show a SnackBar with the "Logged Out!" message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged Out!'),
            ),
          );
        },
        tooltip: 'Logout',
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red, // Change the color as needed
      ),
    );
  }
}
