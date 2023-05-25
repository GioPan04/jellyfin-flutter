import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jellyfin_flutter/screens/home.dart';
import 'package:jellyfin_flutter/screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
        initialRoute: '/login',
      ),
    );
  }
}
