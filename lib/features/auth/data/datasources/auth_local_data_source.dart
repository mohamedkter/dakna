import 'dart:convert';
import 'dart:developer';

import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedToken = 'CACHED_TOKEN';
  static const String cachedUser = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(cachedToken, token);
    log("cacheToken => Done ");
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(cachedUser, json.encode(user.toJson()));
    log("cacheUser => Done");

  }

  @override
  Future<void> clearToken() async {
    sharedPreferences.clear();
  }

  @override
  Future<String?> getCachedToken() async {
    final token = sharedPreferences.getString(cachedToken);
    return token;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUser);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
