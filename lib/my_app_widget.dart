import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:run_small_dropbox/run_small_dropbox.dart';

import 'movie_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  bool isError = false;

  List<Movie> moviesList = [];

  @override
  void initState() {
    super.initState();

    (() async {
      var response = await getTemporaryFileLink(
        commonParameter("YOUR_TOKEN_HERE"),
        bodyParameterToAcquireTheTemporaryLink('/Moviern/movies.json'),
      );

      if (response.statusCode == 200) {
        var link = jsonDecode(response.body)['link'];

        var fileResponse = await http.get(Uri.parse(link));

        if (fileResponse.statusCode == 200) {
          String fileContent = fileResponse.body;
          moviesList = Movie.fromJsonList(jsonDecode(fileContent)["movies"]);

          setState(() {
            isLoading = false;
          });
        } else {
          isError = true;
          isLoading = false;
          setState(() {});
        }
      } else {
        isError = true;
        isLoading = false;
        setState(() {});
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(
                  child: Text("Something went wrong"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: ((context, index) => Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PreviewPage(moviesList[index]),
                                ),
                              );
                            },
                            title: Text(moviesList[index].title),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        )),
                    itemCount: moviesList.length,
                  ),
                ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  final Movie model;
  const PreviewPage(this.model, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.description),
        ),
      );
}
