import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../apis/APIs.dart';
import '../apis/ChatUser.dart';
import '../apis/Message.dart';
import '../main.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // for storing all messages
  List<Message> _list = [];
  // For handling message text changes
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: Api.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Center(
                        child: SizedBox(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      log("Data: ${jsonEncode(data![0].data())}");
                      _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];



                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MessageCard(msg: _list[index]);
                      },
                    );
                  } else {
                    return Text(
                      "Say Hi! 👋",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    );
                  }
                } }
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * 0.06),
          child: CachedNetworkImage(
            height: mq.height * 0.10,
            width: mq.width * 0.10,
            imageUrl: widget.user.image,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.name,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Text(
              'Last Seen NOT AVAILABLE',
              style: TextStyle(fontSize: 10),
            )
          ],
        )
      ],
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shadowColor: Colors.black,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions, color: Colors.blue)),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Write something...",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.image, color: Colors.blue)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_rounded, color: Colors.blue)),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {


              if (_textController.text.isNotEmpty) {
                Api.sendMessage(widget.user, _textController.text);
                // _textController.text = '';
                _textController.clear();
                // Use clear instead of setting it to empty string
                Fluttertoast.showToast(
                  msg: "This is Center Short Toast${Api.sendMessage(widget.user, _textController.text)}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            color: Colors.teal,
            shape: CircleBorder(),
            child: Icon(Icons.send, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
