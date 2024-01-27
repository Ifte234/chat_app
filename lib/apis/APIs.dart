

import 'package:chat_app/apis/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Api {
//   for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
//   For Accessing Cloud Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // For getting Self info
  // for storing self information
  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      // isOnline: false,
      // lastActive: '',
      pushToken: '', lastSeen: ''); // getter for getting current user
  static User get user =>auth.currentUser!;

// for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get())
        .exists;
  }
  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        // await getFirebaseMessagingToken();

        //for setting user status to active
        // Api.updateActiveStatus(true);
        debugPrint('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }
//   For getting Self info
  static Future<void> selfInfo() async {
    await firestore
        .collection('user')
        .doc(user.uid)
        .get().then((user) async {
          if(user.exists){
            me = ChatUser.fromJson(user.data()!);
          }else{
           await createUser().then((value) => selfInfo());
          }
    });
  }
// for creating a new user
static Future<void> createUser()async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(lastSeen: time, name: user.displayName.toString(), about: 'Hey,How are you?', email: user.email.toString(), id: auth.currentUser!.uid, image: user.photoURL!, createdAt: time, pushToken: '');
return await firestore.collection('users').doc(user.uid).set(chatuser.toJson());

  }
  // *******Updating UserProfile data **************
  static Future<void> UpdateUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({'name':me.name,'about':me.about});
  }
  // *******  For getting All Users from firestore database  *******************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }
}
