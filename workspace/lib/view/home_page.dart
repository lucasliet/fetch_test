import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../service/image_service.dart';

const Color _backgroundColor = Color(0xFFEEEEEE);
const Duration _refreshTimer = Duration(milliseconds: 800);
const double _mobileMaxWidth = 768;
const double _appMargin = 12;
const double _cornersRadius = 12;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final imageService = ImageService();

  double _screenWidth = 0;

  List<String> _urls = [];

  @override
  void initState() {
    super.initState();
    _addImage();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width - _appMargin * 2;
    if (kDebugMode) {
      print('screenWidth: $_screenWidth');
    }
    if (_screenWidth > _mobileMaxWidth) {
      imageService.setLargeScreenImagesAmount(true);
    }
    return Container(
      color: _backgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              if (_urls.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: _backgroundColor,
                  padding: const EdgeInsets.all(_appMargin),
                  child: _renderImages(_urls),
                ),
              Container(
                margin: const EdgeInsets.only(top: _appMargin + 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(_cornersRadius - 4),
                      child: Container(
                        padding: const EdgeInsets.all(_appMargin),
                        color: const Color(0x88EEEEEE),
                        child: const Text(
                          'IBAGENS!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                setState(() => _urls = [...imageService.cleanUp()]),
            tooltip: 'Refresh Images',
            child: const Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }

  void _addImage() async {
    while (true) {
      final List<String> newUrls = _urls.length < imageService.imagesAmount
          ? await imageService.getImages()
          : await Future.wait(
              [imageService.getImages(), Future.delayed(_refreshTimer)],
            ).then((futures) => futures[0]);
      setState(() => _urls = [...newUrls]);
    }
  }

  Widget _renderImages(List<String> _urls) {
    final double imageWidth =
        _screenWidth > _mobileMaxWidth ? _screenWidth / 4 : _screenWidth;

    final Axis wrapOrientation =
        _screenWidth > _mobileMaxWidth ? Axis.vertical : Axis.horizontal;

    return SizedBox(
      width: _screenWidth,
      child: Wrap(
        spacing: _appMargin,
        runSpacing: _appMargin,
        direction: wrapOrientation,
        children: _urls
            .map((url) => SizedBox(
                  width: imageWidth,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(_cornersRadius)),
                    child: Image.network(url, fit: BoxFit.fill),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
