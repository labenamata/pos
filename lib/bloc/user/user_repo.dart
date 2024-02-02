part of 'user_bloc.dart';

Future<void> _getUser(GetUser event, Emitter<UserState> emit) async {
  List<UserLogin> user;
  emit(UserLoading());
  user = await Login.getAllUser();
  emit(UserLoaded(user));
}

Future<void> _updateUser(UpdateUser event, Emitter<UserState> emit) async {
  List<UserLogin> user;
  emit(UserLoading());
  await Login.updateUser(id: event.id, data: event.data);
  user = await Login.getAllUser();
  emit(UserLoaded(user));
}

Future<void> _tambahUser(TambahUser event, Emitter<UserState> emit) async {
  List<UserLogin> user;
  emit(UserLoading());

  await Login.addUser(event.data);
  user = await Login.getAllUser();
  emit(UserLoaded(user));
}

Future<void> _hapusUser(HapusUser event, Emitter<UserState> emit) async {
  List<UserLogin> user;
  emit(UserLoading());
  await Login.deleteUser(id: event.id);
  user = await Login.getAllUser();
  emit(UserLoaded(user));
}
