import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/conpoment/app_color.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/model/netword.dart';
import 'package:we_chat/model/user.dart';
import 'package:we_chat/view/home_screen.dart';
import 'package:we_chat/view/user_screen.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({super.key});
  

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String? _imageFromFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: Apis.getProfileMe(),
        builder: (context, snapshot) {
          if(snapshot.hasError)
            return Center(child: CircularProgressIndicator(),);
          
          if(snapshot.hasData){

            Apis.me = UserProfile.fromJson(snapshot.data!.data()!);

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Container(
                    height: 150,
                    child: Stack(
                      children: [
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
                          top: 100,
                          left: size.width-160,
                          child: GestureDetector(
                            onTap: (){
                              _showBottomSheet();
                            },
                            child: Icon(Icons.camera_alt, color: appColors.black, size: 40,)
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24,),
                  Form(
                    key: _formKey,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: _textController,
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Không được bỏ trống';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              label: Text('Name')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  ElevatedButton(
                    onPressed: (){
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            Apis.me.name = _textController.text;
                            Apis.UpdateProfileMe();
                            ToastSuccess('Cập nhật thành công');
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage(),), (route) => false);
                          });
                          //Navigator.pu
                        }
                    }, 
                    child: Text('Cập Nhật',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  )
                ],
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      )
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
                            setState(() {
                              Apis.me.image = _imageFromFile;
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
                            setState(() {
                              Apis.me.image = _imageFromFile;
                            });
                            await Apis.getProfileMe();
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