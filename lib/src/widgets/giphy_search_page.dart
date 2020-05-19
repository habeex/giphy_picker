import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {

  final AppBar appBar;
  final Widget title;
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme;
  final Brightness brightness;

  const GiphySearchPage({@required this.appBar, @required this.title, this.actionsIconTheme, this.iconTheme, this.brightness});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: SafeArea(
            child: GiphySearchView(
          title: title,
          actionsIconTheme: actionsIconTheme,
          iconTheme: iconTheme,
          brightness: brightness,
        ), bottom: false));
  }
}
