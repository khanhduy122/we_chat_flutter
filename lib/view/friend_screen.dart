
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/add_friend_screen.dart';
import 'package:we_chat/view/widget/container_item_friend.dart';
import 'package:we_chat/view/widget/container_item_repuest_friend.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen ({super.key});

  @override
  State<FriendScreen > createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen > {

  final _textEditcontroller = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        backgroundColor: appColors.secondColor,
        centerTitle: true,
        title: Text('Bạn bè',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24,),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.search, color: appColors.black,),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 199, 199, 199),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: TextField(
                          style: TextStyle(color: appColors.black, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Tìm Kiếm',
                            hintStyle: TextStyle(color: appColors.black, fontSize: 16),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddFriendScreen(),));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.group_add, color: appColors.black,),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24,),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('Lời mời kết bạn',
                style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20,),
            StreamBuilder(
              stream: Apis.getAllRequestAddFriend(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done : {
                    final data = snapshot.data?.docs;
                    final list = data!.map((e) => UserProfile.fromJson(e.data())).toList();

                    print(list.toString());

                    if(list.isNotEmpty){
                      return Container(
                        height: list.length * 90,
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: containerItemRequestFriend(
                                user: list[index]
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Center(
                        child: Text('Không có lời mới kết bạn'),
                      );
                    }
                  }
                }
              },
            ),
            SizedBox(height: 24,),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('Danh sách bạn bè',
                style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10,),
            StreamBuilder(
              stream: Apis.getAllFriend(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done : {
                    final data = snapshot.data?.docs;
                    final list = data!.map((e) => UserProfile.fromJson(e.data())).toList();

                    if(list.isNotEmpty){
                      return Container(
                        height: list.length * 90,
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onLongPress: (){
                                  _showBottomSheet(list[index]);
                                },
                                child: containerItemFriend(
                                  user: list[index]
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      return Center(
                        child: Text('Không có bạn bè'),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      )
    );
  }
  _showBottomSheet(UserProfile user){
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
                  await Apis.deleteFriend(friendPhone: user.phone!);
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
                      Text('Xóa Bạn bè',
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



