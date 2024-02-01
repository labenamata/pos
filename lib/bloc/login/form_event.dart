part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {}

class LoginUsernameChanged extends LoginEvent {
  final String? username;

  LoginUsernameChanged({this.username});

  @override
  List<Object?> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  final String? password;

  LoginPasswordChanged({this.password});

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted();
  @override
  List<Object?> get props => [];
}

class Logout extends LoginEvent {
  Logout();
  @override
  List<Object?> get props => [];
}
