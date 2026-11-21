import 'package:an_lifecycle_material_legacy_ext/an_lifecycle_material_legacy_ext.dart';
import 'package:anlifecycle/anlifecycle.dart' hide LifecycleTabBarView;
import 'package:anlifecycle/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'tools_app.dart';

void main() {
  late LifecycleNavigatorObserver navigatorObserver;
  late TestLifecycleCollectStateObserver appCollectStateObserver;
  late TestLifecycleCollectStateObserver pageCollectStateObserver;

  late PageController pageViewController;

  late TestLifecycleCollectStateObserver oneCollectStateObserver,
      twoCollectStateObserver,
      threeCollectStateObserver;

  setUp(() {
    navigatorObserver = LifecycleNavigatorObserver.hookMode();
    appCollectStateObserver = TestLifecycleCollectStateObserver();
    pageCollectStateObserver = TestLifecycleCollectStateObserver();
    pageViewController = PageController(initialPage: 0);
    oneCollectStateObserver = TestLifecycleCollectStateObserver();
    twoCollectStateObserver = TestLifecycleCollectStateObserver();
    threeCollectStateObserver = TestLifecycleCollectStateObserver();
  });

  group('TabBarView', () {
    testWidgets('create', (tester) async {
      expect(navigatorObserver.getRouteHistory().length, 0);
      final tabController = TabController(length: 3, vsync: tester);

      final page = LifecycleObserverWatcher(
        observer: pageCollectStateObserver,
        child: LifecycleTabBarView(
          controller: tabController,
          itemKeepAlive: true,
          children: [
            LifecycleObserverWatcher(observer: oneCollectStateObserver),
            LifecycleObserverWatcher(observer: twoCollectStateObserver),
            LifecycleObserverWatcher(observer: threeCollectStateObserver),
          ],
        ),
      );

      await tester.pumpWidget(
        LifecycleTestApp(
          observer: appCollectStateObserver,
          navigatorObserver: navigatorObserver,
          home: SizedBox.shrink(),
        ),
      );

      expect(navigatorObserver.getRouteHistory().length, 1);

      expect(appCollectStateObserver.stateHistory, [
        LifecycleState.created,
        LifecycleState.started,
        LifecycleState.resumed
      ]);
      navigatorObserver.navigator
          ?.push(MaterialPageRoute(builder: (_) => page));
      await tester.pumpAndSettle();

      expect(navigatorObserver.getRouteHistory().length, 2);

      expect(pageCollectStateObserver.stateHistory, [
        LifecycleState.created,
        LifecycleState.started,
        LifecycleState.resumed
      ]);
      expect(oneCollectStateObserver.stateHistory, [
        LifecycleState.created,
        LifecycleState.started,
        LifecycleState.resumed
      ]);
      expect(twoCollectStateObserver.stateHistory, []);
      expect(threeCollectStateObserver.stateHistory, []);

      await tester.pumpAndSettle();
      expect(appCollectStateObserver.historySub(3), []);
      expect(pageCollectStateObserver.historySub(3), []);
      expect(oneCollectStateObserver.historySub(3), []);
      expect(twoCollectStateObserver.stateHistory, []);
      expect(threeCollectStateObserver.stateHistory, []);

      await tester.pumpAndSettle();
      // await Future.delayed(Duration());

      expect(oneCollectStateObserver.historySub(2), [LifecycleState.resumed]);

      tabController.animateTo(1,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
      await tester.pumpAndSettle();
      expect(appCollectStateObserver.historySub(3), []);
      expect(pageCollectStateObserver.historySub(3), []);
      expect(oneCollectStateObserver.historySub(3), [
        LifecycleState.started,
        LifecycleState.created,
      ]);
      expect(twoCollectStateObserver.stateHistory, [
        LifecycleState.created,
        LifecycleState.started,
        LifecycleState.resumed
      ]);
      expect(threeCollectStateObserver.stateHistory, []);

      await tester.pumpAndSettle();
      expect(oneCollectStateObserver.historySub(5), []);
      expect(twoCollectStateObserver.historySub(3), []);
      expect(threeCollectStateObserver.historySub(0), []);

      tabController.animateTo(2,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
      await tester.pumpAndSettle();
      expect(oneCollectStateObserver.historySub(5), []);
      expect(twoCollectStateObserver.historySub(3), [
        LifecycleState.started,
        LifecycleState.created,
      ]);
      expect(threeCollectStateObserver.historySub(0), [
        LifecycleState.created,
        LifecycleState.started,
        LifecycleState.resumed,
      ]);

      navigatorObserver.navigator
          ?.removeRoute(navigatorObserver.getTopRoute()!);
      await tester.pumpAndSettle();
      expect(navigatorObserver.getRouteHistory().length, 1);

      expect(oneCollectStateObserver.historySub(5), [
        LifecycleState.destroyed,
      ]);
      expect(twoCollectStateObserver.historySub(5), [
        LifecycleState.destroyed,
      ]);
      expect(threeCollectStateObserver.historySub(3), [
        LifecycleState.started,
        LifecycleState.created,
        LifecycleState.destroyed,
      ]);
      expect(pageCollectStateObserver.historySub(3), [
        LifecycleState.started,
        LifecycleState.created,
        LifecycleState.destroyed,
      ]);
    });
  });
}
