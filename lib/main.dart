import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/friend_screen.dart';
import 'package:we_chat/view/home_screen.dart';
import 'package:we_chat/view/login_screen.dart';
import 'package:we_chat/view/user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: FirebaseAuth.instance.currentUser != null ? MyHomePage() : LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _curentIndexBottomBar = 0;

  
  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: Apis.getProfileMe(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Center(child: CircularProgressIndicator(),);
        }else{
          if(snapshot.hasData){

            Apis.me = UserProfile.fromJson(snapshot.data!.data()!);

            return Scaffold(
              backgroundColor: appColors.secondColor,
              body: SafeArea(
                child: IndexedStack(
                  index: _curentIndexBottomBar,
                  children: [
                    HomeScreen(),
                    FriendScreen(),
                    UserScreen()
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: appColors.secondColor,
                  borderRadius:BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                  )
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SalomonBottomBar(
                  selectedItemColor: appColors.white,
                  unselectedItemColor: appColors.white,
                  currentIndex: _curentIndexBottomBar,
                  onTap: (index) {
                    setState(() {
                      _curentIndexBottomBar = index;
                    });
                  },
                  items: [
                    SalomonBottomBarItem(
                      icon: Icon(Icons.home), 
                      title: Text('Trang Chủ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(Icons.folder_shared_rounded), 
                      title: Text('Bạn Bè',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ),
                    SalomonBottomBarItem(
                      icon: Icon(Icons.person), 
                      title: Text('Cá Nhân',
                        style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    )
                  ],
                ),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      },
    );
  }
}
