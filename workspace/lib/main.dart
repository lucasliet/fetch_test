import 'package:flutter/material.dart';
import 'view/home_page.dart';

void main() => runApp(const FetchTest());

class FetchTest extends StatelessWidget {
  const FetchTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}
