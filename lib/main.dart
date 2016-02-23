import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData.dark(),
      routes: <String, RouteBuilder>{
        '/': (RouteArguments args) => new FlutterDemo()
      }
    )
  );
}

class FlutterDemo extends StatefulComponent {
  State createState() => new _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  static const double _kListItemExtent = 100.0;
  static const Duration _kScrollDuration = const Duration(milliseconds: 300);
  List<String> _items = [];
  GlobalKey<ScrollableState> _scrollableKey = new GlobalKey<ScrollableState>();

  @override
  void initState() {
    _items = new Iterable.generate(10).map((i) => "Item ${i}").toList();
    super.initState();
  }

  void _addItem(String itemName) {
    setState(() {
      _items.add(itemName);
      Scheduler.instance.scheduleFrameCallback((Duration _) {
        _scrollableKey.currentState?.scrollTo(
          0.0,
          duration: const Duration(milliseconds: 300)
        );
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      toolBar: new ToolBar(
        center: new Text('Scrolling Demo')
      ),
      body: new Stack(
        children: <Widget>[
          new ScrollableList(
            key: _scrollableKey,
            itemExtent: _kListItemExtent,
            scrollAnchor: ViewportAnchor.end,
            children: _items.map((String name) {
              return new Card(
                key: new ValueKey(name),
                child: new Center(
                  child: new Text(name)
                )
              );
            })
          ),
          new Row(
            children: <Widget> [
              new RaisedButton(
                key: new ValueKey("up"),
                child: new Text("UP"),
                onPressed: () => _scrollableKey.currentState?.scrollBy(
                  _kListItemExtent,
                  duration: _kScrollDuration
                )
              ),
              new RaisedButton(
                key: new ValueKey("down"),
                child: new Text("DOWN"),
                onPressed: () => _scrollableKey.currentState?.scrollBy(
                  -_kListItemExtent,
                  duration: _kScrollDuration
                )
              ),
            ], justifyContent: FlexJustifyContent.spaceAround
          ),
        ]
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(
          icon: 'content/add'
        ),
        onPressed: () => _addItem("Item ${_items.length}")
      )
    );
  }
}
