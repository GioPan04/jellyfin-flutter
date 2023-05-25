import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellyfin_flutter/providers/auth.dart';
import 'package:jellyfin_flutter/providers/settings.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final String itemId;

  const VideoScreen({required this.itemId, Key? key}) : super(key: key);

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends ConsumerState<VideoScreen> {
  late BetterPlayerController _controller;

  @override
  void initState() {
    super.initState();
    final baseUri = ref.read(baseUriProvider);
    final auth = ref.read(authProvider).value!;

    final source = BetterPlayerDataSource.network(
      '$baseUri/Videos/${widget.itemId}/master.m3u8?AudioCodec=aac,mp3&api_key=${auth.token}&DeviceId=1&MediaSourceId=${widget.itemId}',
    );

    _controller = BetterPlayerController(
      const BetterPlayerConfiguration(autoPlay: true),
      betterPlayerDataSource: source,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _controller),
          ),
        ),
      ),
    );
  }
}
