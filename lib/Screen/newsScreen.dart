import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../Model/news_model.dart';
import '../detail/news_detail.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List<News> newsHeadlines = [];
  bool loading = true;
  final storage = const FlutterSecureStorage();
  User? user = FirebaseAuth.instance.currentUser;
  bool _searchBoolean = false;
  List<int> _searchIndexList = [];

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }

  Future<void> getConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      getOfflineNews();
    } else {
      fetchNews();
    }
  }

  getOfflineNews() async {
    var response = await storage.read(key: "response");

    var newsHeadlines = json.decode(response.toString());
    print(newsHeadlines);
    List articles = newsHeadlines["articles"];

    articles.forEach((article) {
      article = News.fromJson(article);
      setState(() {
        this.newsHeadlines.add(article);
      });
      loading = false;
    });
  }

  Future fetchNews() async {
    const String newsAPI =
        "http://newsapi.org/v2/everything?q=all&sortBy=popularity&apiKey=bd2f83ffdbf744d0a81d7d256ee21df4";
    var response = await http.get(Uri.parse(newsAPI));

    if (response.statusCode == 200) {
      var newsHeadlines = json.decode(response.body);
      List articles = newsHeadlines["articles"];
      await storage.write(key: "response", value: response.body);

      articles.forEach((article) {
        article = News.fromJson(article);
        setState(() {
          this.newsHeadlines.add(article);
        });
      });
    } else {
      setState(() {
        loading = false;
        return;
      });
    }

    setState(() {
      loading = false;
    });
    return this.newsHeadlines;
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < newsHeadlines.length; i++) {
            if (newsHeadlines[i].title.contains(s)) {
              _searchIndexList.add(i);
            }
          }
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction:
          TextInputAction.search, //Specify the action button on the keyboard
      decoration: const InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle(
          //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _newsListView() {
    return ListView.builder(
        itemCount: newsHeadlines.length,
        itemBuilder: (context, index) {
          final time = Jiffy(newsHeadlines[index].publishedAt).fromNow();
          return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(time),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(newsHeadlines[index].author)
                          ],
                        ),
                      ),
                      ListTile(
                        trailing: Container(
                          height: 120.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: newsHeadlines[index].urlToImage == null
                                  ? const NetworkImage(
                                      "https://via.placeholder.com/150")
                                  : NetworkImage(
                                      newsHeadlines[index].urlToImage),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        title: Text(
                          newsHeadlines[index].title,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          children: [
                            newsHeadlines[index].description != null
                                ? Text(newsHeadlines[index].description,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                    maxLines: 3)
                                : Container(),
                          ],
                        ),
                        //contentPadding: EdgeInsets.all(4),

                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      news: newsHeadlines[index],
                                    )),
                          )
                        },
                      ),
                    ],
                  )));
        });
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          final time = Jiffy(newsHeadlines[index].publishedAt).fromNow();
          return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(time),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(newsHeadlines[index].author)
                          ],
                        ),
                      ),
                      ListTile(
                        trailing: Container(
                          height: 120.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: newsHeadlines[index].urlToImage == null
                                  ? const NetworkImage(
                                      "https://via.placeholder.com/150")
                                  : NetworkImage(
                                      newsHeadlines[index].urlToImage),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        title: Text(
                          newsHeadlines[index].title,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          children: [
                            newsHeadlines[index].description != null
                                ? Text(newsHeadlines[index].description,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                    maxLines: 3)
                                : Container(),
                          ],
                        ),
                        //contentPadding: EdgeInsets.all(4),

                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDetails(
                                      news: newsHeadlines[index],
                                    )),
                          )
                        },
                      ),
                    ],
                  )));
        });
  }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            color: Colors.blue,
          ),
          onPressed: () async => {
            await FirebaseAuth.instance.signOut(),
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
                (route) => false)
          },
        ),
        actions: !_searchBoolean
            ? [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = true;
                        _searchIndexList = [];
                      });
                    })
              ]
            : [
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                      });
                    })
              ],
        title: !_searchBoolean
            ? const Text(
                "Search in Feed",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              )
            : _searchTextField(),
      ),
      body: !_searchBoolean
          ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              loading
                  ? const Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                      strokeWidth: 3,
                    ))
                  : Expanded(
                      child: RefreshIndicator(
                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                          onRefresh: () async {
                            getConnectivity();
                          },
                          child: _newsListView()),
                    ),
            ])
          : _searchListView(),
    );
  }
}

Widget showError() {
  return Container(
    child: const Center(
      child: Text(
        "Not News Found, Hope world is safe",
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    ),
  );
}
