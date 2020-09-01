import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:root/root.dart';

import 'home.dart';

class AppContext {}

class Test extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialButton(
			onPressed: () {
				print(context.findAncestorWidgetOfExactType<Home<AppContext>>());
			},
			child: Icon(Icons.info),
		);
	}

}

void main() {
	runApp(Root<AppContext>(
		appContext: AppContext(),
		title: "azerty",
		homeScreen: Container(color: Colors.orangeAccent,
			child: Test()
		),
	));
}