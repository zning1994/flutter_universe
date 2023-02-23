import 'dart:convert';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ScrollableCard(),
    );
  }
}

class ScrollableCard extends StatefulWidget {
  @override
  _ScrollableCardState createState() => _ScrollableCardState();
}

class ListItem {
  String title;
  String content;
  int timestamp;

  ListItem({required this.title, required this.content, required this.timestamp});
}

class _ScrollableCardState extends State<ScrollableCard> {
  List<ListItem> _items = [];
  ScrollController _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreData();
    }
  }

  Future<List<ListItem>> _loadData() async {
    // 这里是使用延迟来模拟异步加载数据，你可以使用真实的网络请求来获取数据
    // await Future.delayed(Duration(seconds: 2));
    String jsonData = '''
      [
        {"title": "Title 1", "content": "Content 1", "timestamp": 1645718554},
        {"title": "Title 2", "content": "Content 2", "timestamp": 1645718564},
        {"title": "Title 3", "content": "Content 3", "timestamp": 1645718574},
        {"title": "Title 4", "content": "Content 4", "timestamp": 1645718584},
        {"title": "Title 5", "content": "Content 5", "timestamp": 1645718594},
        {"title": "Title 6", "content": "Content 6", "timestamp": 1645718604},
        {"title": "Title 7", "content": "Content 7", "timestamp": 1645718614},
        {"title": "Title 8", "content": "Content 8", "timestamp": 1645718624},
        {"title": "Title 9", "content": "Content 9", "timestamp": 1645718634},
        {"title": "Title 10", "content": "Content 10", "timestamp": 1645718644}
      ]
    ''';
    List<dynamic> jsonArray = jsonDecode(jsonData);
    return jsonArray.map((json) {
      return ListItem(
        title: json['title'],
        content: json['content'],
        timestamp: json['timestamp'],
      );
    }).toList();
  }

  void _loadMoreData() async {
    if (_loading) {
      return;
    }
    setState(() {
      _loading = true;
    });
    List<ListItem> newData = await _loadData();
    setState(() {
      _items.addAll(newData);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // 隐藏返回按钮和标题
        // title: Text("Scrollable Card"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Card(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _items.length + 1,
            itemBuilder: (context, index) {
              if (index == _items.length) {
                return _loading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox();
              } else {
                ListItem item = _items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.content),
                  trailing: Text(DateTime.fromMillisecondsSinceEpoch(item.timestamp * 1000).toString()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
