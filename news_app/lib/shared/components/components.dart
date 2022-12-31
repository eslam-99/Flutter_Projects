import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/layout/web_view/web_view_screen.dart';

Widget buildArticles(List articles) {
  return ListView.separated(
    // shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: articles.length,
    itemBuilder: (BuildContext context, int index) =>
        buildArticleItem(context, articles[index]),
    separatorBuilder: (BuildContext context, int index) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 1.0,
        color: Colors.grey,
      ),
    ),
  );
}

Widget buildArticleItem(context, article) {
  return InkWell(
    onTap: () {
      if(article["url"] != null) {
        goto(context, WebViewScreen(url: article["url"]));
      } else {
        Fluttertoast.showToast(msg: "No URL Found!");
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
      height: 134.0,
      child: Row(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: article["urlToImage"] != null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        article["urlToImage"],
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    article["title"] ?? "NO TITLE",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Text(
                  '${(article["publishedAt"]??"NO Date   ").toString().substring(0, 10)}  ${(article["publishedAt"]??"     ").toString().substring(11, 16)}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void goto(context, widget) {
  Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      )
  );
}
