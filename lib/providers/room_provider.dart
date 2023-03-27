
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moon_chat/common/firebase_instances.dart';


final roomStream = StreamProvider((ref) => FirebaseInstances.firebaseChatCore.rooms());
final roomProvider = Provider((ref) => RoomProvider());
final messageStream = StreamProvider.family.autoDispose((ref,types.Room room) => FirebaseInstances.firebaseChatCore.messages(room));

class RoomProvider{


  Future<types.Room?> roomCreate(types.User user) async{

    try{
      final response = await FirebaseInstances.firebaseChatCore.createRoom(user);
      return response;
    }catch(err){
      return null;
    }

  }


}