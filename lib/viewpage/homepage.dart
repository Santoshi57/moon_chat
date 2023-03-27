import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moon_chat/viewpage/locked_page.dart';
import 'package:moon_chat/viewpage/feed_page.dart';
import '../services/notification_service.dart';

class HomePage extends ConsumerStatefulWidget {


  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin{



  int _selectedIndex=0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();


    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //       (message) {
    //     print("FirebaseMessaging.onMessage.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data11 ${message.data}");
    //       LocalNotificationService.createanddisplaynotification(message);
    //
    //     }
    //   },
    // );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // getToken();

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

          return Scaffold(
              extendBody: true,
              body:

              SizedBox.expand(
                child:


                PageView(
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  children: [



                    FeedPage(),
                    LockedPage(),
                  ],

                )
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                elevation: 0,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                iconSize: 25.w,
                unselectedFontSize: 0.0,
                selectedFontSize: 10.w,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                selectedItemColor: Colors.purple,

                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed),
                      label: ''
                  ),

                  BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble),
                      label: ''
                  ),

                ],


              )

          );
  }

void _onItemTapped(int index) {



  setState(() {
    _selectedIndex = index;
    //
    //
    //using this page controller you can make beautiful animation effects
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  });

}

}









