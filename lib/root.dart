import 'package:flutter/material.dart';
import 'package:root/home.dart';

class Root extends StatelessWidget {
  static BuildContext _context;

  static BuildContext get context => _context;

  final Future<dynamic> Function() onLoading;
  final Widget onLoadingScreen;
  final Widget homeScreen;
  final String title;

  Root({
    @required this.title,
    @required this.homeScreen,
    this.onLoading,
    this.onLoadingScreen,
  })  : assert(homeScreen != null),
        assert(title != null),
        assert((onLoading != null && onLoadingScreen != null) ||
            (onLoadingScreen == null && onLoading == null));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        body: Builder(builder: (context) {
          _context = context;
          return onLoading != null
              ? FutureBuilder(
                  future: onLoading(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Home();
                    }
                    return onLoadingScreen;
                  },
                )
              : Home();
        }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
