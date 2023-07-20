import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:video_player/video_player.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/massage.dart';
import 'package:we_chat/model/my_date.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';

class MessageChat extends StatefulWidget {
  const MessageChat({super.key, required this.message});

  final Message message;

  @override
  State<MessageChat> createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {

  late final VideoPlayerController _videoPlayerController;
  
  void loadVideoPlayer(String url,){
    _videoPlayerController = VideoPlayerController.network(url);
    _videoPlayerController.initialize().then((value){
        if(mounted){
          setState(() {
            
          });
        }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.message.type != 'text' ? loadVideoPlayer(widget.message.msg!) : null;  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.message.type != 'text' ? _videoPlayerController.dispose() : null;  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.message.fromid == Apis.user.phoneNumber ? 
    Container(
      margin: EdgeInsets.only(right: 10),
      child: _meMassage(context)
    ) : 
    Container(
      margin: EdgeInsets.only(left: 10),
      child: _friendMassage(context)
    );
  }
  Widget _meMassage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: widget.message.type == 'text' ? Text(widget.message.msg!,
                    style: TextStyle(color: Colors.black, fontSize: 16,),
                  ) : 
                  Stack(
                    children: [
                      Container(
                        child: _videoPlayerController.value.isInitialized ? 
                        AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )
                        :  Center(child: CircularProgressIndicator(),)
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Icon(Icons.play_circle, color: Colors.white, size: 30,),
                        ),
                      )
                    ],
                  )
                ),
                Container(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(MyDate.getFormattedTime(context: context, time: widget.message.sent!),
                          style: TextStyle(color: Colors.black, fontSize: 12,),
                        ),
                      ),
                      Container(
                        child: widget.message.read!.isEmpty ? Text('') : Image.asset(appAssets.iconSeened, color: Colors.green,),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendMassage(BuildContext context){

    if(widget.message.read!.isEmpty){
      Apis.updateStatusMessage( message: widget.message, friendPhone: widget.message.fromid!, userPhone: widget.message.told!);
      Apis.updateStatusMessage( message: widget.message, friendPhone: widget.message.told!, userPhone: widget.message.fromid!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: widget.message.type == 'text' ? Text(widget.message.msg!,
                    style: TextStyle(color: Colors.black, fontSize: 16,),
                  ) :
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        child: _videoPlayerController.value.isInitialized ? VideoPlayer(_videoPlayerController) : Center(child: CircularProgressIndicator(),)
                      ),
                      Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Icon(Icons.play_circle, color: Colors.white, size: 20),
                      )
                    ],
                  )
                ),
                Container(
                  child: Text(MyDate.getFormattedTime(context: context, time: widget.message.sent!),
                    style: TextStyle(color: Colors.black, fontSize: 12,),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 100,
        ),
      ],
    );
  }
}
