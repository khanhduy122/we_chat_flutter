import 'package:flutter/material.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/widget/container_back_screen.dart';

class UserFriendScreen extends StatefulWidget {
  const UserFriendScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<UserFriendScreen> createState() => _UserFriendScreenState();
}

class _UserFriendScreenState extends State<UserFriendScreen> {

  UserProfile? user;
  bool? isFriend;
  bool? isAddFriend;

  void getIsAddFriend() async {
    isAddFriend = await Apis.checkIsSendRequestFriend(widget.phoneNumber);
  }

  void getIsFriend() async {
    isFriend = await Apis.checkIsFriend(widget.phoneNumber);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIsAddFriend();
    getIsFriend();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: FutureBuilder(
        future: Apis.getProfileUserFriend(widget.phoneNumber),
        builder: (context, snapshot) {

          if(snapshot.hasError){
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(snapshot.hasData){

              user = UserProfile.fromJson(snapshot.data!.data()!);

              return Column (
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
                            decoration: user!.image! == appAssets.imgAvatarDefauld ?
                            BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(appAssets.imgAvatarDefauld),
                                fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(75)
                            ): 
                            BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(user!.image!),
                                fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(75)
                            )
                          )
                        ),
                        SizedBox(height: 24,),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 180),
                            child: Text(user!.name!,
                              style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: containerBackScreen(color: Colors.white,),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  isFriend! ?
                  GestureDetector(
                    onTap: () async {
                      
                    },
                    child: Center(
                      child: Container(
                        width: 120,
                        padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(Icons.message),
                            ),
                            Text('Nhắn tin',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : GestureDetector(
                    onTap: () async{
                      if(isAddFriend == true){
                        await Apis.DeleteRequestAddFriend(friendPhone: Apis.me.phone!, userPhone: user!.phone!);
                        setState(() {
                          isAddFriend = false;
                        });
                      }else{
                        await Apis.PutRequestAddFriend(user!);
                        setState(() {
                          isAddFriend = true;
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        width: isAddFriend == true ? 200 : 120,
                        padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(Icons.group_add),
                            ),
                            Text(isAddFriend == true ? 'Huy yêu cầu kết Bạn' : 'Kết bạn',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          }
        },
      )
    );
  }
}