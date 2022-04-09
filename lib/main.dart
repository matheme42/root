import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:root/root.dart';

Future<void> onLoading(BuildContext context) async {
  print(AppContext.ofContext(context));
}

class AppContext extends ChangeNotifier {
  static AppContext ofContext(BuildContext context) {
    return Provider.of<AppContext>(context, listen: false);
  }
}

void main() => runApp(Root(
      title: 'mon titre',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      appContext: AppContext(),
      onLoading: onLoading,
      onLoadingScreen: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Container(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
      onLoadingMinDuration: Duration(seconds: 3),
      routes: {
        '/': (context) => HomeScreen(),
        '/2': (context) => HomeScreen2(),
      },
    ));

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Column(
            children: [
              Flexible(
                  child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 1,
                child: MaterialButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("azerty")));
                  },
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Container(
                      color: Colors.orange,
                    ),
                  ),
                ),
              )),
              Flexible(child: TextField(
              )),
              Flexible(
                  child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/2');
                },
                child: Icon(Icons.portrait),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.blue,
        child: MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          child: FractionallySizedBox(
            heightFactor: 1,
            widthFactor: 1,
          ),
        ),
      ),
    );
  }
}
