import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/ChatUser.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/chat_user_card.dart';
class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          automaticallyImplyLeading: false,
        
          flexibleSpace: _appBar(widget.user),),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                // stream: Api.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                  //   if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      // return Center(
                      //   child: CircularProgressIndicator(),
                      // );
            
                  // if all or some data is loaded then show it;
                    case ConnectionState.active:
                    // TODO: Handle this case.
                    case ConnectionState.done:
                    // TODO: Handle this case.
                    //   final data = snapshot.data!.docs;
                    //   list = data.map((e) => ChatUser.fromJson(e.data())).toList();
                  }
            
                  
                  final _list =[];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // return
                        // Text('Name: ${list[index]}');
                        return ChatUserCard(
                          user: _list[index],
                        );
                      },
                    );
                  } else {
                    return Text("Say Hi! 👋",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),);
                  }
                }, stream: null,),
          ),
          _chatInput()
        ],
      ),
      ),
    );
  }
}

Widget _appBar(ChatUser user){
  return Row(

    children: [
      IconButton(onPressed: (){

      }, icon: Icon(Icons.arrow_back_rounded)),

      // Text(user.name),
      ClipRRect(
        borderRadius: BorderRadius.circular(mq.height * 0.06),
        child: CachedNetworkImage(
          height: mq.height * 0.10,
          width: mq.width * 0.10,
          imageUrl: user.image,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      SizedBox(width: 5,),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(user.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
          Text('Last Seen NOT AVAILABLE',style: TextStyle(fontSize: 10),)
        ],
      )
    ],
  );
}
//Chat Input Function
Widget _chatInput(){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1,vertical: 10),
    child: Row(
        children: [
          Expanded(
            child: Card(shadowColor: Colors.black,elevation: 2,

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.emoji_emotions,color: Colors.blue,)),
               Expanded(
                 child: TextFormField(
                   keyboardType: TextInputType.multiline,
                   maxLines: null,
                   decoration: InputDecoration(hintText: "Write something",hintStyle: TextStyle(color: Colors.blue),border: InputBorder.none),
                 ),
               ),
                IconButton(onPressed: (){}, icon: Icon(Icons.image,color: Colors.blue,)),
                IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt_rounded,color: Colors.blue,)),

              ],),
            ),
          ),
          MaterialButton(onPressed: (){},
            minWidth: 0,
            padding: EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
            color: Colors.teal,shape: CircleBorder(),
            child: Icon(Icons.send,color: Colors.white,size: 30,),)
        ],


    ),
  );
}