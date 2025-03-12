import 'package:flutter/material.dart';
import 'package:tubes/global_scaffold.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({Key? key}) : super(key: key);

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 1,
      body: Center(
        child: Text("List Book"),
      ),
    );
  }
}
