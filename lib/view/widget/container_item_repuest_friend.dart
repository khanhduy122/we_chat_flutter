import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';

class containerItemRequestFriend extends StatelessWidget {
  const containerItemRequestFriend({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              image: user.image == appAssets.imgAvatarDefauld ? DecorationImage(
                image: AssetImage(user.image!),
                fit: BoxFit.fill
              ) : 
              DecorationImage(
                image: NetworkImage(user.image!),
                fit: BoxFit.fill
              ) ,
              borderRadius: BorderRadius.circular(25)
            ),
          ),
          Expanded(
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(user.name!,
                    style: TextStyle(color: appColors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await Apis.DeleteRequestAddFriend(friendPhone: user.phone!, userPhone: Apis.me.phone!);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 25,
                            child: Image.asset(appAssets.iconClose, color: Colors.red, fit: BoxFit.fill,),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            await Apis.addFriend(userFriend: user);
                            await Apis.DeleteRequestAddFriend(friendPhone: user.phone!, userPhone: Apis.me.phone!);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: 25,
                            child: Image.asset(appAssets.iconVerified, fit: BoxFit.fill,),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            )
          )
        ],
      ),
    );
  }
}