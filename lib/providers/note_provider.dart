
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/crud_state.dart';
import '../services/note_service.dart';

final noteProvider = StateNotifierProvider<NoteNotifier, CrudState>((ref) => NoteNotifier(CrudState.empty()));

class NoteNotifier extends StateNotifier<CrudState> {
  NoteNotifier(super.state);


  Future<void> addNote({
    required String notes,
    required String userId,
    required String userName,
    required String dateTime,

  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await NoteService.addNote(
        notes: notes,
        userId: userId,
        userName: userName,
        dateTime: dateTime);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }


  Future<void> delNote({
    required String noteId,
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await NoteService.delNote(
        noteId: noteId,
    );
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }

  Future<void> updateNote({
    required String notes,
    required String noteId,
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await NoteService.updatePost(
        notes: notes,
        noteId: noteId,);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }

  Future<void> addLike({
    required List<String> username,
    required int like,
    required String noteId
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await NoteService.addLike(
        username: username,
        like: like,
        noteId: noteId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }







}