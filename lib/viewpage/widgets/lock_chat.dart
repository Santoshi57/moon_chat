import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/viewpage/feed_page.dart';
import '../../providers/auth_provider.dart';
import '../../providers/toggleprovider.dart';
import 'package:get/get.dart';

import '../homepage.dart';



class LockChat extends  ConsumerWidget {


  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context,ref) {
    final users = ref.watch(usersStream);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.2),
        content: Container(
          decoration: new BoxDecoration(
              color: Colors.transparent,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _form1,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  controller: passwordController,
                  validator: (val){

                    if(val!.isEmpty){
                      return 'Empty';
                    } else if (val != '1901'){
                      return 'Wrong Password';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 25.sp ,color: Colors.black,fontWeight: FontWeight.bold),

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                      hintText: 'Password...',
                      hintStyle: TextStyle(fontSize: 25.sp ,color: Colors.grey,fontWeight: FontWeight.bold)
                  ),

                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                // color: Colors.blue,
                height: 50.h,
                width: 200.w,
                child: users.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,

                                      ),
                                      onPressed: (){
                                    ref.read(loginProvider.notifier).change();

                                    FocusScope.of(context).unfocus();
                                    if(_form1.currentState!.validate()){
                                      if(passwordController.text.trim()=='1901'){
                                        Navigator.pop(context);
                                        passwordController.clear();
                                      }
                                    }
                                  },
                                      child: Text('Enter',style: TextStyle(color: Colors.white,fontSize: 20.sp,fontWeight: FontWeight.bold))),


                                ],
                              );

                          }

                      );


                    }, error: (err, stack) => Center(child: Text('$err')),
                    loading: () => Container()
                ),
              )
            ],
          ),
          ),

      ),
    );
  }
}
