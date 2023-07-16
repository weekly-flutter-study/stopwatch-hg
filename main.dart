import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '김한길의 스톱워치',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '김한길의 스톱워치'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  int _start = 0;
  int _millis = 0;
  bool _isStarted = false;
  List<String> _recordList = [];

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_isStarted) {
          _millis++;
          _start = _millis ~/ 100;
        }
      });
    });
  }

  void resetOrRecord() {
    if (_isStarted) {
      setState(() {
        _recordList.add(
            '${(_start ~/ 60).toString().padLeft(2, '0')}:${(_start % 60).toString().padLeft(2, '0')}.${(_millis % 100).toString().padLeft(2, '0')}');
      });
    } else {
      setState(() {
        _start = 0;
        _millis = 0;
        _recordList.clear();
      });
    }
  }

  void toggleButton() {
    setState(() {
      _isStarted = !_isStarted;
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (_start ~/ 60) % 60;
    int seconds = _start % 60;
    int millis = _millis % 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.headline4,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: ListView.builder(
              itemCount: _recordList.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${index + 1}'),
                      SizedBox(width: 10),
                      Text('${_recordList[index]}'),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton.extended(
                onPressed: resetOrRecord,
                backgroundColor: _isStarted ? Colors.blue : Colors.orange,
                label: Text(_isStarted ? '기록' : '초기화'),
              ),
              SizedBox(width: 10),
              FloatingActionButton.extended(
                onPressed: toggleButton,
                backgroundColor: _isStarted ? Colors.red : Colors.green,
                label: Text(_isStarted ? '정지' : '시작'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
