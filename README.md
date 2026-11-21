# an_lifecycle_material_legacy_ext

Legacy Material support extension for [anlifecycle](https://pub.dev/packages/anlifecycle) and [remember](https://pub.dev/packages/remember).

This package isolates legacy Material components (`flutter/material.dart`) previously bundled with `anlifecycle` and `remember` into a dedicated extension package. This decouples the core libraries from Material dependencies, resolving deprecation notices and lint warnings while preserving full backward compatibility.

## Features

- **`LifecycleTabBarView`**: A drop-in replacement for Flutter's `TabBarView` that manages the lifecycle of each child item (`resumed`, `started`, and `created`) based on tab visibility. Supports `itemKeepAlive` and custom `itemScopeBuilder`.
- **`rememberTabController`**: Extension on `BuildContext` to create, retain, and automatically dispose a `TabController` bound to the widget's lifecycle with built-in `TickerProvider`.

## Getting started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  an_lifecycle_material_legacy_ext: ^1.0.0
```

Import the package in your Dart code:

```dart
import 'package:an_lifecycle_material_legacy_ext/an_lifecycle_material_legacy_ext.dart';
```

## Usage

### 1. `LifecycleTabBarView`

Use `LifecycleTabBarView` as a replacement for Flutter's `TabBarView`. The child items inside will automatically be wrapped with a lifecycle owner. Fully visible items reach the `resumed` state, partially visible items reach `started`, and invisible items reach `created`.

```dart
import 'package:an_lifecycle_material_legacy_ext/an_lifecycle_material_legacy_ext.dart';
import 'package:flutter/material.dart';

class TabViewExample extends StatelessWidget {
  final TabController controller;

  const TabViewExample({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LifecycleTabBarView(
      controller: controller,
      itemKeepAlive: true, // Keeps tab item alive if needed
      children: const [
        TabItemPage(title: 'Tab 1'),
        TabItemPage(title: 'Tab 2'),
        TabItemPage(title: 'Tab 3'),
      ],
    );
  }
}
```

### 2. `rememberTabController`

Use `context.rememberTabController` inside a `build` method to create and remember a `TabController`. The controller's `vsync` is automatically wired to the lifecycle ticker provider, eliminating the need for `SingleTickerProviderStateMixin`.

```dart
import 'package:an_lifecycle_material_legacy_ext/an_lifecycle_material_legacy_ext.dart';
import 'package:flutter/material.dart';

class TabPageExample extends StatelessWidget {
  const TabPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically creates, remembers, and disposes the TabController
    final tabController = context.rememberTabController(
      length: 3,
      initialIndex: 0,
      onCreate: (controller, lifecycle, cancellable) {
        // Optional setup callback
      },
    );

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
      ),
      body: LifecycleTabBarView(
        controller: tabController,
        children: const [
          Center(child: Text('Content 1')),
          Center(child: Text('Content 2')),
          Center(child: Text('Content 3')),
        ],
      ),
    );
  }
}
```
