import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/model/login_model.dart';

part 'form_status.dart';
part 'form_state.dart';
part 'form_event.dart';
part 'form_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    // Username updated
    if (event is LoginUsernameChanged) {
      emit(state.copyWith(username: event.username));

      // Password updated
    } else if (event is LoginPasswordChanged) {
      emit(state.copyWith(password: event.password));

      // Form submitted
    } else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        var loginInfo = await Login.loginMasuk(
            username: state.username, password: state.password);

        if (loginInfo.status == 'sukses') {
          emit(state.copyWith(
              nama: loginInfo.infoLogin.nama,
              status: loginInfo.infoLogin.status,
              formStatus: SubmissionSuccess()));
        } else {
          emit(state.copyWith(formStatus: SubmissionFailed(loginInfo.msg)));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e.toString())));
      }
    } else if (event is Logout) {
      emit(state.copyWith(formStatus: const InitialFormStatus()));
    }
  }
}
