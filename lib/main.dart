import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _locationController = TextEditingController();
  final _amountController = TextEditingController();
  String _message = "Enter your expense";

  Future<void> saveExpense() async {
    final response = await http.post(
      Uri.parse('http://192.168.240.206/api.php'),
      body: {
        'location': _locationController.text,
        'amount': _amountController.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _message = jsonDecode(response.body)['message'];
      });
      _locationController.clear();
      _amountController.clear();
    } else {
      setState(() {
        _message = "Error saving expense";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expense Tracker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: saveExpense,
              child: Text("Save Expense"),
            ),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
