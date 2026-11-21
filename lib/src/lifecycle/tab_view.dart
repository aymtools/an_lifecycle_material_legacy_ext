import 'package:anlifecycle/anlifecycle.dart';
import 'package:flutter/gestures.dart';

// ignore: deprecated_member_use
import 'package:flutter/material.dart';

/// 替换TabBarView，添加生命周期
class LifecycleTabBarView extends TabBarView {
  //  flutter 2.17没有此属性 以继承的方式来兼容新旧版本
  final Clip _clipBehavior;

  // 低版本不存在，高版本存在，禁用overrides检查
  // ignore: annotate_overrides
  Clip get clipBehavior => _clipBehavior;

  /// 添加了生命周期，适配TabBarView 中item的生命周期Owner
  /// * [itemKeepAlive] 当前的item是否使用 [KeepAlive]
  /// * 完全可见的的item才是[resumed]
  /// 不完全可见的item是[started]，不可见的item为[created]
  /// * [itemScopeBuilder] 指定如何构建item的[scope]
  LifecycleTabBarView({
    super.key,
    List<Widget> children = const <Widget>[],
    super.controller,
    super.physics,
    super.dragStartBehavior = DragStartBehavior.start,
    super.viewportFraction = 1.0,
    Clip clipBehavior = Clip.hardEdge,
    bool itemKeepAlive = false,
    dynamic Function(int index)? itemScopeBuilder,
  })  : _clipBehavior = clipBehavior,
        super(
            children: _pageViewItemsWrapLifecycle(
          children,
          itemKeepAlive,
          itemScopeBuilder,
        ));
}

List<Widget> _pageViewItemsWrapLifecycle(List<Widget> children,
    bool itemKeepAlive, dynamic Function(int index)? itemScope) {
  if (children.isEmpty) return children;
  List<Widget> result = [];
  for (int i = 0; i < children.length; i++) {
    result.add(LifecyclePageViewItemOwner(
      index: i,
      keepAlive: itemKeepAlive,
      scope: itemScope?.call(i),
      child: children[i],
    ));
  }
  return result;
}
