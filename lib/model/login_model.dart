import 'package:pos_app/database/user_base.dart';
import 'package:pos_app/db_helper.dart';

class Login {
  String status;
  String msg;
  UserLogin infoLogin;

  Login({
    required this.msg,
    required this.infoLogin,
    required this.status,
  });

  Login copyWith({
    String? status,
    String? msg,
    UserLogin? infoLogin,
  }) {
    return Login(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      infoLogin: infoLogin ?? this.infoLogin,
    );
  }

  // factory Login.fromJson(Map<String, dynamic> json) {
  //   return Login(
  //     id: json['id'],
  //     nama: json['nama'],
  //     username: json['username'],
  //     password: json['password'],
  //     status: json['status'],
  //   );
  // }

  static Future<Login> loginMasuk(
      {required String username, required String password}) async {
    DBHelper helper = DBHelper();
    late Login loginInfo;
    String sql =
        'select * from user where username = \'$username\' and password = \'$password\'';
    var resultObject = await helper.rawData(sql);

    if (resultObject.isNotEmpty) {
      loginInfo = Login(
          msg: 'Login Berhasil',
          status: 'sukses',
          infoLogin: UserLogin.fromJson(resultObject[0]));
    } else {
      loginInfo = Login(
          msg: 'User Tidak Ditemukan',
          status: 'gagal',
          infoLogin: UserLogin(
              id: 0, nama: '', username: '', password: '', status: ''));
    }

    return loginInfo;
  }

  static Future<void> addUser(Map<String, dynamic> data) async {
    DBHelper helper = DBHelper();
    //late Login loginInfo;
    String sql = 'select * from user where username = \'${data['username']}\'';
    var resultObject = await helper.rawData(sql);

    if (resultObject.isEmpty) {
      await helper.insert(UserQueri.tableName, data);
    }

    //return loginInfo;
  }

  static updateUser(
      {required int id, required Map<String, dynamic> data}) async {
    DBHelper helper = DBHelper();
    await helper.update(UserQueri.tableName, data, id);
  }

  static Future<List<UserLogin>> getAllUser() async {
    DBHelper helper = DBHelper();
    var resultObject = await helper.getData(UserQueri.tableName);
    return resultObject.map((e) => UserLogin.fromJson(e)).toList();
  }

  static deleteUser({required int id}) async {
    DBHelper helper = DBHelper();
    await helper.remove(UserQueri.tableName, 'id', id);
  }
}

class UserLogin {
  int id;
  String nama;
  String username;
  String password;
  String status;

  UserLogin({
    required this.id,
    required this.nama,
    required this.username,
    required this.password,
    required this.status,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['id'],
      nama: json['nama'],
      username: json['username'],
      password: json['password'],
      status: json['status'],
    );
  }
}
