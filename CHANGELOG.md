## 1.0.0

* Initial release.
* Migrated legacy Material support from `anlifecycle` and `remember` to decouple core libraries from `flutter/material.dart`:
  * Migrated `LifecycleTabBarView` from `anlifecycle`, providing lifecycle management for `TabBarView` child items.
  * Migrated `rememberTabController` (`RememberMaterialSupportsExt` on `BuildContext`) from `remember`, providing lifecycle-managed `TabController` with `tickerProvider`.
