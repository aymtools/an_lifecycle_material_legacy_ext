import 'package:an_lifecycle_material_legacy_ext/an_lifecycle_material_legacy_ext.dart';
import 'package:anlifecycle/anlifecycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tools_app.dart';
import 'tools_remember.dart';

void main() {
  late TestWidgetsFlutterBinding binding;
  late LifecycleNavigatorObserver navigatorObserver;
  late Widget app;
  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
    navigatorObserver = LifecycleNavigatorObserver.hookMode();
    app = LifecycleTestApp(
      navigatorObserver: navigatorObserver,
      home: PageTester(),
    );
  });
  group('TabController', () {
    testWidgets('create', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TabController? a;
      Element? element;

      final page = Builder(builder: (context) {
        element = context as Element;
        a = context.rememberTabController(length: 2);
        return const PageTester();
      });

      expect(a, isNull);
      navigatorObserver.navigator
          ?.push(MaterialPageRoute(builder: (_) => page));
      await tester.pumpAndSettle();
      expect(a, isNotNull);
      expect(a?.length, 2);
      expect(a?.index, 0);

      a?.animateTo(1);
      element?.markNeedsBuild();
      await tester.pumpAndSettle();
      expect(a?.length, 2);
      expect(a?.index, 1);

      expect(ChangeNotifierTester.assertIsDisposed(a!), isFalse);
      navigatorObserver.navigator?.pop();
      await tester.pumpAndSettle();
      expect(ChangeNotifierTester.assertIsDisposed(a!), isTrue);
    });

    testWidgets('initialIndex changed', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TabController? a;
      TabController? b;
      Element? element;

      final page = Builder(builder: (context) {
        element = context as Element;
        final a1 = context.rememberTabController(
            length: 2, initialIndex: a == null ? 0 : 1);
        if (a == null) {
          a = a1;
        } else {
          b = a1;
        }
        return const PageTester();
      });

      expect(a, isNull);
      navigatorObserver.navigator
          ?.push(MaterialPageRoute(builder: (_) => page));
      await tester.pumpAndSettle();
      expect(a, isNotNull);
      expect(a?.length, 2);
      expect(a?.index, 0);
      expect(b, isNull);

      element?.markNeedsBuild();
      await tester.pumpAndSettle();
      expect(b, isNotNull);
      expect(b?.length, 2);
      expect(b?.index, 1);
      expect(a, isNot(equals(b)));

      expect(ChangeNotifierTester.assertIsDisposed(a!), isTrue);
      expect(ChangeNotifierTester.assertIsDisposed(b!), isFalse);
      navigatorObserver.navigator?.pop();
      await tester.pumpAndSettle();
      expect(ChangeNotifierTester.assertIsDisposed(b!), isTrue);
    });

    testWidgets('duration changed', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TabController? a;
      TabController? b;
      Element? element;

      final page = Builder(builder: (context) {
        element = context as Element;
        final duration = Duration(seconds: a == null ? 1 : 2);
        final a1 = context.rememberTabController(
            length: 2, animationDuration: duration);
        if (a == null) {
          a = a1;
        } else {
          b = a1;
        }
        return const PageTester();
      });

      expect(a, isNull);
      navigatorObserver.navigator
          ?.push(MaterialPageRoute(builder: (_) => page));
      await tester.pumpAndSettle();
      expect(a, isNotNull);
      expect(a?.length, 2);
      expect(a?.index, 0);
      expect(a?.animationDuration, equals(Duration(seconds: 1)));
      expect(b, isNull);

      a?.animateTo(1);
      element?.markNeedsBuild();
      await tester.pumpAndSettle();
      expect(b, isNotNull);
      expect(b?.length, 2);
      expect(b?.index, 0);
      expect(b?.animationDuration, equals(Duration(seconds: 2)));
      expect(a, isNot(equals(b)));
    });

    testWidgets('length changed', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TabController? a;
      Element? element;

      final page = Builder(builder: (context) {
        element = context as Element;
        a = context.rememberTabController(length: a == null ? 2 : 3);
        return const PageTester();
      });

      expect(a, isNull);
      navigatorObserver.navigator
          ?.push(MaterialPageRoute(builder: (_) => page));
      await tester.pumpAndSettle();
      expect(a, isNotNull);
      expect(a?.length, 2);
      expect(a?.index, 0);

      a?.animateTo(1);
      element?.markNeedsBuild();
      await tester.pumpAndSettle();
      expect(a?.length, 3);
      expect(a?.index, 0);
    });
  });
}
