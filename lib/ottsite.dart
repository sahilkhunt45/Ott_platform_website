import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebSitePage extends StatefulWidget {
  const WebSitePage({Key? key}) : super(key: key);

  @override
  State<WebSitePage> createState() => _WebSitePageState();
}

class _WebSitePageState extends State<WebSitePage> {
  final GlobalKey inAppWebViewKey = GlobalKey();
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  List<String> allBookmark = [];

  double progress = 0;
  String url = "";
  final urlController = TextEditingController();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsAirPlayForMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(),
        onRefresh: () async {
          if (Platform.isAndroid) {
            inAppWebViewController?.reload();
          } else if (Platform.isIOS) {
            inAppWebViewController?.loadUrl(
              urlRequest: URLRequest(
                url: await inAppWebViewController?.getUrl(),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic res = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${res['name']}"),
        backgroundColor: res['color'],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              Uri? uri = await inAppWebViewController!.getUrl();
              allBookmark.add(uri!.toString());
            },
            icon: const Icon(Icons.bookmark_add_outlined),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: (context),
                builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text("All Bookmarks"),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        children: allBookmark
                            .map(
                              (e) => TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  inAppWebViewController!.loadUrl(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(e),
                                    ),
                                  );
                                },
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ),
                    )),
              );
            },
            icon: const Icon(Icons.bookmarks),
          ),
        ],
      ),
      body: Column(
        children: [
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
          Expanded(
            flex: 15,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                InAppWebView(
                  pullToRefreshController: pullToRefreshController,
                  initialOptions: options,
                  key: inAppWebViewKey,
                  initialUrlRequest: URLRequest(
                    url: Uri.parse("${res['site']}"),
                  ),
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    searchController.text = url.toString();
                    await pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      searchController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      searchController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          if (await inAppWebViewController!.canGoBack()) {
                            await inAppWebViewController!.goBack();
                          }
                        },
                        elevation: 5,
                        heroTag: null,
                        splashColor: Colors.black,
                        backgroundColor: res['color'],
                        child: const Icon(Icons.arrow_back_ios_outlined),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          await inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.parse("${res['site']}"),
                            ),
                          );
                        },
                        elevation: 5,
                        heroTag: null,
                        splashColor: Colors.black,
                        backgroundColor: res['color'],
                        child: const Icon(Icons.home_filled),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          await inAppWebViewController!.reload();
                        },
                        elevation: 5,
                        heroTag: null,
                        splashColor: Colors.black,
                        backgroundColor: res['color'],
                        child: const Icon(Icons.refresh),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (await inAppWebViewController!.canGoForward()) {
                            await inAppWebViewController!.goForward();
                          }
                        },
                        elevation: 5,
                        heroTag: null,
                        splashColor: Colors.black,
                        backgroundColor: res['color'],
                        child: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ],
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
