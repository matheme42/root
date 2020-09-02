import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root/root.dart';
import 'scaffold.dart';

class Home extends StatefulWidget {
  final _HomeState _state = _HomeState();

  @override
  State<StatefulWidget> createState() => _state;

  set body(Widget body) => _state.body = body;

  set appBar(AppBar appBar) => _state.appBar = appBar;

  set drawer(Drawer drawer) => _state.drawer = drawer;

  Home();

  factory Home.of(BuildContext context) {
    return context.findAncestorWidgetOfExactType();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Widget _body;
  AppBar _appBar;
  Drawer _drawer;

  set body(Widget body) => setState(() => _body = body);

  set appBar(AppBar appBar) => setState(() => _appBar = appBar);

  set drawer(Drawer drawer) => setState(() => _drawer = drawer);

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    Root root = context.findAncestorWidgetOfExactType<Root>();
    _drawer = root?.drawer;
    _appBar = root?.appBar;

    if (root?.onLoading != null) {
      _body = root.onLoadingScreen;
      root.onLoading().then((_) => setState(() => _body = root.homeScreen));
    } else {
      _body = root?.homeScreen;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
