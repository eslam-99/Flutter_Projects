import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Albums extends StatefulWidget {
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final uri = Uri.https("jsonplaceholder.typicode.com", "photos");
  var fullData;

  List filterByAlbums() {
    int currentAlbum = 0;
    List<Map<String, dynamic>> filteredData = [];
    fullData.forEach((map) {
      if (map["albumId"] != currentAlbum) {
        filteredData.add(map);
        currentAlbum++;
      }
    });
    return filteredData;
  }

  Future getAlbums() async {
    var res = await http.get(uri);
    if (res.statusCode == 200) {
      fullData = jsonDecode(res.body);
      return filterByAlbums();
    }
  }

  @override
  Widget build(BuildContext context) {
    getAlbums();
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
      ),
      body: FutureBuilder(
        future: getAlbums(),
        builder: (_, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: maxWidth / 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: snapshot.data.length,
                  cacheExtent: maxWidth * 2,
                  itemBuilder: (_, index) {
                    String image = snapshot.data[index]["thumbnailUrl"];
                    return GridTile(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/album", arguments: {
                            "uri": uri,
                            "id": snapshot.data[index]["albumId"],
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.3,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    image,
                                    // scale: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: maxWidth / 6,
                                width: maxWidth / 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black38,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 15,
                              right: 15,
                              child: Text(
                                "Album ${snapshot.data[index]["albumId"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      blurRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
