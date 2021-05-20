import '../providers/anketa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamScreen extends StatefulWidget {
  static const routeName = "/cse_screen";

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  bool _giveVerse = false;

  Switch switchInitState() {
    _giveVerse = Provider.of<AnketaProvider>(context, listen: false).cseChecker;

    return Switch.adaptive(
        value: _giveVerse,
        onChanged: (bool newValue) {
          setState(() {
            _giveVerse = newValue;
          });
          Provider.of<AnketaProvider>(context, listen: false)
              .changeCseChecker(newValue);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Вкл/Выкл фильтр ЕГЭ/ЦТ"), switchInitState()],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
