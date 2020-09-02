import 'package:flutter/material.dart';
import 'package:root/home.dart';

class Root extends StatelessWidget {
  static BuildContext _context;

  static BuildContext get context => _context;

  final String title;
  final Future<dynamic> Function() onLoading;
  final Widget onLoadingScreen;
  final Widget homeScreen;
  final AppBar appBar;
  final Drawer drawer;

  Root(
      {@required this.title,
      @required this.homeScreen,
      this.onLoading,
      this.onLoadingScreen,
      this.appBar,
      this.drawer})
      : assert(homeScreen != null),
        assert(title != null),
        assert((onLoading != null && onLoadingScreen != null) ||
            (onLoadingScreen == null && onLoading == null));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Builder(builder: (context) {
        _context = context;
        return Home();
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
