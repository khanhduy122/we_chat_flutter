import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/login_screen.dart';
import 'package:we_chat/view/widget/container_item_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<UserProfile> list = [];
  List<UserProfile> listResultSearch= [];
  bool isSearching = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
          if(isSearching){
            setState(() {
              isSearching = false;
            });
          }else null;
      } ,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromARGB(255, 227, 227, 227),
        drawer: Drawer(
          backgroundColor: Colors.white,
          elevation: 1,
          child: _drawerHome(),
        ),
        appBar: AppBar(
          backgroundColor: appColors.secondColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(Icons.menu_outlined, color: Colors.white,)
            ),
          title: isSearching == true ? Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 199, 199, 199),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextField(
                onChanged: (value){
                  listResultSearch.clear();
        
                  for(var i in list){
                    if(i.name!.toLowerCase().contains(value.toLowerCase()) || 
                       i.phone!.toLowerCase().contains(value.toLowerCase())){
                        listResultSearch.add(i);
                    }
                  }
                  setState(() {
                    listResultSearch;
                  });
                },
                style: TextStyle(color: appColors.black, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Tìm Kiếm',
                  hintStyle: TextStyle(color: appColors.black, fontSize: 16),
                  border: InputBorder.none
                ),
              ),
            ),
          ) : 
          Container(
            alignment: Alignment.center,
            child: Text('We Chat',
              style: TextStyle(color: appColors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ) ,
          actions: [
            GestureDetector(
              onTap: (){
                setState(() {
                  isSearching = !isSearching;
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(isSearching == true ? Icons.close_rounded : Icons.search, color: Colors.white,)
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24,),
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
                      list = data!.map((e) => UserProfile.fromJson(e.data())).toList();
                      if(list.isNotEmpty){
                        return Container(
                          height: list.length * 90,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: isSearching ? listResultSearch.length : list.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: containerItemChat(user: isSearching ? listResultSearch[index] : list[index])
                              );
                            },
                          ),
                        );
                      }else{
                        return Center(
                          child: Text('Không có cuộc trò chuyện,\nhãy tạo một cuộc trò chuyên'),
                        );
                      }
                    }
                  }
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Column _drawerHome() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: appColors.secondColor
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(top: 40),
                    decoration: Apis.me.image == appAssets.imgAvatarDefauld ?
                      BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(appAssets.imgAvatarDefauld),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ) : BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(Apis.me.image!),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(Apis.me.name!,
                      style: TextStyle(color: appColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(Apis.me.phone!,
                      style: TextStyle(color: appColors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
        SizedBox(height: 20,),
        GestureDetector(
          onTap: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
            });
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Icon(Icons.logout, color: Colors.red,),
                ),
                Container(
                  child: Text('Đăng xuất',
                    style: TextStyle(color: appColors.black, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}