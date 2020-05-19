import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {

  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool centerTitle;

  const GiphySearchPage({
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.centerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title,
          leading: leading,
          iconTheme: iconTheme,
          brightness: brightness,
            actions: actions,
          backgroundColor: backgroundColor,
          actionsIconTheme: actionsIconTheme,
          textTheme: textTheme,
          centerTitle: centerTitle,
        ),
        body: SafeArea(child: GiphySearchView(), bottom: false));
  }
}
