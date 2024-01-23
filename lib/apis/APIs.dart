

import 'package:chat_app/apis/ChatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
//   for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
//   For Accessing Cloud Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // For getting Self info
  static late ChatUser me;
  // getter for getting current user
  static User get user =>auth.currentUser!;

// for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get())
        .exists;
  }
//   For getting Sef info
  static Future<void> selfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
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

  // *******  For getting All Users from firestore database  *******************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return Api.firestore.collection('users').where('id', isNotEqualTo: user.uid).snapshots();
  }
}
