import 'package:flutter/material.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GiphyGif _gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : true,
        appBar: AppBar(
          title: Text(_gif?.title ?? 'Giphy Picker'),
        ),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: _gif == null
                        ? Text('Pick a gif..')
                        : GiphyImage.original(gif: _gif)),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () async {
              // request your Giphy API key at https://developers.giphy.com/
              final gif = await GiphyPicker.pickGif(
                  context: context, apiKey: '[YOUR GIPHY APIKEY]',
                appBar: AppBar(
                  title: Text(_gif?.title ?? 'Giphy Picker Demo'),
                ),
              );

              if (gif != null) {
                setState(() => _gif = gif);
              }
            })
    );
  }
}
