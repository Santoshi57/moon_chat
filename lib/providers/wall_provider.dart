
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../model/crud_state.dart';
import '../services/wall_service.dart';

final wallProvider = StateNotifierProvider<WallNotifier, CrudState>((ref) => WallNotifier(CrudState.empty()));

class WallNotifier extends StateNotifier<CrudState> {
  WallNotifier(super.state);


  Future<void> addWall({
    required String userId,
    required XFile image
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await WallService.addWall(
        userId: userId,
        image: image
    );
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }


  Future<void> updateWall({
    required String wallId,
    required XFile image,
    required String imageId
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await WallService.updateWall(
        wallId: wallId,
        image: image,
        imageId: imageId);
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }

  Future<void> delWall({
    required String wallId,
    required String imageId,
  }) async {
    state = state.copyWith(isLoad: true, errorMessage: '', isSuccess: false);
    final response = await WallService.delWall(
        wallId: wallId,
        imageId: imageId
    );
    response.fold((l) {
      state = state.copyWith(isLoad: false, errorMessage: l, isSuccess: false);
    }, (r) {
      state = state.copyWith(isLoad: false, errorMessage: '', isSuccess: true);
    });
  }


}