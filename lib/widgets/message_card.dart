import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/APIs.dart';
import 'package:chat_app/helper/myDateUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apis/Message.dart';
import '../apis/Message.dart';
import '../apis/Message.dart';
import '../main.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key,  required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.user.uid == widget.message.fromId
        ? _greenMessage(widget.message)
        : _blueMessage(widget.message);
  }

// Sender or another user message
  Widget _blueMessage(Message message) {
    // update last read message if sender and receiver or different
    if(widget.message.read.isEmpty){
      Api.updateMessageReadStatus(widget.message);
    }
    return Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.lightBlue),
              color: Color.fromARGB(255, 221, 245, 255),
            ),
            child:
            widget.message.type == MyType.text ? Text(
              message.msg,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ):
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.1),
              child: CachedNetworkImage(
                height: mq.height * 0.2,
                width: 170,
                fit: BoxFit.cover,
                imageUrl: widget.message.msg,

                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              ),
            ),

          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            MyDateUtils.getFormattedTime(context: context, time: message.sent),
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }

// Our or User Message
  Widget _greenMessage(Message message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Message time
        Row(
          children: [
            SizedBox(
              height: mq.height * 0.04,
            ),
            // Double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            SizedBox(height: 2),
            Text(
              MyDateUtils.getFormattedTime(
                  context: context, time: message.sent),
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              border: Border.all(color: Colors.lightGreen),
              color: Color.fromARGB(255, 218, 255, 176),
            ),
            child: Text(
              message.msg,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
