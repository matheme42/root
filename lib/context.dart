import 'package:flutter/cupertino.dart';

class AppContext extends ChangeNotifier {
  Function(bool)? onKeyBoardChange;

  Function? onTurnForeground;

  Function? onTurnBackground;
}
