import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class BaFodObserver extends StatefulWidget {
  final Widget? child;
  final Function? onTurnBackground;
  final Function? onTurnForeground;
  final Future<void> Function(BuildContext context)? onLoading;
  final Widget? onLoadingScreen;
  final Duration? onLoadingMinDuration;

  const BaFodObserver(
      {Key? key,
      this.child,
      this.onTurnBackground,
      this.onTurnForeground,
      this.onLoading,
      this.onLoadingScreen,
      this.onLoadingMinDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BaFodObserverState();
  }
}

class BaFodObserverState extends State<BaFodObserver>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Widget homeWidget;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.onLoading != null) {
      homeWidget = widget.onLoadingScreen!;
      widget.onLoading!(context).then((value) {
        Future.delayed(widget.onLoadingMinDuration!).then((value) {
          setState(() {
            homeWidget = widget.child!;
          });
        });
      });
    } else {
      homeWidget = (widget.child != null ? widget.child : Container())!;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        if (widget.onTurnBackground == null) break;
        widget.onTurnBackground!();
        break;
      case AppLifecycleState.resumed:
        if (widget.onTurnForeground == null) break;
        widget.onTurnForeground!();
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => homeWidget;
}

class Root<T extends ChangeNotifier> extends StatelessWidget {
  /// personnalisation
  final String title;
  final ThemeMode? themeMode;
  final ThemeData? darkTheme;
  final ThemeData? theme;

  /// routing
  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;

  /// internationalisation
  final Iterable<Locale>? supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? locale;

  /// app initialisation
  final Future<void> Function(BuildContext context)? onLoading;
  final Widget? onLoadingScreen;
  final Duration? onLoadingMinDuration;

  /// app state
  final Function(bool)? onKeyBoardChange;
  final Function? onTurnBackground;
  final Function? onTurnForeground;

  ///debugger
  final bool debugShowCheckedModeBanner;
  final bool? showPerformanceOverlay;
  final bool? showSemanticsDebugger;
  final bool? debugShowMaterialGrid;

  /// AppContext
  final T appContext;

  Root({
    required this.title,
    this.themeMode,
    this.theme,
    this.darkTheme,
    required this.routes,
    required this.initialRoute,
    this.onLoading,
    this.onLoadingScreen,
    this.onLoadingMinDuration,
    this.onKeyBoardChange,
    this.onTurnBackground,
    this.onTurnForeground,
    this.supportedLocales,
    this.localizationsDelegates,
    this.locale,
    required this.debugShowCheckedModeBanner,
    this.showPerformanceOverlay,
    this.showSemanticsDebugger,
    this.debugShowMaterialGrid,
    required this.appContext,
  });

  static Root? ofContext(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Root>();
  }

  setDeviceOrientation(List<DeviceOrientation> deviceOrientation) {
    SystemChrome.setPreferredOrientations(deviceOrientation);
  }

  @override
  Widget build(BuildContext context) {
    bool latestKeyboardVisible = false;

    setDeviceOrientation([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    return MaterialApp(
        title: title,
        routes: routes,
        themeMode: themeMode,
        theme: theme,
        darkTheme: darkTheme,
        showPerformanceOverlay:
            showPerformanceOverlay == null ? false : showPerformanceOverlay!,
        showSemanticsDebugger:
            showSemanticsDebugger == null ? false : showSemanticsDebugger!,
        debugShowMaterialGrid:
            debugShowMaterialGrid == null ? false : debugShowMaterialGrid!,
        supportedLocales: supportedLocales == null
            ? [const Locale('en', 'US')].reversed
            : supportedLocales!,
        localizationsDelegates: localizationsDelegates,
        initialRoute: initialRoute,
        locale: locale,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        builder: (context, navigator) {
          return ScaffoldMessenger(
            child: KeyboardVisibilityBuilder(builder: (context, visible) {
              if (onKeyBoardChange != null) {
                onKeyBoardChange!(visible);
              }
              if (!visible && latestKeyboardVisible != visible) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
                    overlays: []);
              }
              latestKeyboardVisible = visible;
              return KeyboardDismissOnTap(
                  child: SafeArea(
                      child: SingleChildScrollView(
                          child: Container(
                              height: MediaQuery.of(context).viewInsets.bottom +
                                  MediaQuery.of(context).size.height +
                                  MediaQuery.of(context).padding.top,
                              child: Builder(builder: (context) {
                                return ChangeNotifierProvider(
                                    create: (context) => appContext,
                                    child: BaFodObserver(
                                      onTurnBackground: onTurnBackground,
                                      onTurnForeground: onTurnForeground,
                                      onLoadingScreen: onLoadingScreen,
                                      onLoading: onLoading,
                                      onLoadingMinDuration:
                                          onLoadingMinDuration,
                                      child: navigator!,
                                    ));
                              })))));
            }),
          );
        });
  }
}
