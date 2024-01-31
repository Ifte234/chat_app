import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/ChatScreen.dart';
import '../apis/ChatUser.dart';
import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {



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
        child: ListTile(
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
          subtitle: Text(widget.user.about),
          // Time of Last Message
          trailing: Text(widget.user.lastSeen),
        ),
      ),),
    );
  }
}
