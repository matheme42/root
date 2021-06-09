import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:root/home.dart';
import 'context.dart';

class Root<T extends AppContext> extends StatelessWidget {
  static BuildContext? _context;

  static BuildContext? get context => _context;

  final String title;
  final Future<dynamic> Function()? onLoading;
  final Widget? onLoadingScreen;
  final Widget homeScreen;
  final AppBar? appBar;
  final Drawer? drawer;
  final FloatingActionButton? floatingActionButton;
  final T appContext;

  Root({
    required this.title,
    required this.homeScreen,
    required this.appContext,
    this.onLoading,
    this.onLoadingScreen,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
  }) : assert((onLoading != null && onLoadingScreen != null) ||
            (onLoadingScreen == null && onLoading == null));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: ChangeNotifierProvider(
          create: (_) => appContext,
          child: Builder(builder: (context) {
            _context = context;
            return Home<T>();
          })),
      debugShowCheckedModeBanner: false,
    );
  }
}
