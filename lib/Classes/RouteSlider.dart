import 'package:flutter/widgets.dart';

class Direction{
  var UP = const Offset(0, 1);
  var LEFT = const Offset(1, 0);
  var ZERO = const Offset(0, 0);
}

class RouteSlider extends PageRouteBuilder {
  final Widget page;

  RouteSlider({this.page, Offset dir})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) => page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: dir,
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}