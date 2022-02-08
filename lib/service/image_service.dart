import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static const String _imgApiUrl = 'https://api.waifu.pics/sfw/bully';

  int _imagesAmount = 4;

  int get imagesAmount => _imagesAmount;

  void setLargeScreenImagesAmount(bool isLarge) =>
      _imagesAmount = isLarge ? 13 : 4;

  final List<String> _urls = [];

  Future<String> _fetchImageUrl() async {
    final response = await http.get(Uri.parse(_imgApiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body)['url'];
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<String>> getImages() async {
    String url = await _fetchImageUrl();

    if (_urls.length > _imagesAmount) {
      _urls.removeAt(0);
    }

    _urls.add(url);

    if (kDebugMode) {
      print('updated img urls size ${_urls.length}');
    }
    return List.unmodifiable(_urls);
  }

  List<String> cleanUp() {
    _urls.clear();
    return List.unmodifiable(_urls);
  }
}
