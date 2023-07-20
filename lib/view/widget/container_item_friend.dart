import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/chat_screen.dart';


class containerItemFriend extends StatelessWidget {
  const containerItemFriend({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
      return InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: user),));
        },
        child: Container(
        height: 80,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            alignment: Alignment.center,
            child: ListTile(
              leading: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      image: user.image == appAssets.imgAvatarDefauld ? DecorationImage(
                        image: AssetImage(user.image!),
                        fit: BoxFit.fill
                      ) : DecorationImage(
                        image: NetworkImage(user.image!),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.circular(25)
                    ),
                ),
                title: Container(
                  child: Text(user.name!,
                    style: TextStyle(color: appColors.black, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
            ),
          ),
        ),
          ),
      );
   }
}