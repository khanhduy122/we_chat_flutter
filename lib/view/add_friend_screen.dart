import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/user_friend_screen.dart';
import 'package:we_chat/view/user_screen.dart';
import 'package:we_chat/view/widget/container_back_screen.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {

  TextEditingController _textEditingController = TextEditingController();
  String? numberPhone;
  bool? isAddFriend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.secondColor,
        centerTitle: true,
        leading: containerBackScreen(color: Colors.white,),
        title: Text('Kết Bạn',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40,),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                            "+84",
                            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          ),
                          Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textEditingController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                              ),
                          ))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                  onTap: () async {
                    if(_textEditingController.text[0] == '0'){
                      numberPhone = '+84' + _textEditingController.text.substring(1);

                      if(await Apis.checkActiveUser(numberPhone!)){
                        if(numberPhone == Apis.me.phone!){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen(),));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserFriendScreen(phoneNumber: numberPhone!,),));
                        }
                      }else {
                        _showDialogNotify(context);
                      }
                    }else{
                      numberPhone = '+84' + _textEditingController.text;

                      if(await Apis.checkActiveUser(numberPhone!)){
                        if(numberPhone == Apis.me.phone!){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen(),));
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserFriendScreen(phoneNumber: numberPhone!,),));
                        }
                      }else {
                        _showDialogNotify(context);
                      }
                    }
                    
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: appColors.secondColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Icon(Icons.arrow_forward, color: Colors.white,),
                  ),
                )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_showDialogNotify(BuildContext context){
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Số điện thoại này chưa được đăng kí',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('OK',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      );
    },
  );
}