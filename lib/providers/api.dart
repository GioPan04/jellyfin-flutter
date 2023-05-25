import 'package:dio/dio.dart';
import 'package:jellyfin_flutter/providers/auth.dart';
import 'package:jellyfin_flutter/providers/settings.dart';
import 'package:riverpod/riverpod.dart';

String buildEmbyAuthHeader(String deviceId, String version) =>
    'MediaBrowser Client="Android", Device="Jellyfin Flutter", DeviceId="$deviceId", Version="$version"';

final apiProvider = Provider<Dio>((ref) {
  final auth = ref.watch(authProvider).value;
  final baseUri = ref.watch(baseUriProvider);
  final dio = Dio();

  ref.onDispose(dio.close);

  dio.options.baseUrl = baseUri.toString();
  dio.options.contentType = 'application/json';

  if (auth != null) {
    dio.options.headers.addAll({
      'X-Emby-Authorization':
          '${buildEmbyAuthHeader('1', '0.0.1')}, Token="${auth.token}"',
    });
  } else {
    dio.options.headers.addAll({
      'X-Emby-Authorization': buildEmbyAuthHeader('1', '0.0.1'),
    });
  }

  return dio;
});
