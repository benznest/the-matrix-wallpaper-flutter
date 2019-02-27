import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Matrix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyMatrixPage(title: 'The Matrix'),
    );
  }
}

class MyMatrixPage extends StatefulWidget {
  MyMatrixPage({Key key, this.title, this.row, this.col}) : super(key: key);

  final String title;
  final String row;
  final String col;

  @override
  _MyMatrixPageState createState() => _MyMatrixPageState();
}

class Pixel {
  String data;
  Color color;

  Pixel({this.data = "", this.color = Colors.black});
}

class Line {
  int rowHead;
  int colHead;
  int size;

  Line({this.rowHead = 0, this.colHead = 0, this.size = 10});

  moveDown({int move = 1}) {
    rowHead = rowHead + move;
  }
}

class _MyMatrixPageState extends State<MyMatrixPage> {
  int ROW = 200;
  int COL = 300;

  List<List<Pixel>> matrixTable;
  Timer timer;
  Timer timer2;
  List<Line> listLine;

//  List<Color> color = [
//    Color(0xff3b6d43),
//    Color(0xff3b6d43),
//    Color(0xff3b6d43),
//    Color(0xff3b6d43),
//    Color(0xee3b6d43),
//    Color(0xdd3b6d43),
//    Color(0xcc3b6d43),
//    Color(0xbb3b6d43),
//    Color(0xaa3b6d43),
//    Color(0x993b6d43),
//    Color(0x883b6d43),
//    Color(0x773b6d43),
//    Color(0x663b6d43),
//    Color(0x553b6d43),
//    Color(0x443b6d43),
//    Color(0x333b6d43),
//    Color(0x223b6d43)
//  ];

  List<Color> color = [
    Color(0xff10d630),
    Color(0xff10d630),
    Color(0xff10d630),
    Color(0xff10d630),
    Color(0xee10d630),
    Color(0xdd10d630),
    Color(0xcc10d630),
    Color(0xbb10d630),
    Color(0xaa10d630),
    Color(0x9910d630),
    Color(0x8810d630),
    Color(0x7710d630),
    Color(0x6610d630),
    Color(0x5510d630),
    Color(0x4410d630),
    Color(0x3310d630),
    Color(0x2210d630),
    Color(0x1110d630),
    Color(0x0510d630)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(color: Colors.black, child: buildMatrixTable()));
  }

  initState() {
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => process());
    timer2 = Timer.periodic(Duration(milliseconds: 300), (Timer t) => process());
    super.initState();
  }

  void initLine() {
    listLine = List();
    for (int i = 0; i < COL * 2; i++) {
      listLine.add(randomLine(maxRow: ROW, maxCol: COL));
    }
  }

  Line randomLine({int maxRow = 20, int maxCol = 20}) {
    return Line(
        rowHead: randomNumber(max: maxRow),
        colHead: randomNumber(max: maxCol),
        size: randomNumber(min: 10, max: 20));
  }

  process() {
    if (matrixTable == null) {
      initMatrixTable();
      initLine();
    }

    setState(() {
      initMatrixTable();

      for (Line line in listLine) {
        addLineToMatrixTable(matrixTable, line);

        Random random = Random();
        int number = random.nextInt(100);
        if (number < 20) {
          line.moveDown(move: 2);
        }  else if (number < 80) {
          line.moveDown();
        } else {
          //
        }

        if (line.rowHead - line.size >= ROW) {
          listLine.remove(line);
          listLine.add(randomLine(maxRow: 1, maxCol: COL));
        }
      }
    });
  }

  void addLineToMatrixTable(List<List<Pixel>> matrixTable, Line line) {
    for (int i = 0; i < line.size; i++) {
      int row = line.rowHead - i;
      if (row >= 0 && row < ROW) {
        matrixTable[row][line.colHead].data = randomData();
        if (i < color.length) {
          matrixTable[row][line.colHead].color = color[i];
        } else {
          matrixTable[row][line.colHead].color = color.last;
        }
      }
    }
  }

  String randomData() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random rand = Random();
    return chars[rand.nextInt(chars.length)];
  }

  int randomNumber({int min = 0, int max = 10}) {
    Random rand = Random();
    return rand.nextInt(max) + min;
  }

  void initMatrixTable() {
    matrixTable = List();
    for (int row = 0; row < ROW; row++) {
      List<Pixel> list = List();
      for (int col = 0; col < COL; col++) {
        list.add(Pixel());
      }
      matrixTable.add(list);
    }
  }

  Widget buildMatrixTable() {
    ROW = MediaQuery.of(context).size.height ~/ 12;

    COL = MediaQuery.of(context).size.width ~/ 12;

    if (matrixTable != null) {
      List<Widget> listRow = List();
      for (int row = 0; row < ROW; row++) {
        List<Widget> listCol = List();
        for (int col = 0; col < COL; col++) {
          listCol.add(Container(
              width: 12,
              height: 12,
              child: Text(matrixTable[row][col].data,
                  style: TextStyle(
                      color: matrixTable[row][col].color,
                      fontWeight: FontWeight.bold))));
        }
        listRow.add(Row(children: listCol));
      }

      return Column(children: listRow);
    } else {
      return Container();
    }
  }
}
