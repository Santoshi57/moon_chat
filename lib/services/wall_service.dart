import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../common/firebase_instances.dart';
import '../model/post_state.dart';


final wallStream  = StreamProvider((ref) => WallService.getWalls());


class WallService {

  static CollectionReference wallDb = FirebaseInstances.fireStore.collection('Wallpapers');


  static Stream<List<Wall>> getWalls(){
    return wallDb.snapshots().map((event) => getSome(event));
  }

  static List<Wall> getSome(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final wall = e.data() as Map<String, dynamic> ;
      return Wall(
          imageUrl: wall['imageUrl'],
          userId: wall['userId'],
          id: e.id,
          imageId: wall['imageId']);
    }).toList();
  }

  static  Future<Either<String, bool>> addWall({
    required String userId,
    required XFile image
  }) async {
    try{

      final imageId = DateTime.now().toString();
      final ref = FirebaseInstances.firebaseStorage.ref().child('wallImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await wallDb.add({
        'imageUrl': url,
        'userId': userId,
        'imageId': imageId,
      });
      return Right(true);
    }on FirebaseException catch(err){
      return Left(err.message!);
    }
  }

  static Future<Either<String, bool>> updateWall({
    required String wallId,
    required XFile image,
    required String imageId
  }) async {
    try {


        final ref = FirebaseInstances.firebaseStorage.ref().child(
            'wallImage/$imageId');
        await ref.delete();
        final newImageId = DateTime.now().toString();
        final ref1 = FirebaseInstances.firebaseStorage.ref().child(
            'wallImage/$newImageId');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        await wallDb.doc(wallId).update({
              'imageUrl': url,
              'imageId': newImageId,
            }
        );


      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }

  static Future<Either<String, bool>> delWall({
    required String wallId,
    required String imageId,
  }) async {
    try {
      final ref = FirebaseInstances.firebaseStorage.ref().child(
          'wallImage/$imageId');
      await ref.delete();

      await wallDb.doc(wallId).delete();

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }



}