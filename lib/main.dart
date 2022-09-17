import 'package:flutter/material.dart';

import 'homepage.dart';
import 'ottsite.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        'webpage': (context) => const WebSitePage(),
      },
    ),
  );
}
