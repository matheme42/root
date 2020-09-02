import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget appBar;
  final Widget drawer;

  CustomScaffold({this.body, this.appBar, this.drawer});

  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height - mediaQuery.padding.top;
    height -= appBar == null ? 0 : appBar.preferredSize.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: Container(
          child: SingleChildScrollView(
            child: Container(height: height, child: body),
          ),
        ),
        drawer: drawer,
      ),
    );
  }
}
