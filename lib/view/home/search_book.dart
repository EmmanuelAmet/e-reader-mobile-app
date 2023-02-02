// @dart=2.9
import 'package:e_reader_app/util/constants/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../../model/book/book_model.dart';
import '../../service/box.dart';

class SearchBookPage extends SearchDelegate<BookModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //***** Clearing the search field
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //***** Returning back to home
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchFinder(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchFinder(query: query);
  }
}

class SearchFinder extends StatelessWidget {
  final String query;

  const SearchFinder({Key key, this.query}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Boxes.getBoxBook().listenable(),
      builder: (context, Box<BookModel> contactsBox, _) {
        //***** Filtering data
        var results = query.isEmpty
            ? contactsBox.values.toList()
            : contactsBox.values
            .where((c) =>
        c.title.toLowerCase().contains(query) ||
            c.createdDate.toString().toLowerCase().contains(query))
            .toList();

        return results.isEmpty
            ? Center(
          child: Lottie.asset(AssetsConstants.upload,
              height: 300, width: 300),
        )
            : ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final BookModel bookModel = results[index];
            return ListTile(
              onTap: () {
                VocsyEpub.setConfig(
                  themeColor: Colors.green,
                  identifier: "book",
                  scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                  allowSharing: true,
                  enableTts: true,
                  nightMode: false,
                );
                //***** get current locator
                VocsyEpub.locatorStream.listen((locator) {});

                VocsyEpub.open(bookModel.path);
              },
              title: Text(
                bookModel.title.substring(0, bookModel.title.length - 5),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookModel.title),
                  Text(
                      DateFormat
                          .yMMMd()
                          .format(bookModel.createdDate)),
                  Divider()
                ],
              ),
            );
          },
        );
      },
    );
  }
}
