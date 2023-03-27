import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moon_chat/common/snackshow.dart';
import 'package:moon_chat/services/crud_service.dart';
import 'package:moon_chat/viewpage/post_details.dart';
import 'package:moon_chat/viewpage/widgets/tranisition.dart';
import 'package:moon_chat/viewpage/widgets/wall_update.dart';
import '../common/firebase_instances.dart';
import '../providers/room_provider.dart';
import '../services/wall_service.dart';
import 'chat_page.dart';


class UserDetail extends ConsumerWidget {


  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;


  final types.User user;
  UserDetail(this.user);



  @override
  Widget build(BuildContext context, ref) {
    final wallData = ref.watch(wallStream);
    final postData = ref.watch(postStream);




    return Scaffold(
      // extendBodyBehindAppBar: true,
      body:wallData.when(
          data: (data){

            final userWall = data.where((element) => element.userId == user.id).toList();

            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context,index){
                  final wall = userWall[0];
                  return Stack(
                      children:[

                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 820.h,
                            width: 390.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(userWall[0].imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),


                        Container(
                          // decoration: new BoxDecoration(
                          //     color: Colors.black.withOpacity(0.7)),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white,),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(user.firstName!,style: TextStyle(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.bold),),
                                  )

                                ],
                              ),
                              auth==user.id? InkWell(
                                onTap: (){ showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        backgroundColor: Colors.black,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                  SnackShow.showFailure(context, 'Coming soon...');
                                                },
                                                child: Text('Change Profile Picture',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Divider(
                                                thickness: 1,
                                                color: Colors.white,
                                              ),
                                            ),

                                            InkWell(
                                                onTap:(){

                                                  Navigator.pop(context);
                                                  Get.to(()=>WallUpdate(wall));

                                                },
                                                child: Text('Change Wallpaper',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),)),

                                          ],
                                        ),
                                      );
                                    }
                                );

                                },

                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:  Icon(Icons.more_vert_rounded,color: Colors.white,),
                                ),
                              ): InkWell(
                                onTap: () async {


                                  final response = await ref.read(roomProvider).roomCreate(user);
                                  if(response != null){
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        CupertinoRoute(exitPage: UserDetail(user), enterPage: ChatPage(response, user.metadata!['token'], user.firstName!))
                                    );

                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Icon(Ionicons.chatbubble_ellipses,color: Colors.white,),
                                ),
                              )
                            ],
                          ),
                        ),




                        Column(

                          children: [



                            SizedBox(
                              height: 70.h,
                            ),
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(user.imageUrl!),
                                  ),
                                  SizedBox(height: 10.h,),
                                ],
                              ),
                            ),


                            Container(
                              // color: Colors.red,
                              height: 600.h,
                              width: double.infinity,
                              child: postData.when(
                                  data: (data){
                                    final userPost = data.where((element) => element.userId == user.id).toList();
                                    return GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: userPost.length,
                                        padding: EdgeInsets.only(top: 15.h),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                        itemBuilder: (context, index){
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  child: InkWell(
                                                    onTap: (){
                                                      Get.to(()=> PostPage(userPost[index], user));
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: userPost[index].imageUrl, fit: BoxFit.cover,),
                                                  ),

                                                )
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  error: (err, stack) => Text('$err'),
                                  loading: () => CircularProgressIndicator()
                              ),
                            )
                          ],
                        ),





                      ]);
                }
            );

          },
          error: (err, stack) => Text('$err'),
          loading: () => CircularProgressIndicator()),




    );
  }
}

