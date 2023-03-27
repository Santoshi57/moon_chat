import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../common/firebase_instances.dart';
import '../common/snackshow.dart';
import '../model/post_state.dart';
import '../providers/auth_provider.dart';
import '../providers/crud_provider.dart';
import '../providers/toggleprovider.dart';
import '../services/crud_service.dart';


class PostPage extends ConsumerStatefulWidget {


  final Post post;
  final types.User user;

  PostPage(this.post, this.user);

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final _form = GlobalKey<FormState>();

  late String userName;

  late types.User loginUser;

  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    final user = ref.watch(userStream(auth!));
    user.when(
        data: (data){
          userName = data.firstName!;
          loginUser = data;
        },
        error: (err, stack) => Text('$err'),
        loading: () => Center(child: CircularProgressIndicator())
    );

    final postData = ref.watch(postStream);
    return Scaffold(
      backgroundColor: Colors.black,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0,right: 12,left: 12),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.post.imageUrl)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.post.caption,style: TextStyle(color: Colors.white,fontSize:30.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              if(widget.post.like.usernames.contains(userName)){
                                SnackShow.showFailure(context, 'You have already like this post');
                              }else{
                                ref.read(loginProvider.notifier).change();
                                widget.post.like.usernames.add(userName);
                                ref.read(crudProvider.notifier).addLike(
                                    username: widget.post.like.usernames,
                                    like: widget.post.like.likes,
                                    postId: widget.post.id
                                );
                              }

                            }, icon: widget.post.like.likes!=0? Icon(Ionicons.heart,color: Colors.blueAccent,size:30.sp,):
                        Icon(Ionicons.heart_outline,color: Colors.blueAccent,size:30.sp)),
                        if(widget.post.like.likes != 0)    Text('${widget.post.like.likes}')

                      ],
                    ),
                  ),
                ],
              ),
            ),

            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300.w,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12,top: 8),
                    child: Form(
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
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
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
                              comments: [...widget.post.comments, Comment(
                                  username: userName,
                                  comment: commentController.text.trim(),
                                  dateTime: formattedDate
                              )],
                              postId: widget.post.id
                          );

                          commentController.clear();
                          // Navigator.pop(context);

                        }
                      }
                    },
                    child: Text('Send',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
            postData.when(
                data: (data){
                  final userPost = data.firstWhere((element) => element.id == widget.post.id);
                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: userPost.comments.map((e) {
                        return Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(e.username,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold)),
                                SizedBox(width: 10.w,),
                                Text(e.dateTime,style: TextStyle(fontSize: 12.sp,fontStyle: FontStyle.italic),)
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(e.comment,style: TextStyle(fontSize: 25.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                error: (err, stack) => Text('$err'),
                loading: () => CircularProgressIndicator()
            )
          ],
        )
    );
  }
}