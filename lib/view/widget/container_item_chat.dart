import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/massage.dart';
import 'package:we_chat/model/my_date.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/chat_screen.dart';

class containerItemChat extends StatefulWidget {
  const containerItemChat({super.key, required this.user});

  final UserProfile user;

  @override
  State<containerItemChat> createState() => _containerItemChatState();
}

class _containerItemChatState extends State<containerItemChat> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: widget.user,),));
      },
      child: Container(
        height: 80,
        child: StreamBuilder(
          stream: Apis.getlastMessage(userPhone: Apis.me.phone!, friendPhone: widget.user.phone!),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: CircularProgressIndicator(),);
            }else{
              if(snapshot.hasData){
                final data = snapshot.data?.docs;
                final list = data!.map((e) => Message.fromJson(e.data())).toList();
                Message? _message;

                if(list.isNotEmpty)
                  _message = list[0];
                

                _message == null ? print('mesage í null') : print('message not null') ;

                return Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: Container(
                        height: 50,
                        width: 50,
                        decoration: widget.user.image == appAssets.imgAvatarDefauld ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(appAssets.imgAvatarDefauld),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(25)
                        ):
                        BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.user.image!),
                            fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.circular(25)
                        ),
                    ),
                    title: Container(
                      child: Text(widget.user.name!,
                        style: TextStyle(color: appColors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    subtitle: _message != null ? Container(
                      child:  
                        Text(
                          _message.type == "text" ? _message.msg! : "[video]",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    ) : Container(
                      child: Text(' '),
                    ),
                    trailing: _message == null ? null :
                    _message.read!.isEmpty && _message.fromid != Apis.user.phoneNumber ?
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ) : Text(MyDate.getlastMessageTime(context: context, time: _message.sent!))
                  )
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            }
            
          },
        )
      ),
    );
  }
}