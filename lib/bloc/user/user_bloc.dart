import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/model/login_model.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_repo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(initialState) {
    on<GetUser>(_getUser);
    on<UpdateUser>(_updateUser);
    on<TambahUser>(_tambahUser);
    on<HapusUser>(_hapusUser);
  }
}
