import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/Message.dart';
import 'package:chat_app/helper/myDateUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/ChatScreen.dart';
import '../apis/APIs.dart';
import '../apis/ChatUser.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;



  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Card(child: InkWell(
        onTap: (){
          // For Navigating to chat screen
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user,)));
          // Navigator.pop(context);
        },
        child: StreamBuilder(
          stream: Api.getLastMessage(widget.user),
          builder: (context,snapshot){
            final data = snapshot.data?.docs;
            final list =data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty) _message = list[0];
            // if(data == '' && data!.first.exists){
            //   _message = Message.fromJson(data!.first.data());
            // }
           return ListTile(
              // Profile Pic
              // leading: CircleAvatar(child:
              // // Icon(CupertinoIcons.person)
              //   Image.network(fit:BoxFit.cover , widget.user.image),
              // radius: 29,),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.05),
                child: CachedNetworkImage(
                  height: mq.height * 0.15,
                  width: mq.width * 0.15,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              // User Name
              title: Text(widget.user.name),
              // Last Message
              subtitle: Text(_message != null? _message!.msg:widget.user.about),
              // Time of Last Message
              trailing: _message == null ? null :_message!.read.isEmpty && _message?.fromId != Api.user.uid? Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ):
               Text(MyDateUtils.getLastMessageTime(context: context, time: _message!.sent).toString())
            );
          },

        )
      ),),
    );
  }
}
