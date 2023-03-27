import 'dart:ui';
import 'package:flutter/material.dart';

Future<bool> showExitPopup(context) async{
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: AlertDialog(
              backgroundColor: Color(0xfff0C1B20),
              content: Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Do you want to exit?"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              print('yes selected');
                             // exit(0);
                            },
                            child: Text("Yes"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xfffae3d3b)),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                print('no selected');
                                Navigator.of(context).pop();
                              },
                              child: Text("No", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xfff0a8476),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}