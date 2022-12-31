import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatefulWidget {
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  // String fullPath;
  String currentImage;
  PageController controller;
  List arguments;

  // List<String> images = [];
  bool isVisible = true;
  bool isVisited = true;
  bool canChange = false;

  List<Map<String, dynamic>> albumImages = [];

  // List<TransformationController> imgController = [];
  List<PhotoViewControllerBase<PhotoViewControllerValue>> imgController = [];
  List<PhotoViewScaleStateController> imgScaleController = [];

  @override
  void didChangeDependencies() {
    if (isVisited) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      albumImages = args["images"];
      int index = args["index"];
      controller = PageController(
        initialPage: index,
      );
      currentImage = albumImages[index]["title"];
      isVisited = false;
      imgController =
          List.generate(albumImages.length, (index) => PhotoViewController());
      imgScaleController = List.generate(
          albumImages.length, (index) => PhotoViewScaleStateController());
      // List.generate(images.length, (index) => TransformationController());
      print(imgController);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: albumImages.length,
            pageController: controller,
            scrollPhysics: BouncingScrollPhysics(),
            builder: (ctx, index) {
              return PhotoViewGalleryPageOptions(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 10.0,
                // heroAttributes: PhotoViewHeroAttributes(tag: albumImages[index]["url"]),
                imageProvider: NetworkImage(
                  albumImages[index]["url"],
                ),
              );
            },
            loadingBuilder: (ctx2, x) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                currentImage = albumImages[index]["title"];
              });
            },
          ),
          // if (isVisible)
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            // height: isVisible? 70 : 0,
            // height: 70,
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            transform:
                isVisible ? Matrix4.rotationX(0) : Matrix4.rotationX(pi / 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.black,
                Colors.transparent,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    currentImage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
