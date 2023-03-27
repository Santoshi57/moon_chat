import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moon_chat/providers/note_provider.dart';
import 'package:moon_chat/services/note_service.dart';
import 'package:moon_chat/viewpage/user_detail.dart';
import 'package:moon_chat/viewpage/widgets/add_notes.dart';
import 'package:moon_chat/viewpage/widgets/tranisition.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../common/firebase_instances.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import 'chat_page.dart';


class LockedPage extends ConsumerWidget {



  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  late String userName;
  late types.User loginUser;


  final auth = FirebaseInstances.firebaseAuth.currentUser?.uid;


  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;
  @override
  Widget build(BuildContext context, ref) {

    final user = ref.watch(userStream(auth!));
    user.when(
        data: (data){
          userName = data.firstName!;
          loginUser = data;
        },
        error: (err, stack) => Text('$err'),
        loading: () => Center(child: CircularProgressIndicator())
    );
    final noteData= ref.watch(noteStream);
    final users = ref.watch(usersStream);
    return WillPopScope(
      onWillPop: () async { return false;},
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
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
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/userdetail.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70.h,
                  ),

                  Container(

                    height: 240.h,
                    width: double.infinity,
                    child:  Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 300.h,
                            width: 350.w,
                            color: Colors.black.withOpacity(0.5),

                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Center(child: Text('Games')))),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  Container(

                    height: 100.h,
                    width: double.infinity,
                    child:  Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 100.h,
                            width: 350.w,
                            color: Colors.black.withOpacity(0.5),

                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Center(child: Text('Music Player')))),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 90.h,
                      width: 350.w,
                      color: Colors.black.withOpacity(0.5),
                      child: users.when(
                          data: (data){
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      onTap: (){
                                        Get.to(() => UserDetail(data[index]), transition: Transition.leftToRight);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: CachedNetworkImageProvider(data[index].imageUrl!),
                                            ),


                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            );
                          },
                          error: (err, stack) => Center(child: Text('$err')),
                          loading: () => Container()
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  Container(
                    width: 350.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(

                          height: 230.h,
                          // width: double.infinity,
                          child:  Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  height: 100.h,
                                  width: 50.w,


                                  ),
                            ),
                          ),
                        ),

                        Container(

                          height: 250.h,
                          // width: double.infinity,
                          child:  Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  height: 250.h,
                                  width: 190.w,
                                  color: Colors.black.withOpacity(0.5),

                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Stack(
                                        children:[
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Notes',style: TextStyle(fontSize: 20.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: (){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AddNotes(loginUser)
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(Icons.add),
                                              ),
                                            )
                                          ),

                                          Center(
                                            child: Container(
                                              height: 180.h,
                                              width: 170.w,
                                              // color: Colors.black,
                                              child: noteData.when(
                                                  data: (data){

                                                    return Swiper(
                                                      loop: false,
                                                        viewportFraction: 1,
                                                        scale: 0.9,
                                                        itemCount: data.length,
                                                        itemBuilder: (context,index) {
                                                          final notes = data[index];
                                                          return  InkWell(
                                                            onLongPress: (){
                                                              showDialog(context: context, builder: (context){

                                                                return BackdropFilter(
                                                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                                  child: AlertDialog(
                                                                    backgroundColor: Colors.black,
                                                                    title: Center(child: Text('Menu',style: TextStyle(fontSize: 25.sp),),),

                                                                    content: Container(
                                                                      height: 100.h,
                                                                      child: Column(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:(){

                                                                              Navigator.pop(context);
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (context){
                                                                                    return UpdateNotes(notes);
                                                                                  }
                                                                              );
                                                                            },
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text('Edit'),
                                                                                  Icon(Icons.edit)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            thickness: 1,
                                                                            height: 15.h,
                                                                          ),
                                                                          InkWell(
                                                                            onTap: (){
                                                                              ref.read(noteProvider.notifier).delNote(
                                                                                  noteId: notes.id).then((value) => Navigator.pop(context));
                                                                            },
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text('Delete'),
                                                                                  Icon(Icons.delete)
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],

                                                                      ),
                                                                    ),

                                                                  ),
                                                                );

                                                              });
                                                            },
                                                            child: Container(
                                                              width: 170.w,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [

                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(notes.dateTime,style: TextStyle(fontSize: 10.sp),),
                                                                      Container()
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20.h,
                                                                  ),
                                                                  Center(child: Text('\"  ${notes.notes}  \"',style: TextStyle(fontSize: 30.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),)),
                                                                  SizedBox(
                                                                    height: 10.h,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Container(),
                                                                      Text('-${notes.userName}',style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),)

                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });

                                                  },
                                                  error: (err, stack) => Text('$err'),
                                                  loading: () => Center(child: CircularProgressIndicator()))



                                            ),
                                          )
                                        ]),
                                  )
                          ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 60.h,
                  ),
                ],
              )
      ),
          )),
    );
  }



}