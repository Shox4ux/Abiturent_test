part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class OnSmsTimeOut extends AuthState {}

class OnAuthProgress extends AuthState {}

class OnAuthTime extends AuthState {}

class OnAuthBlocked extends AuthState {
  final String message;
  const OnAuthBlocked({required this.message});
  @override
  List<Object> get props => [message];
}

class UserActive extends AuthState {
  final UserInfo userInfo;
  const UserActive({required this.userInfo});

  @override
  List<Object> get props => [userInfo];
}

class AuthGranted extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthDenied extends AuthState {
  final String error;
  const AuthDenied({required this.error});
  @override
  List<Object> get props => [error];
}

class AuthOnSMS extends AuthState {
  final int id;
  final String phoneNumber;
  const AuthOnSMS({required this.id, required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber, id];
}

class LogedOut extends AuthState {
  @override
  List<Object> get props => [];
}

class OnReceivingResult extends AuthState {
  @override
  List<Object> get props => [];
}

class OnWaitingSmsResult extends AuthState {
  @override
  List<Object> get props => [];
}

class OnReceivingErrorResult extends AuthState {
  final String errorText;
  const OnReceivingErrorResult({
    xt,
    required this.errorText,
  });
  @override
  List<Object> get props => [errorText];
}
