part of 'user_bloc.dart';

class UserEvent {}

class GetUser extends UserEvent {}

class SearchUser extends UserEvent {
  int id;
  SearchUser({required this.id});
}

class HapusUser extends UserEvent {
  int id;
  HapusUser({required this.id});
}

class UpdateUser extends UserEvent {
  int id;
  Map<String, dynamic> data;
  UpdateUser({
    required this.id,
    required this.data,
  });
}

class TambahUser extends UserEvent {
  Map<String, dynamic> data;

  TambahUser({
    required this.data,
  });
}
