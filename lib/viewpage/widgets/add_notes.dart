import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moon_chat/providers/note_provider.dart';

import '../../common/firebase_instances.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../common/snackshow.dart';
import '../../model/post_state.dart';




class AddNotes extends ConsumerWidget {

  final types.User user;
  AddNotes(this.user);

  final _form = GlobalKey<FormState>();

  final noteController = TextEditingController();
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;
  final username = FirebaseInstances.firebaseAuth.currentUser!.displayName;

  @override
  Widget build(BuildContext context,ref) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Add a Note'),
        content: Container(
          child: Form(
            key: _form,
            child: TextFormField(

                controller: noteController,
                validator:(val){
                  if(val!.isEmpty){
                    return 'Field is Empty';
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
                    hintText: '...', hintStyle: TextStyle(color: Colors.grey,fontSize: 20.sp)
                )
            ),
          ),
        ),
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blueAccent
              ),
              onPressed: (){
                _form.currentState!.save();

                if(_form.currentState!.validate()) {
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('MMM d').format(now);

                    ref.read(noteProvider.notifier).addNote(
                        notes: noteController.text.trim(),
                        userId: uid,
                        userName: user.firstName!,
                        dateTime: formattedDate
                    ).then((value) => Navigator.pop(context));


              }}, child:
          Text('Post',style: TextStyle(fontSize: 18.sp,color: Colors.white),)),
          TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1)
              ),
              onPressed: (){
                Navigator.pop(context);
                }, child:
          Text('Cancel',style: TextStyle(fontSize: 18.sp,color: Colors.white),))



        ],
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}

class UpdateNotes extends ConsumerStatefulWidget {



  final Notes notes;
  UpdateNotes(this.notes);

  @override
  ConsumerState<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends ConsumerState<UpdateNotes> {

  TextEditingController noteController2 = TextEditingController();

  final _form1 = GlobalKey<FormState>();

  final uid1 = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  void initState() {
    noteController2..text = widget.notes.notes;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(noteProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'succesfully added');
        Get.back();
      }
    });

    final crud1 =ref.watch(noteProvider);
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
                          controller: noteController2,
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

              ref.read(noteProvider.notifier).updateNote(
                  notes: noteController2.text.trim(),
                  noteId: widget.notes.id);
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
