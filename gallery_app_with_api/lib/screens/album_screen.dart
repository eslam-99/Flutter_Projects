import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  Uri uri;
  int albumId;
  var fullData;
  List<Map<String, dynamic>> albumImages = [];

  void filterByAlbumID() {
    fullData.forEach((map) {
      if (map["albumId"] == albumId) {
        albumImages.add(map);
      }
    });
  }

  Future getAlbums() async {
    var res = await http.get(uri);
    if (res.statusCode == 200) {
      fullData = jsonDecode(res.body);
      filterByAlbumID();
      return albumImages;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    uri = args["uri"];
    albumId = args["id"];
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: FutureBuilder(
        future: getAlbums(),
        builder: (_, snapshot) {
          return (!snapshot.hasData || snapshot == null)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: maxWidth / 3,
                    childAspectRatio: 1.0,
                  ),
                  cacheExtent: maxWidth * 2,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    String image = snapshot.data[index]["thumbnailUrl"];
                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("/album/image", arguments: {
                            "images": albumImages,
                            "index": index,
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 0.3,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                image,
                              ),
                            ),
                          ),
                          // child: Hero(
                          //   tag: fullPath + "/$image.jpg",
                          //   child: Image.asset(
                          //     fullPath + "/$image.jpg",
                          //     fit: BoxFit.cover,
                          //     filterQuality: FilterQuality.low,
                          //   ),
                          // ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
