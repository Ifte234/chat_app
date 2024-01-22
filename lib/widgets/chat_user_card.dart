import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apis/ChatUser.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Card(child: InkWell(
        onTap: (){},
        child: ListTile(
          // Profile Pic
          leading: CircleAvatar(child:
          // Icon(CupertinoIcons.person)
            Image.network(fit:BoxFit.cover , widget.user.image),
          radius: 29,),
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
