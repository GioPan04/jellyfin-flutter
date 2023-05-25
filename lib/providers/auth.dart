import 'package:dio/dio.dart';
import 'package:jellyfin_flutter/models/user.dart';
import 'package:jellyfin_flutter/providers/api.dart';
import 'package:jellyfin_flutter/providers/settings.dart';
import 'package:riverpod/riverpod.dart';

class AuthUser {
  final String token;
  final User user;

  const AuthUser({required this.token, required this.user});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      token: json['AccessToken'],
      user: User.fromJson(json['User']),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  Dio get _api => Dio(
        BaseOptions(
          baseUrl: _ref.read(baseUriProvider).toString(),
          headers: {'X-Emby-Authorization': buildEmbyAuthHeader('1', '0.0.1')},
        ),
      );

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final res = await _api.post('/Users/AuthenticateByName',
          data: {'Username': username, 'Pw': password});
      final user = AuthUser.fromJson(res.data);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(Error(), StackTrace.current);
      rethrow;
    }
  }

  void logout() => state = const AsyncValue.data(null);
}
