import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final FloatingActionButton? floatingActionButton;

  CustomScaffold({required this.body, this.appBar, this.drawer, this.floatingActionButton});

  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height - mediaQuery.padding.top;
    height -= appBar == null ? 0 : appBar!.preferredSize.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: KeyboardDismissOnTap(
            child: SingleChildScrollView(
              child: Container(
                height: height,
                child: body,
              ),
            ),
          ),
        drawer: drawer,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
