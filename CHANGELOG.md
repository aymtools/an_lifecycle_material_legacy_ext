## 1.0.1

* Updated minimum SDK requirements to Dart `>=3.0.0` and Flutter `>=3.10.0`.

## 1.0.0

* Initial release.
* Migrated legacy Material support from `anlifecycle` and `remember` to decouple core libraries from
  `flutter/material.dart`:
    * Migrated `LifecycleTabBarView` from `anlifecycle`, providing lifecycle management for
      `TabBarView` child items.
    * Migrated `rememberTabController` from `remember`, providing lifecycle-managed `TabController`
      with `tickerProvider`.
