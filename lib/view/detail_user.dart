import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/view/widget/container_back_screen.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({super.key});

  @override
  State<DetailUser> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailUser> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: appColors.secondColor
                  ),
                ),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/avatarChat.jpg',)
                      ),
                      borderRadius: BorderRadius.circular(75)
                    ),
                  ),
                ),
                Positioned(
                  top: 190,
                  left: size.width-170,
                  child: Icon(Icons.camera_alt, color: appColors.black, size: 40,)
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 200, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Khánh Duy',
                          style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          height: 20,
                          margin: EdgeInsets.only(left: 10),
                          child: Image.asset(appAssets.iconPen, fit: BoxFit.fill,),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),
        ],
      )
    );
  }
}