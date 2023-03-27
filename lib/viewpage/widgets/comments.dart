import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../model/post_state.dart';
import '../../providers/crud_provider.dart';
import '../../services/crud_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class DetailPage extends ConsumerWidget {


  final Post post;
  final types.User user;
  DetailPage(this.post, this.user);

  final _form = GlobalKey<FormState>();

  final commentController = TextEditingController();

  @override
    Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
          title: Text('Comments',style: TextStyle(color: Colors.white,fontSize: 25.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),

          backgroundColor: Colors.black,
          content: Container(
            width: 300.w,
            height: 500.h,
            color: Colors.black26,
            child: Column (
                mainAxisSize: MainAxisSize.max,
                children: [


                  Expanded(
                    child: postData.when(
                        data: (data){

                          final userPost = data.firstWhere((element) => element.id == post.id);
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: userPost.comments.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      color: Colors.white10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          // tileColor: Colors.white12,
                                          title: Text(e.comment,style: TextStyle(color: Colors.white,fontSize: 25.sp,fontWeight: FontWeight.bold)),
                                          subtitle:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),

                                              Divider(
                                                // thickness: 1,
                                                height: 1,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(e.username,style: TextStyle(color: Colors.purple,fontStyle: FontStyle.italic,fontSize: 18.sp)),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(e.dateTime,style: TextStyle(color: Colors.white),)


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },

                          );},
                        error: (err, stack) => Text('$err'),
                        loading: () => CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  Stack(
                      children: [ Form(
                        key: _form,
                        child: TextFormField(
                          controller: commentController,
                          validator: (val){

                            if(val!.isEmpty){
                              return '';
                            }
                            return null;
                          },

                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 10,left: 10,bottom: 10,right: 60),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey)
                              ),
                              hintText: 'Comment...',
                              hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal)
                          ),

                        ),
                      ),

                        Positioned(
                            right: 1,
                            child: TextButton(
                              onPressed: (){
                                FocusScope.of(context).unfocus();
                                if(_form.currentState!.validate()){
                                  if(commentController.text.trim().isEmpty){
                                    return null;
                                  }
                                  else{
                                    DateTime now = DateTime.now();
                                    String formattedDate = DateFormat('MMM d, h:mm a').format(now);
                                    ref.read(crudProvider.notifier).addComment(
                                        comments: [...post.comments, Comment(
                                            username: user.firstName!,
                                            comment: commentController.text.trim(),
                                            dateTime: formattedDate
                                        )],
                                        postId: post.id
                                    );

                                    commentController.clear();
                                    // Navigator.pop(context);

                                  }
                                }
                              },
                              child: Text('Send'),
                            )
                        )

                      ]
                  ),



                ]),
          )),

    );

  }
}




