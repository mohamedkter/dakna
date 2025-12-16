import 'dart:convert';
import 'dart:developer';
import 'package:dakna/core/cache/cache_helper.dart';
import 'package:dakna/core/cache/chache_keys.dart';
import 'package:dakna/features/auth/data/models/user_model.dart';


abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String cachedToken = 'CACHED_TOKEN';
  static const String cachedUser = 'CACHED_USER';

  @override
  Future<void> cacheToken(String token) async {
    await CacheHelper.saveData(key: cachedToken, value: token);
    log("cacheToken => Done ");
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    CacheHelper.saveData(
      key: CacheKeys.cachedUser,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> clearToken() async {
    await CacheHelper.removeData(key: cachedToken);
    await CacheHelper.removeData(key: cachedUser);
  }

  @override
  Future<String?> getCachedToken() async {
    final token = await CacheHelper.getData(key: CacheKeys.cachedToken);
    return token;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = await CacheHelper.getData(key: CacheKeys.cachedUser);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
