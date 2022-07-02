import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../cache/locale_manager.dart';

enum Methods { get, put, delete, post }

class Strapi {
  Dio _dio = Dio();
  String _url = 'http://192.168.0.11:1337';

  static Strapi _instance = Strapi._();

  static Strapi get instance => _instance;

  Strapi._() {
    final baseOptions = BaseOptions(
      baseUrl: _url,
    );
    _dio = Dio(baseOptions);
  }

  void _clearToken() {
    _dio.options = BaseOptions();
    LocaleManager.instance.remove(cname: "jwt");
  }

  Future createEntry(String entriyName, dynamic data) async {
    var response =
        await _request(Methods.post, '$_url/api/$entriyName', data: data);
    return response;
  }

  Future deleteEntry(String entriyName, int id) async {
    var response = await _request(
      Methods.delete,
      '$_url/$entriyName/$id',
    );
    return response;
  }

  Future forgotPassword(String email) async {
    _clearToken();
    var response = await _request(Methods.post, '$_url/auth/forgot-password',
        data: {'email': email});
    return response;
  }

  Future getEntries(String entriyName) async {
    var response = await _request(Methods.get, '$_url/api/$entriyName');
    return response;
  }

  Future getEntry(String entriyName, int id) async {
    var response = await _request(Methods.get, '$_url/$entriyName/$id');
    return response;
  }

  Future<int> getEntryCount(String entriyName) async {
    int response = await _request(Methods.get, '$_url/$entriyName/count');
    return response;
  }

  Future getFile(int id) async {
    return await _request(Methods.get, '$_url/upload/files/$id');
  }

  Future<List<dynamic>> getFiles({params}) async {
    return await _request(Methods.get, '$_url/upload/files');
  }

  String getProviderAuthenticationUrl(provider) {
    // TODO: implement
    return '';
  }

  //Future<User> login(String identifire, String password) async {
  //  _clearToken();
  //  var auth = await _request(Methods.post, '$_url/api/auth/local',
  //      data: Login(
  //        identifier: identifire,
  //        password: password,
  //      ).toJson());
  //  if (auth != null) {
  //    setToken(auth["jwt"]);
//
  //    LocaleManager.instance
  //        .set(cname: "user", cvalue: jsonEncode(auth["user"]));
  //  } else {
  //    throw Exception("login failed");
  //  }
//
  //  return User.fromJson(auth["user"]);
  //}
//
  //Future<User> loginFromModel(Login login) async {
  //  _clearToken();
  //  var auth = await _request(Methods.post, '$_url/api/auth/local',
  //      data: login.toJson());
  //  if (auth != null) {
  //    setToken(auth["jwt"]);
//
  //    LocaleManager.instance
  //        .set(cname: "user", cvalue: jsonEncode(auth["user"]));
  //  } else {
  //    throw Exception("login failed");
  //  }
//
  //  return User.fromJson(auth["user"]);
  //}
//
  //Future register(String username, String email, String password) async {
  //  _clearToken();
  //  TestUser newUser = TestUser(username, email, password);
  //  var auth = await _request(Methods.post, '$_url/api/auth/local/register',
  //      data: newUser.toJson());
  //  print(auth.toString());
  //  return auth;
  //}

  Future registerFromModel(dynamic user) async {
    _clearToken();
    dynamic newUser = await _request(
      Methods.post,
      '$_url/api/auth/local/register',
      data: user,
    );
    // dynamic result = jsonDecode(newUser);
    return newUser;
  }

  Future _request(Methods method, String url, {dynamic data}) async {
    await LocaleManager.instance.get(cname: "jwt").then((value) {
      if (value != null && value != "" && !url.contains("auth")) {
        _dio.options.headers = {'Authorization': "Bearer " + value};
      }
    });
    switch (method) {
      case Methods.get:
        final response = await _dio.get(url);
        return response.data;
      case Methods.post:
        final response = await _dio.post(url, data: data);
        return response.data;
      case Methods.put:
        final response = await _dio.put(url, data: data);
        return response.data;
      case Methods.delete:
        final response = await _dio.delete(url);
        return response.data;
    }
  }

  Future<void> resetPassword(
    String code,
    String password,
    String passwordConfirmation,
  ) async {
    _clearToken();
    await _request(Methods.post, '$_url/api/auth/reset-password', data: {
      'code': code,
      'password': password,
      'passwordConfirmation': passwordConfirmation
    });
  }

  void setToken(String token) {
    LocaleManager.instance.set(cname: "jwt", cvalue: token);
  }

  Future updateEntry(String tableName, int id, dynamic data) async {
    var response =
        await _request(Methods.put, '$_url/$tableName/$id', data: data);
    return response;
  }

  Future upload(File file) async {
    FormData formData =
        FormData.fromMap({"file": file, "ref": "image", "field": "image"});
    return await _request(Methods.post, '$_url/upload', data: formData);
  }
}
