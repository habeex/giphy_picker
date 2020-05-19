import 'package:flutter/material.dart';
import 'package:giphy_picker/src/widgets/giphy_search_view.dart';

class GiphySearchPage extends StatelessWidget {

  final AppBar appBar;
  final AppBar previewAppBar;

  const GiphySearchPage({@required this.appBar, @required this.previewAppBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: SafeArea(child: GiphySearchView(previewAppBar: previewAppBar,), bottom: false));
  }
}
