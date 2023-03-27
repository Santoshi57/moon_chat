import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/firebase_instances.dart';
import '../model/post_state.dart';


final noteStream  = StreamProvider((ref) => NoteService.getNotes());


class NoteService {

  static CollectionReference noteDb = FirebaseInstances.fireStore.collection('Notes');


  static Stream<List<Notes>> getNotes(){
    return noteDb.snapshots().map((event) => getSome(event));
  }

  static List<Notes> getSome(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final note = e.data() as Map<String, dynamic> ;
      return Notes(
          like: Like.fromJson(note['like']),
          userId: note['userId'],
          notes: note['notes'],
          dateTime: note['dateTime'],
          id: e.id,
          userName: note['userName']);
    }).toList();
  }

  static  Future<Either<String, bool>> addNote({
    required String notes,
    required String userId,
    required String userName,
    required String dateTime,
  }) async {
    try{


      await noteDb.add({
        'notes' : notes,
        'userId' : userId,
        'userName' : userName,
        'dateTime' : dateTime,
        'like': {
          'likes': 0,
          'usernames': []
        }
      });
      return Right(true);
    }on FirebaseException catch(err){
      return Left(err.message!);
    }
  }


  static Future<Either<String, bool>> updatePost({
    required String notes,
    required String noteId,
  }) async {
    try {



        await noteDb.doc(noteId).update(
            {
              'notes' : notes,
            }
        );

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }

  static Future<Either<String, bool>> delNote({
    required String noteId,
  }) async {
    try {

      await noteDb.doc(noteId).delete();

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }

  static  Future<Either<String, bool>> addLike({
    required List<String> username,
    required int like,
    required String noteId
  }) async {
    try{

      await noteDb.doc(noteId).update({
        'like':{
          'likes': like + 1,
          'usernames': FieldValue.arrayUnion(username)
        }
      }
      );
      return Right(true);
    }on FirebaseException catch(err){
      return Left(err.message!);
    }
  }




}