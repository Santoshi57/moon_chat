import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/firebase_instances.dart';
import '../../common/snackshow.dart';
import '../../model/post_state.dart';
import '../../providers/crud_provider.dart';
import '../../providers/toggleprovider.dart';






class UpdateCaption extends ConsumerStatefulWidget {



  final Post post;
  UpdateCaption(this.post);

  @override
  ConsumerState<UpdateCaption> createState() => _UpdateCaptionState();
}

class _UpdateCaptionState extends ConsumerState<UpdateCaption> {

  TextEditingController captionController2 = TextEditingController();

  final _form1 = GlobalKey<FormState>();

  final uid1 = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  void initState() {
    captionController2..text = widget.post.caption;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(crudProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'succesfully added');
        Get.back();
      }
    });

    final crud1 =ref.watch(crudProvider);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
        content: Container(
          // height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Edit',style: TextStyle(color: Colors.white,fontSize: 25.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                  )),
              Divider(
                color: Colors.white30,  //color of divider
                thickness: 1,
              ),
              Stack(
                  children: [
                    Form(
                      key: _form1,
                      child: TextFormField(
                          controller: captionController2,
                          validator:(val){
                            if(val!.isEmpty){
                              return '';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white,fontSize: 20.sp),

                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top:0,left: 10,bottom: 0,right: 40),
                              enabledBorder: OutlineInputBorder(),
                              fillColor: Color.fromRGBO(255, 255, 255, 0.2),
                              filled: true,
                              hintText: 'Edit...', hintStyle: TextStyle(color: Colors.grey,fontSize: 20.sp)
                          )
                      ),
                    ),


                  ]
              ),


            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(onPressed: (){
            _form1.currentState!.save();
            FocusScope.of(context).unfocus();
            if(_form1.currentState!.validate()) {

              ref.read(crudProvider.notifier).updatePost(
                  caption: captionController2.text.trim(),
                  postId: widget.post.id);
              Navigator.pop(context);



            }
          }, child: crud1.isLoad? Center(child: CircularProgressIndicator(),) :
          Text('Update',style: TextStyle(fontSize: 20.sp,color: Colors.purple,fontWeight: FontWeight.bold),)),


          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel',style: TextStyle(fontSize: 20.sp,color: Colors.purple,fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
