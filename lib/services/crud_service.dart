import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../common/firebase_instances.dart';
import '../model/post_state.dart';


final postStream  = StreamProvider((ref) => CrudService.getPosts());


class CrudService {

  static CollectionReference postDb = FirebaseInstances.fireStore.collection('Posts');


  static Stream<List<Post>> getPosts(){
    return postDb.snapshots().map((event) => getSome(event));
  }

  static List<Post> getSome(QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((e) {
      final post = e.data() as Map<String, dynamic> ;
      return Post(
          imageUrl: post['imageUrl'],
          like: Like.fromJson(post['like']),
          userId: post['userId'],
          id: e.id,
          caption: post['caption'],
          imageId: post['imageId'],
          comments: (post['comments'] as List).map((e) => Comment.fromJson(e)).toList()

      );
    }).toList();
  }

  static  Future<Either<String, bool>> addPost({
    required String caption,
    required String userId,
    required XFile image
  }) async {
    try{

      final imageId = DateTime.now().toString();
      final ref = FirebaseInstances.firebaseStorage.ref().child('postImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await postDb.add({
        'caption':caption,
        'imageUrl': url,
        'userId': userId,
        'imageId': imageId,
        'comments': [],
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
    required String caption,
    required String postId,
    required XFile? image,
    required String? imageId
  }) async {
    try {
      if(image == null){
        await postDb.doc(postId).update(
            {
              'caption' : caption
            }
        );
      }else{

        final ref = FirebaseInstances.firebaseStorage.ref().child(
            'postImage/$imageId');
        await ref.delete();
        final newImageId = DateTime.now().toString();
        final ref1 = FirebaseInstances.firebaseStorage.ref().child(
            'postImage/$newImageId');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        await postDb.doc(postId).update(
            { 'caption' : caption,
              'imageUrl': url,
              'imageId': newImageId,
            }
        );



      }

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }

  static Future<Either<String, bool>> delPost({
    required String postId,
    required String imageId,
  }) async {
    try {
      final ref = FirebaseInstances.firebaseStorage.ref().child(
          'postImage/$imageId');
      await ref.delete();

      await postDb.doc(postId).delete();

      return Right(true);
    } on FirebaseException catch (err) {
      return Left(err.message!);
    }
  }

  static  Future<Either<String, bool>> addLike({
    required List<String> username,
    required int like,
    required String postId
  }) async {
    try{

      await postDb.doc(postId).update({
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

  static  Future<Either<String, bool>> addComment({
    required List<Comment> comments,
    required String postId
  }) async {
    try{

      await postDb.doc(postId).update({
        'comments': comments.map((e) => e.toJson()).toList()
      }
      );
      return Right(true);
    }on FirebaseException catch(err){
      return Left(err.message!);
    }
  }




}