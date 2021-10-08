import 'dart:convert';
import 'package:flutter/material.dart';

class DynamicForm extends StatefulWidget {
  const DynamicForm({Key? key}) : super(key: key);

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late int _count;
  late String _result;
  late List<Map<String, dynamic>> _values;

  @override
  void initState() {
    super.initState();
    _count = 0;
    _result = '';
    _values = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              setState(() {
                _count++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                _count = 0;
                _result = '';
                _values = [];
              });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _count,
                  itemBuilder: (context, index) {
                    return _row(index);
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(_result),
          ],
        ),
      ),
    );
  }

  _row(int key) {
    return Row(
      children: [
        Text('ID: $key'),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            onChanged: (val) {
              _onUpdate(key, val);
            },
          ),
        ),
      ],
    );
  }

  //A function that picks form field values, appends a key to it to create a map
  //then adds teach map to _values, which a list of maps
  _onUpdate(int key, String val) {
    //Initially _value is being updated when ever a new character is typed in form field with duplicate keys,
    //We, want to change that so that it's only updated. We do this by removing duplicate key and only adding it once
    int foundKey = -1;
    for (var map in _values) {
      if (map.containsKey('id')) {
        if (map['id'] == key) {
          foundKey = key;
          break;
        }
      }
    }

    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map['id'] == foundKey;
      });
    }
    Map<String, dynamic> json = {'id': key, 'value': val};
    _values.add(json);
    setState(() {
      //_result = _values.toString();
      _result = _prettyPrint(_values);
    });
  }

  //A function that takes in a list or map and returns a nicely json encoded list or map
  String _prettyPrint(jsonObject) {
    var encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObject);
  }
}
