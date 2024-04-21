
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(data[index]["key"]),
                subtitle: Text(data[index]["value"]),
              ),
            );
          }),
    );
  }
}
