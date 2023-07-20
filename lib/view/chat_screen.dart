


import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/massage.dart';
import 'package:we_chat/model/my_date.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/widget/container_back_screen.dart';
import 'package:we_chat/view/widget/massage_chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

   final UserProfile user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Message> list = [];
  final _textController = TextEditingController();
  late VideoPlayerController controller;
  bool isUploadVideo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        backgroundColor: appColors.secondColor,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.arrow_back_ios, color: appColors.white, size: 20,)
                ),
              ),
              Container(
                height: 40,
                width: 40,
                margin: EdgeInsets.only( right: 10),
                decoration: widget.user.image == appAssets.imgAvatarDefauld ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(appAssets.imgAvatarDefauld),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(25)
                ) : BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.user.image!),
                    fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.circular(25)
                )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.user.name!,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Không hoạt động',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Apis.getAllMassage(userPhone: Apis.me.phone!, friendPhone: widget.user.phone!),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator(),);
          
                  case ConnectionState.active:
                  case ConnectionState.done : {
                    final data = snapshot.data?.docs;
          
                    list = data!.map((e) => Message.fromJson(e.data())).toList();
          
                    if(list.isNotEmpty){
                      return Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onLongPress: (){
                                _showBottomSheet(list[index], widget.user);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: MessageChat(message: list[index],) 
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Center(
                        child: Text('Hello 👋'),
                      );
                    }
                  }
                }
              },
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: appColors.secondColor
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: appColors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          maxLines: 10,
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nội dung',
                            hintStyle: TextStyle(color: appColors.secondColor)
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                GestureDetector(
                  onTap: ()async{
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
                    if(image != null){
                     Apis.sendPicture(file: File(image.path), friendPhone: widget.user.phone!, userPhone: Apis.me.phone!);
                    }
                  },
                  child: Container(
                    child: Icon(Icons.image, color: Colors.white, size: 35,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(_textController.text.isNotEmpty){
                      Apis.sendMessage(userPhone: Apis.me.phone! ,friend: widget.user.phone! ,msg: _textController.text ,type: 'text');
                      _textController.text = '';
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(appAssets.iconSendMessage, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
        ]
      ),
    );
  }

  _showBottomSheet(Message message, UserProfile user){
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            )
      ),
      builder: (_) {
        return Container(
          height: 100,
          child: Column(
            children: [
              SizedBox(height: 20,),
              InkWell(
                onTap: () async {
                  await Apis.deleteMessage(userPhone: Apis.me.phone!, friendPhone: user.phone!, message: message);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child:  Icon(Icons.delete, color: Colors.red,),
                      ),
                      Text('Xóa tin nhắn',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
