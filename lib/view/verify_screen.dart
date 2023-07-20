import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/view/home_screen.dart';
import 'package:we_chat/view/login_screen.dart';
import 'package:we_chat/view/setup_profile.dart';
import '../model/netword.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.numberPhone});

  final String numberPhone;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  String Pin1 = '';
  String Pin2 = '';
  String Pin3 = '';
  String Pin4 = '';
  String Pin5 = '';
  String Pin6 = '';
  String code = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  final _formKey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
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
                "Bạn vui lòng kiểm tra tin nhắn trên số điện thoại ${widget.numberPhone} đê xác minh",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin1 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin2 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin3 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin4 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin5 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: appColors.secondColor),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: TextFormField(
                          onChanged: (value){
                            setState(() {
                              Pin6 = value;
                            });
                            if(value.length == 1)
                              FocusScope.of(context).nextFocus();
                            if(value.isEmpty)
                              FocusScope.of(context).previousFocus();
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Pin1.isEmpty || Pin2.isEmpty || Pin3.isEmpty || Pin4.isEmpty || Pin5.isEmpty || Pin6.isEmpty ? Colors.grey : appColors.secondColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      code = Pin1 + Pin2 + Pin3 + Pin4 + Pin5 + Pin6;
                      try{
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: LoginScreen.verify, smsCode: code);
                        await auth.signInWithCredential(credential);
                        if(await Apis.userExists()){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(),), (route) => false);
                        }else{
                          await Apis.createUser().then((value)async{
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SetUpProfile(),), (route) => false);
                          });
                        }
                      }catch(e){
                        print('ERROR: '+e.toString());
                        ToastNotifi('Mã OTP không đúng, vui lòng nhập lại');
                      }
                    },
                    child: Text("Xác nhận mã OTP")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

  

  
