import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:net_chat_firebase/pages/chat_list_page.dart';
import 'package:net_chat_firebase/pages/splash_loading_page.dart';
import 'package:net_chat_firebase/pages/splash_page.dart';

import 'firebase_options.dart';
import 'pages/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: NetChat(),
    ),
  );
}

final theme = ThemeData(
  fontFamily: 'Satoshi',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  splashFactory: NoSplash.splashFactory,
);

class NetChat extends StatelessWidget {
  const NetChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NetChat',
      theme: theme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashLoadingPage();
          }
          if (snapshot.hasData) {
            return const ChatListPage();
          }
          return const AuthPage();
        },
      ),
    );
  }
}
