import 'package:flutter/material.dart';
import 'package:fetch_test/image_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBAGENS!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'IBAGENS!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _urls = [];

  void _addImage() async {
    while(true) {
      final List<String> newUrls = await ImageService.getImages();
      setState(() => _urls = [...newUrls]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_urls.isEmpty) _addImage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _urls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _urls.length,
              itemBuilder: (context, index) {
                return Image.network(_urls[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _urls = [...ImageService.cleanUp()]),
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
