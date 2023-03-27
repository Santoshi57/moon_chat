import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moon_chat/common/firebase_instances.dart';
import 'package:moon_chat/providers/auth_provider.dart';
import 'package:moon_chat/viewpage/post_details.dart';
import 'package:moon_chat/viewpage/user_detail.dart';
import 'package:moon_chat/viewpage/widgets/add_notes.dart';
import 'package:moon_chat/viewpage/widgets/comments.dart';
import 'package:moon_chat/viewpage/widgets/exit_dialog.dart';
import 'package:moon_chat/viewpage/widgets/update_post.dart';
import '../common/snackshow.dart';
import '../providers/crud_provider.dart';
import '../providers/toggleprovider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../services/crud_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';



class FeedPage extends ConsumerStatefulWidget {


  @override
  ConsumerState<FeedPage> createState() => _FeedPage();
}

class _FeedPage extends ConsumerState<FeedPage> {




  final _form = GlobalKey<FormState>();

  late String userName;
  late types.User loginUser;






  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final captionController = TextEditingController();

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {



    final image=ref.watch(imageProvider);

    final user = ref.watch(userStream(auth!));

    final postData = ref.watch(postStream);

    ref.listen(crudProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }
    });
    user.when(
        data: (data){
          userName = data.firstName!;
          loginUser = data;
        },
        error: (err, stack) => Text('$err'),
        loading: () => Center(child: CircularProgressIndicator())
    );

    return WillPopScope(
      onWillPop: () async => showExitPopup(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black38,

        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Get.to(()=>UserDetail(loginUser));
              },
                child: user.when(
                  data: (data) {
                    userName = data.firstName!;
                    loginUser = data;
                    return ListView(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(data.imageUrl!),
                              ),

                            ],
                          ),
                        ]);
                  },   error: (err, stack) => Text('$err'),
                       loading: () => Center(child: CircularProgressIndicator()),),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context){
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: AlertDialog(
                            backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),

                            title: Center(child: Text('Do you want to Log Out?')),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(onPressed: (){
                                  ref.read(authProvider.notifier).userLogOut();
                                  Navigator.pop(context);
                                }, child: Text('Yes',style: TextStyle(color: Colors.purple)),),
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text('No',style: TextStyle(color: Colors.purple))),

                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
                child: Icon(
                  Icons.logout, color: Colors.white54, size: 25.w,),
              ),
            )
          ],
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/default.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       height: 140.h,
                  //       width: 380.w,
                  //
                  //       decoration: new BoxDecoration(
                  //           color: Colors.black.withOpacity(0.5)),
                  //
                  //     ),
                  //   ),
                  // ),

                  Expanded(
                    child: Center(
                      child: postData.when(
                          data: (data){

                            return ListView.builder(
                              //scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context,index){
                                  final post = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: Container(
                                              decoration: new BoxDecoration(
                                                  color: Colors.black.withOpacity(0.8)),
                                              height: 420.h,
                                              width: 380.w,


                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20.0,top:15,bottom: 15),
                                                          child: Text(post.caption,style: TextStyle(color: Colors.white,fontSize: 20.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                                        ),

                                                        // MENU...
                                                         Padding(
                                                          padding: const EdgeInsets.only(right: 8.0),
                                                          child:

                                                          auth == post.userId? IconButton(
                                                              onPressed: (){
                                                                Get.defaultDialog(
                                                                    backgroundColor: Colors.black,
                                                                    title: 'Menu',
                                                                    content: Column(
                                                                      children: [
                                                                        Divider(
                                                                          height: 0,
                                                                          color: Colors.white38,
                                                                        ),
                                                                        InkWell(
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (_){
                                                                                  return UpdateCaption(post);
                                                                                }
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 15.0),
                                                                                child: Text('Edit'),
                                                                              ),
                                                                              IconButton(
                                                                                  onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (_){
                                                                                          return UpdateCaption(post);
                                                                                        }
                                                                                    );
                                                                                  }, icon: Icon(Icons.edit,color: Colors.purple,)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          height: 0,
                                                                          color: Colors.white38,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:(){

                                                                            Navigator.pop(context);
                                                                            Get.defaultDialog(
                                                                              title: '',
                                                                              backgroundColor: Colors.black,
                                                                              content: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Text('Are You Sure?'),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        TextButton(
                                                                                            style: TextButton.styleFrom(
                                                                                                backgroundColor: Colors.purple
                                                                                            ),
                                                                                            onPressed: (){
                                                                                              ref.read(crudProvider.notifier).delPost(
                                                                                                  postId: post.id,
                                                                                                  imageId: post.imageId
                                                                                              ).then((value) => Navigator.pop(context));

                                                                                            }, child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                                                        TextButton(
                                                                                            style: TextButton.styleFrom(
                                                                                                backgroundColor: Colors.purple
                                                                                            ),
                                                                                            onPressed: (){
                                                                                              Navigator.pop(context);
                                                                                            }, child: Text('No',style: TextStyle(color: Colors.white)))
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),

                                                                            );

                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 15.0),
                                                                                child: Text('Delete'),
                                                                              ),
                                                                              IconButton(
                                                                                  onPressed: (){
                                                                                    Navigator.pop(context);
                                                                                    Get.defaultDialog(
                                                                                      title: '',
                                                                                      backgroundColor: Colors.black,
                                                                                      content: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Text('Are You Sure?'),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                TextButton(
                                                                                                    style: TextButton.styleFrom(
                                                                                                        backgroundColor: Colors.purple
                                                                                                    ),
                                                                                                    onPressed: (){
                                                                                                      ref.read(crudProvider.notifier).delPost(
                                                                                                          postId: post.id,
                                                                                                          imageId: post.imageId
                                                                                                      ).then((value) => Navigator.pop(context));

                                                                                                    }, child: Text('Yes',style: TextStyle(color: Colors.white),)),
                                                                                                TextButton(
                                                                                                    style: TextButton.styleFrom(
                                                                                                        backgroundColor: Colors.purple
                                                                                                    ),
                                                                                                    onPressed: (){
                                                                                                      Navigator.pop(context);
                                                                                                    }, child: Text('No',style: TextStyle(color: Colors.white)))
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),

                                                                                    );


                                                                                  }, icon: Icon(Icons.delete,color: Colors.purple,)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                );
                                                              },
                                                              icon: Icon(Icons.more_horiz_rounded,color: Colors.white,)):null,
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 0,
                                                      color: Colors.white38,
                                                    ),
                                                        Align(
                                                        alignment: Alignment.center,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: InkWell(
                                                            onTap: (){
                                                              Get.to(()=>PostPage(post, loginUser));

                                                            },
                                                            child: CachedNetworkImage(
                                                              imageUrl: post.imageUrl,
                                                              fit: BoxFit.cover,
                                                              width: 300.w,
                                                              height: 300.h,),
                                                          ),
                                                        )
                                                    ),
                                                    Divider(
                                                      height: 0,
                                                      color: Colors.white38,
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: (){
                                                                  if(post.like.usernames.contains(userName)){
                                                                    SnackShow.showFailure(context, 'You have already like this post');
                                                                  }else{
                                                                    ref.read(loginProvider.notifier).change();
                                                                    post.like.usernames.add(userName);
                                                                    ref.read(crudProvider.notifier).addLike(
                                                                        username: post.like.usernames,
                                                                        like: post.like.likes,
                                                                        postId: post.id
                                                                    );
                                                                  }

                                                                }, icon:
                                                            post.like.likes != 0?
                                                            Icon(Ionicons.heart,color: Colors.purple,):
                                                            Icon(Ionicons.heart_outline,color: Colors.purple)
                                                            ),
                                                            if(post.like.likes != 0)    Text('${post.like.likes}')
                                                          ],
                                                        ),

                                                        IconButton(onPressed: (){

                                                          // Get.to(()=> DetailPage(post, loginUser));

                                                          showDialog(
                                                              context: context,
                                                              builder: (_){
                                                                return DetailPage(post, loginUser);
                                                              }
                                                          );
                                                        }, icon: Icon(LineIcons.comments,color: Colors.purple,))



                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          error: (err,stack)=>Center(child: Text('$err')),
                          loading: ()=>Center(child: CircularProgressIndicator()
                          )
                      ),
                    ),
                  ),



                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.black),
                      width: 380.w,
                      height: 125.h,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 15,top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 50.h,
                                width: 350.w,
                                child: Stack(
                                  children:[ Form(
                                    key: _form,
                                    child: TextFormField(

                                        controller: captionController,
                                        validator:(val){
                                          if(val!.isEmpty){
                                            return '';
                                          }
                                          else if(val.length>50){
                                            return 'maximum character exceeded';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Colors.white,fontSize: 20.sp),

                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top:0,left: 10,bottom: 0,right: 40),
                                            enabledBorder: OutlineInputBorder(),

                                            fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                                            filled: true,
                                            hintText: 'Add a post', hintStyle: TextStyle(color: Colors.grey,fontSize: 20.sp)
                                        )
                                    ),
                                  ),
                                    image == null ? Positioned(
                                      right: 10.w,
                                      bottom: 15,
                                      child:  InkWell(
                                          onTap: (){
                                            ref.read(imageProvider.notifier).pickAnImage();
                                          },
                                          child:Icon(Icons.add_photo_alternate_outlined)
                                      ),
                                    ):
                                    Positioned(
                                        right: 5.w,
                                        bottom: 6.h,
                                        child: InkWell(
                                          onTap: (){
                                            ref.read(imageProvider.notifier).pickAnImage();
                                          },
                                            child: Image.file(File(image.path),width: 40.w,height: 40.h,fit: BoxFit.cover,))),




                                  ]
                                ),
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.1)
                                  ),
                                  onPressed: (){
                                    _form.currentState!.save();

                                    if(_form.currentState!.validate()) {
                                      if(image == null){
                                        SnackShow.showFailure(context, 'Please select an image');
                                      }
                                      else{
                                        ref.read(crudProvider.notifier).addPost(
                                            userId: uid,
                                            caption: captionController.text.trim(),
                                            image: image
                                        ).then((image) => ref.invalidate(imageProvider));
                                        captionController.clear();
                                        FocusScope.of(context).unfocus();

                                      }

                                    }
                                  }, child:
                              Text('Post',style: TextStyle(fontSize: 18.sp,color: Colors.white),)),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),





                  SizedBox(
                      height: 55.h
                  )

      ]
            ),
          ),
        ),
      ),
    );

  }

}

