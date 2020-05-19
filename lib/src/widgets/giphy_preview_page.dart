import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_image.dart';

/// Presents a Giphy preview image.
class GiphyPreviewPage extends StatelessWidget {
  final GiphyGif gif;
  final Widget title;
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme;
  final Brightness brightness;


  final ValueChanged<GiphyGif> onSelected;

  const GiphyPreviewPage(
      {@required this.gif, @required this.title, @required this.onSelected,
        this.actionsIconTheme, this.iconTheme, this.brightness}
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: AppBar(
            title: title,
            actionsIconTheme: actionsIconTheme,
            iconTheme: iconTheme,
            brightness: brightness,
            actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: () => onSelected(gif))
        ]),
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
