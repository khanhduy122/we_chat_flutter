import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/view/login_screen.dart';
import '../conpoment/app_asset.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  var _formKey = GlobalKey<FormState>();
  String? _imageFromFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    _showBottomSheet();
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: appColors.secondColor
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
                    });
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: Icon(Icons.logout, color: Colors.red,),
                  ),
                ),
                Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: Apis.me.image == appAssets.imgAvatarDefauld ?
                    BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(appAssets.imgAvatarDefauld),
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(75)
                    ): _imageFromFile == null ?
                    BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(Apis.me.image!),
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(75)
                    ): BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(_imageFromFile!)),
                        fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(75)
                    )
                  )
                ),
                Positioned(
                  top: 190,
                  left: size.width-170,
                  child: GestureDetector(
                    onTap: (){
                      _showBottomSheet();
                    },
                    child: Icon(Icons.camera_alt, color: appColors.black, size: 40,)
                  )
                ),
                SizedBox(height: 24,),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 200, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Apis.me.name!,
                          style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialogEditName(context);
                            
                          },
                          child: Container(
                            height: 20,
                            margin: EdgeInsets.only(left: 10),
                            child: Image.asset(appAssets.iconPen, fit: BoxFit.fill,),
                          ),
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

  void showDialogEditName(BuildContext context){

    String newName = Apis.me.name!;

    showDialog(
      context: context, 
      builder: (context) => Dialog(
        child: Form(
          key: _formKey,
          child: Container(
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  initialValue: Apis.me.name,
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Không được bỏ trống';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      newName = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Name')
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 60,
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('Hủy',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()) {
                            setState(() {
                              Apis.me.name = newName;
                              Apis.UpdateProfileMe();
                              Navigator.pop(context);
                              ToastSuccess('Cập nhật thành công');
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 60,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text('Svae',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(){
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
          height: 200,
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Text('Chọn ảnh từ',
                style: TextStyle(color: appColors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                          if(image != null){
                            setState(() {
                               _imageFromFile = image.path;
                              Apis.UpdateProfilePictureMe(File(_imageFromFile!));
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Image.asset(appAssets.iconCamera, fit: BoxFit.fill,),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                          if(image != null){
                            setState(() {
                               _imageFromFile = image.path;
                              Apis.UpdateProfilePictureMe(File(_imageFromFile!));
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                        child: Image.asset(appAssets.iconAddImage, fit: BoxFit.fill,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

ToastSuccess(String title){
  Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0
  );
}






