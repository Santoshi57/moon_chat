import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'authpage.dart';
import 'homepage.dart';

class StatusPage extends ConsumerWidget {


  @override
  Widget build(BuildContext context,ref) {
    final auth=ref.watch(authStream);
    return Container(
      child: auth.when(
          data: (data){
            if(data == null){
              return AuthPage();
            }else{
               return HomePage();
            }
          },
          error: (err,stack)=> Text('$err'),
          loading: ()=>CircularProgressIndicator()),


    );
  }
}
