part of 'login_bloc.dart';

class LoginRepository {
  Future<Login> login(
      {required String username, required String password}) async {
    var loginInfo =
        await Login.loginMasuk(username: username, password: password);

    return loginInfo.copyWith();
  }
}
