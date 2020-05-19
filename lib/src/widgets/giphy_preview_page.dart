import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/src/widgets/giphy_image.dart';

/// Presents a Giphy preview image.
class GiphyPreviewPage extends StatelessWidget {
  final GiphyGif gif;
  final AppBar previewAppBar;
  final ValueChanged<GiphyGif> onSelected;

  const GiphyPreviewPage(
      {@required this.gif, @required this.previewAppBar, @required this.onSelected,}
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
        appBar: previewAppBar,
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
