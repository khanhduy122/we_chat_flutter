import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/conpoment/app_asset.dart';
import 'package:we_chat/model/massage.dart';
import 'package:we_chat/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis{

  static User get user => FirebaseAuth.instance.currentUser!;
  
  static FirebaseStorage storage = FirebaseStorage.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static late UserProfile me;

  

  static Future<bool> userExists()async{
    return (await FirebaseFirestore.instance.collection('users_profile').doc(user.phoneNumber).get()).exists;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getProfileMe() async{
    return await FirebaseFirestore.instance.collection('users_profile').doc(user.phoneNumber).get();
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = UserProfile(
        id: user.uid,
        name: 'name',
        phone: user.phoneNumber,
        image: appAssets.imgAvatarDefauld,
        );

    return await firestore.collection('users_profile').doc(user.phoneNumber).set(chatUser.toJson());
    
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserChat(){
    return FirebaseFirestore.instance.collection('users_profile/${Apis.me.phone}/chats').snapshots();
  }

  static Future<void> UpdateProfileMe() async {
    await FirebaseFirestore.instance.collection('users_profile').doc(user.phoneNumber).update({'name': me.name});
  }

  static Future<void> UpdateProfilePictureMe(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${me.phone}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    me.image = await ref.getDownloadURL();
    await firestore.collection('users_profile').doc(me.phone).update({'image': me.image});

  }

static Future<void> sendPicture({required File file, required String friendPhone, required String userPhone}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('chat/${userPhone}_${friendPhone}/${time}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: ext == 'mp4' ? 'mp3' : 'image/$ext'));
    String msg = await ref.getDownloadURL();
    await Apis.sendMessage(friend: friendPhone, userPhone: userPhone, msg: msg, type: 'mp4');
  }



  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMassage({required String friendPhone, required String userPhone}){
    return FirebaseFirestore.instance.collection('users_profile/${userPhone}/chats/${friendPhone}/messages').orderBy('sent', descending: true).snapshots();
  }

  static Future<void> sendMessage({required String friend, required String userPhone, required String msg, required String type})async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message massageOnCurrentUsser = Message(
      fromid: userPhone,
      told: friend,
      msg: msg,
      read: '',
      type: type,
      sent: time
    );
    final Message massageOnFriend = Message(
      fromid: friend,
      told: userPhone,
      msg: msg,
      read: '',
      type: type,
      sent: time
    );
    await firestore.collection('users_profile/${Apis.me.phone}/chats/${friend}/messages').doc(time).set(massageOnCurrentUsser.toJson());
    await firestore.collection('users_profile/${friend}/chats/${Apis.me.phone}/messages').doc(time).set(massageOnCurrentUsser.toJson());
  }

  

  static Future<void> deleteMessage({required Message message, required String friendPhone, required String userPhone})async{
    if(message.type != "text"){
      storage.refFromURL(message.msg!).delete();
    }
    firestore.collection('users_profile/${userPhone}/chats/${friendPhone}/messages').doc(message.sent).delete();
    firestore.collection('users_profile/${friendPhone}/chats/${userPhone}/messages').doc(message.sent).delete();
  } 

  static Future<void> updateStatusMessage({required String friendPhone, required String userPhone, required Message message})async{
    firestore.collection('users_profile/$userPhone/chats/$friendPhone/messages')
             .doc(message.sent)
             .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastMessage({required String friendPhone, required String userPhone}){
    return FirebaseFirestore.instance.collection('users_profile/${userPhone}/chats/${friendPhone}/messages').orderBy('sent', descending: true).limit(1).snapshots();
  }


// request add friend.......................................................................................
  static Future<void> PutRequestAddFriend(UserProfile friend)async{
    final ref = firestore.collection('users_profile/${friend.phone}/request_friends');
    await ref.doc(me.phone).set(me.toJson());
  }

  static Future<void> DeleteRequestAddFriend({required String friendPhone, required String userPhone})async{
    firestore.collection('users_profile/${userPhone}/request_friends').doc(friendPhone).delete();
  } 

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllRequestAddFriend(){
    return FirebaseFirestore.instance.collection('users_profile/${Apis.me.phone}/request_friends').snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getProfileUserFriend(String friendPhone){
    return FirebaseFirestore.instance.collection('users_profile').doc(friendPhone).get();
  } 

  static Future<bool> checkIsSendRequestFriend(String friendPhone) async {
    final data = await firestore
        .collection('users_profile/${friendPhone}/request_friends')
        .doc(me.phone)
        .get();

    if(data.data() == null){
      return false;
    }else{
      return true;
    }
  }

  static Future<bool> checkActiveUser(String friendPhone) async {
    final data = await firestore
        .collection('users_profile')
        .doc(friendPhone)
        .get();

    if(data.data() == null){
      return false;
    }else{
      return true;
    }
  }

// friend........................................................................
  static Future<void> addFriend({ required UserProfile userFriend})async{
    await firestore.collection('users_profile/${me.phone}/friends').doc(userFriend.phone).set(userFriend.toJson());
    await firestore.collection('users_profile/${userFriend.phone}/friends').doc(me.phone).set(me.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFriend(){
    return FirebaseFirestore.instance.collection('users_profile/${me.phone}/friends').snapshots();
  }  

  static Future<bool> checkIsFriend(String friendPhone) async {
    final data = await firestore
        .collection('users_profile/${me.phone}/friends')
        .doc(friendPhone)
        .get();

    if(data.data() == null){
      return false;
    }else{
      return true;
    }
  }

  static Future<void> deleteFriend({required String friendPhone})async{
    await firestore.collection('users_profile/${me.phone}/friends').doc(friendPhone).delete();
    await firestore.collection('users_profile/${friendPhone}/friends').doc(me.phone).delete();
  } 

}