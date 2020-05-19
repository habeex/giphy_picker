import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_image.dart';

/// Presents a Giphy preview image.
class GiphyPreviewPage extends StatelessWidget {
  final GiphyGif gif;
  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool centerTitle;
  final ValueChanged<GiphyGif> onSelected;

  const GiphyPreviewPage(
      {@required this.gif, @required this.onSelected, this.title,
        this.leading,
        this.actions,
        this.backgroundColor,
        this.brightness,
        this.iconTheme,
        this.actionsIconTheme,
        this.textTheme,
        this.centerTitle,}
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
          title: title, actions: actions,
          leading: leading,
          iconTheme: iconTheme,
          brightness: brightness,
          backgroundColor: backgroundColor,
          actionsIconTheme: actionsIconTheme,
          textTheme: textTheme,
          centerTitle: centerTitle,),
        body: SafeArea(
            child: Center(
                child: GiphyImage.original(
              gif: gif,
              width: media.orientation == Orientation.portrait
                  ? double.maxFinite
                  : null,
              height: media.orientation == Orientation.landscape
                  ? double.maxFinite
                  : null,
              fit: BoxFit.contain,
            )),
            bottom: false));
  }
}
