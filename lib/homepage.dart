import 'package:flutter/material.dart';

import 'global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Top Ott platforms",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          strutStyle: StrutStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 40,
        leading: const Icon(
          Icons.menu_open_rounded,
          color: Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...Global.website
              .map(
                (e) => Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 15,
                      shadowColor: e['color'],
                      borderOnForeground: true,
                      semanticContainer: true,
                      surfaceTintColor: e['color'],
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 3.0,
                        ),
                      ),
                      child: ListTile(
                        style: ListTileStyle.list,
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          backgroundImage: NetworkImage(e['image']),
                        ),
                        title: Text(
                          e['name'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: e['color'],
                            fontSize: 40,
                          ),
                          strutStyle: const StrutStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        subtitle: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('webpage', arguments: e);
                          },
                          child: Text(
                            e['site'],
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent),
                            strutStyle: const StrutStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        trailing: Icon(
                          Icons.search_sharp,
                          color: e['color'],
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
