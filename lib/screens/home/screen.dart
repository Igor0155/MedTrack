import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeApp extends ConsumerStatefulWidget {
  const HomeApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeAppState();
}

class _HomeAppState extends ConsumerState<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text("Hello World"),
        ),
      ),
    );
  }
}
