import 'package:flutter/material.dart';
import 'package:tubes/global_scaffold.dart';

class RecommendedPage extends StatefulWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  State<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends State<RecommendedPage> {
  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      selectedIndex: 2,
      body: Center(
        child: Text("Recommended Book"),
      ),
    );
  }
}
