import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static final List<String> _urls = [];

  static Future<String> _fetchImageUrl() async {
    final response =
        await http.get(Uri.parse('https://api.waifu.pics/sfw/bully'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['url'];
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<List<String>> getImages() async {
    String url = await _fetchImageUrl();

    if (_urls.length > 2) {
      _urls.removeAt(0);
    }
    _urls.add(url);
    if (kDebugMode) {
      print('updated img urls $_urls');
    }
    return List.unmodifiable(_urls);
  }

  static List<String> cleanUp() {
    _urls.clear();
    return List.unmodifiable(_urls);
  }
}
