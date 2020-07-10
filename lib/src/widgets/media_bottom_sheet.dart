import 'dart:ui';
import 'package:flutter/material.dart';

class PikerBottomSheet {
  static Future<T> show<T>(
    BuildContext context, {
    List<Widget> tiles,
    Duration animationDuraion,
    rootNavigator = false,
  }) {
    final mq = MediaQuery.of(context);
    return showRoundedModalBottomSheet<T>(
      context: context,
      maxHeight: mq.size.height,
      duration: animationDuraion ?? Duration(milliseconds: 300),
      rootNavigator: rootNavigator,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: tiles,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<T> scrollable<T>(
    BuildContext context, {
    Widget child,
    bool rootNavigator = true,
  }) {
    final mq = MediaQuery.of(context);

    _maxHeight = mq.size.height - kToolbarHeight - mq.padding.top;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: true,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
        left: Radius.circular(16),
        right: Radius.circular(16),
      )),
      builder: (BuildContext context) {
        return Container(
          height: _maxHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                child,
                SizedBox(
                  height: mq.size.height,
                  width: mq.size.width,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<T> builder<T>(
    BuildContext context, {
    double height,
    WidgetBuilder builder,
  }) {
    _maxHeight = height;
    return showRoundedModalBottomSheet<T>(
        context: context,
        maxHeight: height,
        duration: const Duration(milliseconds: 200),
        radius: 30,
        rootNavigator: false,
        builder: builder);
  }
}

double _maxHeight;
Duration _duration;

Future<T> showRoundedModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  double maxHeight,
  Duration duration,
  bool rootNavigator = true,
  Color color,
  double radius = 20,
}) {
  assert(context != null);
  assert(builder != null);
  assert(radius != null && radius > 0.0);
  _maxHeight = maxHeight;
  _duration = duration;

  assert(color != Colors.transparent);

  final NavigatorState nav = Navigator.of(context, rootNavigator: rootNavigator);

  return nav.push<T>(_RoundedCornerModalRoute<T>(
    builder: builder,
    color: color ?? Colors.white,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: Colors.transparent.withOpacity(.01),
  ));
}

class _RoundedCornerModalRoute<T> extends PopupRoute<T> {
  _RoundedCornerModalRoute({
    this.builder,
    this.barrierLabel,
    this.color,
    this.backgroundColor,
    // this.readius
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  // final double radius;
  final Color color;
  final Color backgroundColor;

  @override
  Color get barrierColor => backgroundColor;

  @override
  bool get barrierDismissible => true;

  @override
  String barrierLabel;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(
      navigator.overlay,
    );

    _animationController.duration = _duration ?? const Duration(milliseconds: 200);
    _animationController.duration = _duration ?? const Duration(milliseconds: 200);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final mq = MediaQuery.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 1,
            end: 1,
          ).animate(
            CurvedAnimation(
              curve: Interval(
                0.0,
                1.0,
                curve: Curves.ease,
              ),
              reverseCurve: Interval(
                0.0,
                1.0,
                curve: Curves.ease,
              ),
              parent: animation,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1,
            ).animate(
              CurvedAnimation(
                curve: Interval(
                  0.0,
                  1.0,
                  curve: Curves.ease,
                ),
                parent: animation,
                reverseCurve: Interval(
                  0.5,
                  1.0,
                  curve: Curves.ease,
                ),
              ),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                  curve: Interval(
                    .0,
                    1.0,
                    curve: Curves.fastLinearToSlowEaseIn,
                  ),
                  parent: animation,
                ),
              ),
              child: AnimatedBuilder(
                animation: animation,
                key: const ValueKey('animation'),
                builder: (context, child) => SizedBox.expand(
                  child: BottomSheet(
                    enableDrag: true,
                    clipBehavior: Clip.none,
                    key: const ValueKey('bottomsheet'),
                    animationController: _animationController,
                    onClosing: () => Navigator.pop(context),
                    builder: (context) => BackdropFilter(
                      key: const ValueKey('BackdropFilter'),
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.0, 10.0),
                                    color:  Color(0xFF3F3F3F).withOpacity(.1),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                color: Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: const Radius.circular(16),
                                      bottomRight: const Radius.circular(16),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    key: const ValueKey('ClipRRect2'),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                    ),
                                    child: Builder(builder: this.builder),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}

