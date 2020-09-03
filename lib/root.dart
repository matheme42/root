import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:root/home.dart';

import 'context.dart';

class Root<T extends AppContext> extends StatelessWidget {
  static BuildContext _context;

  static BuildContext get context => _context;

  final String title;
  final Future<dynamic> Function() onLoading;
  final Widget onLoadingScreen;
  final Widget homeScreen;
  final AppBar appBar;
  final Drawer drawer;
  final T appContext;

  Root(
      {@required this.title,
      @required this.homeScreen,
      this.onLoading,
      this.onLoadingScreen,
      this.appBar,
      this.drawer,
      this.appContext})
      : assert(homeScreen != null),
        assert(title != null),
        assert((onLoading != null && onLoadingScreen != null) ||
            (onLoadingScreen == null && onLoading == null)),
        assert(appContext != null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Builder(builder: (context) {
        _context = context;
        return ChangeNotifierProvider(
            create: (_) => appContext, child: Home<T>());
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
