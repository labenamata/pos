part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class UserLoaded extends UserState {
  final List<UserLogin> data;
  UserLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserError extends UserState {
  final String message;
  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
