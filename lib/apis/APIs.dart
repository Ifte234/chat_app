// import 'dart:html';
import 'dart:developer';
import 'dart:io';


import 'package:chat_app/apis/ChatUser.dart';
import 'package:chat_app/apis/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Api {
//   for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
//   For Accessing Cloud Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  // For accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;
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
      pushToken: '',
      lastSeen: '');
  // getter for getting current user or to return current user
  static User get user => auth.currentUser!;

// for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser?.uid)
            .get())
        .exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      // log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
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
    await firestore.collection('user').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => selfInfo());
      }
    });
  }

// for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUser(
        lastSeen: time,
        name: user.displayName.toString(),
        about: 'Hey,I am using Chat Application',
        email: user.email.toString(),
        id: auth.currentUser!.uid,
        image: user.photoURL!,
        createdAt: time,
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  // *******Updating UserProfile data **************
  static Future<void> UpdateUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // Update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //   getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    //   storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //   uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
          log("Data Transferred: ${p0.bytesTransferred/1000 } Kb");
    });
  //   updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({'image': me.image});
  }


  // *******  For getting All Users from firestore database  *******************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  /// ************** Chat Screen Related APIs
  //For getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
// For getting all messages for a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

//   for sending message
  static Future<void> sendMessage(
      ChatUser chatuser, String msg, MyType type) async {
    // message sending time also used as id
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // Message to send
    final Message messsage = Message(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: MyType.text,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages/');
    await ref.doc(time).set(messsage.toJson());
  }
// Chats (Collection) --> Conversation_id (doc) -->messages (collection) --> message (doc)
}
