import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:root/context.dart';
import 'package:root/root.dart';

import 'scaffold.dart';

class Home<@required T extends AppContext> extends StatefulWidget {
  static BuildContext context;

  @override
  State<StatefulWidget> createState() => HomeState<T>();

  static HomeState get ofContext {
    return context.findAncestorStateOfType<HomeState>();
  }
}

class HomeState<@required T extends AppContext> extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Widget _body;
  AppBar _appBar;
  Drawer _drawer;

  set body(Widget body) => setState(() => _body = body);

  set appBar(AppBar appBar) => setState(() => _appBar = appBar);

  set drawer(Drawer drawer) => setState(() => _drawer = drawer);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Root root = context.findAncestorWidgetOfExactType<Root<T>>();
    _drawer = root?.drawer;
    _appBar = root?.appBar;

    KeyboardVisibility.onChange.listen((bool visible) {
      if (visible == false) SystemChrome.setEnabledSystemUIOverlays([]);
      if (root.appContext.onKeyBoardChange == null) return;
      root.appContext.onKeyBoardChange(visible);
    });

    if (root?.onLoading != null) {
      _body = root.onLoadingScreen;
      root.onLoading().then((_) {
        SystemChrome.setEnabledSystemUIOverlays([]);
        body = root.homeScreen;
      });
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
      _body = root?.homeScreen;
    }
    super.didChangeDependencies();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    Root root = context.findAncestorWidgetOfExactType<Root<T>>();
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        if (root.appContext.onTurnBackground == null) break;
        root.appContext.onTurnBackground();
        break;
      case AppLifecycleState.resumed:
        if (root.appContext.onTurnForeground == null) break;
        root.appContext.onTurnForeground();
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      Home.context = context;
      return AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: _body,
          transitionBuilder: (child, animation) {
            return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: CustomScaffold(
                  body: child,
                  appBar: _appBar,
                  drawer: _drawer,
                ));
          });
    });
  }
}
