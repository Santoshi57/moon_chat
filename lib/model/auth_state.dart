

class AuthState{

  final String errorMessage;
  final bool isSuccess;
  final bool isLoad;

  AuthState({

    required this.errorMessage,
    required this.isSuccess,
    required this.isLoad

  });



  AuthState copyWith({bool? isLoad, String? errorMessage, bool? isSuccess }){
    return AuthState(
        errorMessage: errorMessage ?? this.errorMessage,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }

  factory AuthState.empty(){
    return AuthState(errorMessage: '', isLoad: false, isSuccess: false);
  }

}