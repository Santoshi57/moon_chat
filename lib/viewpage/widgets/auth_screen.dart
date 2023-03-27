import 'package:moon_chat/viewpage/statuspage.dart';
import '../../services/local_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool authenticated = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/background/moon_icon_splash.png',height: 100.h,width: 100.w,),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: InkWell(
                        onTap: () async {
                          final authenticate = await LocalAuth.authenticate();
                          setState(() {
                            authenticated = authenticate;
                          });
                          print(authenticated);
                          if (authenticated) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatusPage()),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: size.width / 1.5,
                          decoration: BoxDecoration(
                              color: Color(0xff963E79),
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: Text(
                              "Authenticate",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ));
  }
}