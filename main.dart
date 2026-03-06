import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'app_router.dart';

void main() {
  final auth = AuthProvider();
  auth.checkSession();
  runApp(CiptApp(auth: auth));
}

class CiptApp extends StatelessWidget {
  final AuthProvider auth;

  const CiptApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: auth,
      child: MaterialApp.router(
        title: 'CIPT - Pick Up Tool',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6a11cb)),
          useMaterial3: true,
        ),
        routerConfig: createRouter(auth),
      ),
    );
  }
}
