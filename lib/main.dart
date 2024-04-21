import 'package:assignment_1/Components/HomePage.dart';
import 'package:assignment_1/services/db_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Assignment 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = [];
  @override
  void initState() {
    super.initState();
    _read();
  }

  void _read() async {
    var data = await DatabaseHelper.instance.read();
    setState(() {
      _data = data;
    });
  }

  final TextEditingController _keycontroller = TextEditingController();
  final TextEditingController _valuecontroller = TextEditingController();
  String Key = ' ';
  BuildContext? bottomContext;
  @override
  Widget build(BuildContext context) {
    setState(() {
      Key = _keycontroller.value.text;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: bodyHome(
        Key: Key,
        data: _data,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BuildContext? bottomContext;
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                bottomContext = context;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Key-Value Pair',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _keycontroller,
                          decoration: InputDecoration(
                              hintText: 'Key',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _valuecontroller,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: 'Value',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                  elevation: MaterialStatePropertyAll(10)),
                              onPressed: () async {
                                await DatabaseHelper.instance.insert({
                                  // DatabaseHelper.columnId: 3,
                                  DatabaseHelper.keyCol:
                                      _keycontroller.value.text,
                                  DatabaseHelper.valCol:
                                      _valuecontroller.value.text,
                                });
                                var dbquery =
                                    await DatabaseHelper.instance.read();
                                setState(() {
                                  _data = dbquery;
                                });
                                Navigator.pop(bottomContext!);
                                // await DatabaseHelper.instance.clearUserTable();
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(elevation: 10),
                              onPressed: () {
                                Navigator.pop(bottomContext!);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ignore: camel_case_types
class bodyHome extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const bodyHome({super.key, required this.Key, required this.data});

  final String Key;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HomePage(
            data: data,
          )
        ],
      ),
    );
  }
}
