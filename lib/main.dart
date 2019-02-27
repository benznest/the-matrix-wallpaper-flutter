import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = 'The Matrix';
    return MaterialApp(
      title: title,
      home: MyMatrixPage(title: title),
    );
  }
}

class MyMatrixPage extends StatefulWidget {
  MyMatrixPage({Key key, this.title}) : super(key: key);

  final String title;

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
  int countRow = 0, countCol = 0;
  double sizeOfPixel = 12;

  Timer timer, timer2;
  List<List<Pixel>> matrixTable;
  List<Line> listLine;

  List<Color> color = [
    Color(0xff7aff68),
    Color(0xff10ff30),
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
    timer2 =
        Timer.periodic(Duration(milliseconds: 300), (Timer t) => process());
    super.initState();
  }

  void initLine() {
    listLine = List();
    for (int i = 0; i < countCol * 2; i++) {
      listLine.add(randomLine(maxRow: countRow, maxCol: countCol));
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
    } else {
      setState(() {
        initMatrixTable();

        for (Line line in listLine) {
          addLineToMatrixTable(matrixTable, line);

          int number = Random().nextInt(100);
          if (number < 20) {
            line.moveDown(move: 2);
          } else if (number < 80) {
            line.moveDown();
          }

          if (line.rowHead - line.size >= countRow) {
            listLine.remove(line);
            listLine.add(randomLine(maxRow: 1, maxCol: countCol));
          }
        }
      });
    }
  }

  void addLineToMatrixTable(List<List<Pixel>> matrixTable, Line line) {
    for (int i = 0; i < line.size; i++) {
      int row = line.rowHead - i;
      if (row >= 0 && row < countRow) {
        matrixTable[row][line.colHead].data = randomCharacter();
        if (i < color.length) {
          matrixTable[row][line.colHead].color = color[i];
        } else {
          matrixTable[row][line.colHead].color = color.last;
        }
      }
    }
  }

  String randomCharacter() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return chars[Random().nextInt(chars.length)];
  }

  int randomNumber({int min = 0, int max = 10}) {
    return Random().nextInt(max) + min;
  }

  void initMatrixTable() {
    matrixTable = List();
    for (int row = 0; row < countRow; row++) {
      List<Pixel> list = List();
      for (int col = 0; col < countCol; col++) {
        list.add(Pixel());
      }
      matrixTable.add(list);
    }
  }

  Widget buildMatrixTable() {
    countRow = MediaQuery.of(context).size.height ~/ 12;
    countCol = MediaQuery.of(context).size.width ~/ 12;

    if (matrixTable != null) {
      List<Widget> listRow = List();
      for (int row = 0; row < countRow; row++) {
        List<Widget> listCol = List();
        for (int col = 0; col < countCol; col++) {
          listCol.add(Container(
              width: sizeOfPixel,
              height: sizeOfPixel,
              child: Text(matrixTable[row][col].data,
                  style: TextStyle(
                      color: matrixTable[row][col].color,
                      fontWeight: FontWeight.bold))));
        }
        listRow.add(Row(children: listCol));
      }

      return Column(children: listRow);
    }
    return Container();
  }
}
