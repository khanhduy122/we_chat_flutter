import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/view/verify_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String verify = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                appAssets.imgVerify,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Xác minh số điện thoại",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Vui lòng nhập số điện thoai của bạn ",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
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
                        controller: _textEditController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: appColors.secondColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if(_textEditController.text.isEmpty){
                        ToastNotifi('Mời bạn nhập số điện thoại');
                      }else{
                        if(_textEditController.text.length < 10 || _textEditController.text.length > 11){
                          ToastNotifi('Số điện thoại không hợp lệ');
                        }else {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+84 ${_textEditController.text}',
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId, int? resendToken) {
                              LoginScreen.verify = verificationId;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyScreen(numberPhone: _textEditController.text),));
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );
                        }
                      }
                    },
                    child: Text("Tiếp Tục")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

ToastNotifi(String title){
  Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[200],
      textColor: Colors.black,
      fontSize: 16.0
  );
}