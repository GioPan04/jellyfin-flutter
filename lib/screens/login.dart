import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellyfin_flutter/providers/auth.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    auth.login(_usernameController.text, _passwordController.text);
  }

  void _redirect(AuthUser? user, BuildContext context) {
    if (user == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    auth.whenData((value) => _redirect(value, context));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 32.0, left: 8.0, right: 8.0),
        children: [
          const FlutterLogo(
            size: 64,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              autofillHints: const [AutofillHints.password],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FilledButton(
              onPressed: () => _login(ref),
              child: const Text("Login"),
            ),
          ),
          if (auth.isLoading) const Center(child: CircularProgressIndicator()),
          if (auth.hasError) Text(auth.error.toString()),
          if (auth.hasValue && auth.value != null)
            Text(auth.value!.user.toJson().toString())
        ],
      ),
    );
  }
}
