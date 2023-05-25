import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellyfin_flutter/models/item.dart';
import 'package:jellyfin_flutter/providers/api.dart';
import 'package:jellyfin_flutter/providers/auth.dart';
import 'package:jellyfin_flutter/providers/settings.dart';
import 'package:jellyfin_flutter/screens/player.dart';

final _continueWatchingProvider = FutureProvider.autoDispose<List<Item>>(
  (ref) async {
    final auth = ref.watch(authProvider).value!;
    final api = ref.watch(apiProvider);

    final res = await api.get('/Users/${auth.user.id}/Items/Resume');
    final items = (res.data['Items'] as List<dynamic>)
        .map((i) => Item.fromJson(i))
        .toList();

    return items;
  },
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_continueWatchingProvider);
    final auth = ref.watch(authProvider).value!;
    final baseUri = ref.watch(baseUriProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.popAndPushNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {},
            icon: auth.user.imageTag != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: Image.network(
                      '${baseUri.toString()}/Users/${auth.user.id}/Images/Primary?width=64&height=64',
                    ),
                  )
                : const Icon(Icons.account_circle_outlined),
          )
        ],
      ),
      body: items.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) => ListTile(
            title: Text(data[i].name!),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VideoScreen(itemId: data[i].id))),
          ),
        ),
        error: (_, e) => Text(e.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
