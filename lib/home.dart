import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root/root.dart';

class Home extends StatefulWidget {
  final _HomeState _state = _HomeState();

  @override
  State<StatefulWidget> createState() => _state;

  Home();

  goTo(Widget child) => _state.goTo(child);

  factory Home.of(BuildContext context) {
    return context.findAncestorWidgetOfExactType();
  }
}

class _HomeState extends State<Home> {
  Widget _body;

  goTo(Widget child) {
    setState(() {
      _body = child;
    });
  }

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
    _body = context.findAncestorWidgetOfExactType<Root>().homeScreen;
    _body ??= Container();
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
            child: child,
          );
        });
  }
}
