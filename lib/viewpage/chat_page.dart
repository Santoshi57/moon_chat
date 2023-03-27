import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moon_chat/common/firebase_instances.dart';
import 'package:moon_chat/providers/room_provider.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:dio/dio.dart';
import 'package:moon_chat/viewpage/locked_page.dart';

import 'homepage.dart';

class ChatPage extends ConsumerWidget{
final types.Room room;
final String token;
final String username;
ChatPage(this.room, this.token,this.username);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageData= ref.watch(messageStream(room));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: (){
              Get.to(()=> HomePage());
            },
            child: Icon(Icons.arrow_back_ios_new,color: Colors.white,))
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/chat.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          messageData.when(
              data: (data) => Chat(
                theme: DarkChatTheme(
                  inputBackgroundColor: Colors.black,
                  inputTextColor: Colors.white,
                  inputTextStyle: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),
                  backgroundColor: Colors.transparent,
                  sentMessageBodyTextStyle: TextStyle(color:Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,),
                  primaryColor: Color(0xfff0a8476),
                  secondaryColor: Color(0xfffae3d3b),
                  receivedMessageBodyTextStyle: TextStyle(color:Colors.white,fontSize: 18.sp,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                ),
                messages: data,
                // showUserAvatars: true,
                onSendPressed: (PartialText val) async {
                  final dio = Dio();

                  try{
                    final response = await dio.post('https://fcm.googleapis.com/fcm/send',
                        data: {
                          "notification": {
                            "title": username,
                            "body": val.text,
                            "android_channel_id": "High_importance_channel"
                          },
                          "to": token
                        }, options: Options(
                            headers: {
                              HttpHeaders.authorizationHeader : 'key=AAAAfKIyvhA:APA91bGDcR71oPnkN365m0-ijqlq6phX6oa-P5mv910ydtj9EySxwPuu2_dCwAEEedwNyEhGVDDMLHC-tMJezd-S8yzg_uOra0UyNWT0aUR2K-UUEfxKLqIfQx-xrjQsRwCNXpu6VBZP'
                            }
                        )
                    );
                    print(response.data);

                  }on FirebaseException catch (err){
                    print(err);
                  }


                  FirebaseInstances.firebaseChatCore.sendMessage(val, room.id);

                },
                user: types.User(
                  id: FirebaseInstances.firebaseChatCore.firebaseUser!.uid,
                ),
                onAttachmentPressed: ()async{
                  final _pick = ImagePicker();
                  await _pick.pickImage(source: ImageSource.gallery).then((value) async{
                    if(value != null){
                      final imageId = DateTime.now().toString();
                      final ref = FirebaseInstances.firebaseStorage.ref().child('chatImage/$imageId');
                      await ref.putFile(File(value.path));
                      final url = await ref.getDownloadURL();
                      final size = File(value.path).lengthSync();
                      final message = types.PartialImage(
                        size: size,
                        name: value.name,
                        uri: url
                      );
                      FirebaseInstances.firebaseChatCore.sendMessage(message, room.id);

                    }
                  } );
                },
              ),
              error: (err, stack) => Text('$err'),
              loading: () => CircularProgressIndicator()),
        ],

      )
    );
  }
}

