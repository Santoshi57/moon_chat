import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/firebase_instances.dart';
import '../../common/snackshow.dart';
import '../../providers/crud_provider.dart';
import '../../providers/toggleprovider.dart';

class Feed extends ConsumerStatefulWidget {

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {

  final captionController = TextEditingController();

  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;





  @override
  Widget build(BuildContext context) {
    final image=ref.watch(imageProvider);
    final crud =ref.watch(crudProvider);
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
                  child: Text('New Post',style: TextStyle(fontSize: 25.sp),)),
              Divider(
                color: Colors.white30,  //color of divider
                thickness: 1, //thickness of divider line
                // indent: 10, //Spacing at the top of divider.
                // endIndent: 10, //Spacing at the bottom of divider.
              ),
              Stack(
                  children: [
                    Form(
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
                              hintText: 'Caption', hintStyle: TextStyle(color: Colors.grey,fontSize: 20.sp)
                          )
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      bottom: 15,
                      child:  InkWell(
                          onTap: (){
                            ref.read(imageProvider.notifier).pickAnImage();
                          },
                          child: Icon(Icons.add_photo_alternate_outlined)
                      ),
                    ),

                  ]
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                child: image == null  ? Container(): Image.file(File(image.path),width: 100.w,height: 100.h,),
              ),

            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          TextButton(onPressed: (){
            _form.currentState!.save();
            FocusScope.of(context).unfocus();
            if(_form.currentState!.validate()) {
              if(image == null){
                SnackShow.showFailure(context, 'please select an image');
              }
              else{
                ref.read(crudProvider.notifier).addPost(
                    userId: uid,
                    caption: captionController.text.trim(),
                    image: image
                ).then((image) => ref.invalidate(imageProvider));
                Navigator.pop(context);

              }

            }
          }, child:
            Text('Post',style: TextStyle(fontSize: 20.sp,color: Colors.white),)),


          TextButton(onPressed: (){
            Navigator.pop(context);
            ref.invalidate(imageProvider);
          }, child: Text('Cancel',style: TextStyle(fontSize: 20.sp,color: Colors.white))),
        ],
      ),
    );
  }
}
