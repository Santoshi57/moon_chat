import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:moon_chat/viewpage/statuspage.dart';



class LockApp extends  ConsumerWidget {


  final _form1 = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context,ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Container(
                height: 250.h,
                width: 300.w,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock,size: 90.sp,),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: 120.w,
                      child: Form(
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
                          style: TextStyle(fontSize: 35.sp ,color: Colors.white,fontWeight: FontWeight.bold),

                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10,right: 10,bottom: 10,),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white
                                )
                              ),
                              focusedBorder: OutlineInputBorder(),
                              hintText: 'Password',
                              hintStyle: TextStyle(fontSize: 25.sp ,color: Colors.grey,fontWeight: FontWeight.bold)
                          ),

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,

                                ),
                                onPressed: (){
                                  if(passwordController.text.trim()=='1901'){
                                    passwordController.clear();
                                    Get.to(()=>StatusPage(),transition: Transition.fade);
                                  }

                                },
                                child: Text('Enter',style: TextStyle(color: Colors.black,fontSize: 20.sp,fontWeight: FontWeight.bold))),


                          ],
                        )
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
