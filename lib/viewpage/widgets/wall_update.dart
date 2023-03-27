import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moon_chat/providers/wall_provider.dart';

import '../../common/firebase_instances.dart';
import '../../common/snackshow.dart';
import '../../model/post_state.dart';
import '../../providers/toggleprovider.dart';



class WallUpdate extends  ConsumerStatefulWidget {

  final Wall wall;
  WallUpdate(this.wall);
  @override
  ConsumerState<WallUpdate> createState() => _WallUpdateState();
}

class _WallUpdateState extends ConsumerState<WallUpdate> {

  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    ref.listen(wallProvider, (previous, next) {
      if(next.errorMessage.isNotEmpty){
        SnackShow.showFailure(context, next.errorMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, 'Successfully Changed');
        Get.back();
      }
    });

    final image = ref.watch(imageProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,


      body:  WillPopScope(
        onWillPop: () async =>false,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Align(
                alignment: Alignment.center,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    // color: Colors.red,
                    width: 250.w,
                    // height: 400.h,
                    child: Column(
                      children: [

                        InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pickAnImage();
                          },
                          child: Container(
                            height: 400.h,
                            // color: Colors.white,
                            child: image == null ? Image.network(widget.wall.imageUrl,fit: BoxFit.cover,) : Image.file(File(image.path,),fit: BoxFit.cover,),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white
                            ),
                            onPressed: () {

                                if(image == null){
                                  SnackShow.showFailure(context, 'Add a image');
                                }else{
                                  ref.read(wallProvider.notifier).updateWall(
                                      wallId: widget.wall.id,
                                      image: image,
                                      imageId: widget.wall.imageId).then((value) => ref.invalidate(imageProvider));

                                }
                            },
                            child: Text('SET', style: TextStyle(fontSize: 20.sp),)),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white
                              ),
                              onPressed: () {
                                ref.invalidate(imageProvider);
                                Get.back();
                              },
                              child: Text('CANCEL', style: TextStyle(fontSize: 20.sp),)),
                        ),




                      ],
                    ),
                  ),
                ),
              ),
            ),


          ],

        ),
      ),
    );

  }
}
