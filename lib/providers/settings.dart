import 'package:riverpod/riverpod.dart';

final baseUriProvider = Provider<Uri>(
  (ref) => Uri.https('pangio.freemyip.com', '/jellyfin'),
);
