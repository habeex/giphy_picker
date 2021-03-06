import 'dart:async';

import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail_grid.dart';

/// Provides the UI for searching Giphy gif images.
class GiphySearchView extends StatefulWidget {
  final Widget title;
  final IconThemeData actionsIconTheme;
  final IconThemeData iconTheme;
  final Brightness brightness;

  GiphySearchView({@required this.title, this.actionsIconTheme, this.iconTheme, this.brightness,});

  @override
  _GiphySearchViewState createState() => _GiphySearchViewState();
}

class _GiphySearchViewState extends State<GiphySearchView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _repoController = StreamController<GiphyRepository>();

  @override
  void initState() {
    // initiate search on next frame (we need context)
    Future.delayed(Duration.zero, () {
      final giphy = GiphyContext.of(context);
      _search(giphy);
    });
    super.initState();
  }

  @override
  void dispose() {
    _repoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final giphy = GiphyContext.of(context);

    return ConstrainedBox(
      constraints: new BoxConstraints(
        minHeight: 450,
        maxHeight: 550,
      ),
      child: Column(children: <Widget>[
        Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: StreamBuilder(
                  stream: _repoController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<GiphyRepository> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.totalCount > 0
                          ? NotificationListener(
                        child: RefreshIndicator(
                            child: GiphyThumbnailGrid(
                              key: Key('${snapshot.data.hashCode}'),
                              repo: snapshot.data,
                              scrollController: _scrollController,
                              title: widget.title,
                              actionsIconTheme:widget. actionsIconTheme,
                              iconTheme: widget.iconTheme,
                              brightness: widget.brightness,
                            ),
                            onRefresh: () =>
                                _search(giphy, term: _textController.text)),
                        onNotification: (n) {
                          // hide keyboard when scrolling
                          if (n is UserScrollNotification) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            return true;
                          }
                          return false;
                        },
                      )
                          : Center(child: Text('No results'));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('An error occurred'));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )),
        Container(
          height: null,
          padding: EdgeInsets.only(top: 3, left: 8, right: 8, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 4, bottom: 8, right: 8),
                        padding: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  MediaQuery(
                                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: _textController,
                                        decoration: InputDecoration.collapsed(
                                            hintText: 'Search GIFs',
                                            hintStyle: TextStyle(fontSize: 16)
                                        ),
                                        onChanged: (value) => _delayedSearch(giphy, value),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  void _delayedSearch(GiphyContext giphy, String term) => Future.delayed(
      Duration(milliseconds: 500), () => _search(giphy, term: term));

  Future _search(GiphyContext giphy, {String term = ''}) async {
    // skip search if term does not match current search text
    if (term != _textController.text) {
      return;
    }

    try {
      // search, or trending when term is empty
      final repo = await (term.isEmpty
          ? GiphyRepository.trending(
              apiKey: giphy.apiKey,
              rating: giphy.rating,
              onError: giphy.onError)
          : GiphyRepository.search(
              apiKey: giphy.apiKey,
              query: term,
              rating: giphy.rating,
              lang: giphy.language,
              onError: giphy.onError));

      // scroll up
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _repoController.add(repo);
    } catch (error) {
      _repoController.addError(error);
      giphy.onError(error);
    }
  }
}
