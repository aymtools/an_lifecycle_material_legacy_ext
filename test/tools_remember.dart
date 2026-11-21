import 'package:flutter/material.dart';

class PageTester extends StatelessWidget {
  const PageTester({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: const Center(
        child: Text('body'),
      ),
    );
  }
}

class ChangeNotifierTester extends ChangeNotifier {
  int value = 0;

  bool isDisposed = false;

  void increment() {
    value++;
    notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  static bool assertIsDisposed(ChangeNotifier notifier) {
    bool assertDisposed = false;
    try {
      assertDisposed = ChangeNotifier.debugAssertNotDisposed(notifier);
    } catch (_) {}
    return !assertDisposed;
  }
}
