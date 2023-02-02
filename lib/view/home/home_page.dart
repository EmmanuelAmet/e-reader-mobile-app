import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_reader_app/view/home/search_book.dart';
import 'package:e_reader_app/view/home/upload_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

import '../../controller/home/home_controller.dart';
import '../../model/book/book_model.dart';
import '../../service/box.dart';
import '../../util/constants/app_string_constants.dart';
import '../../util/constants/assets_constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  final homeController = Get.put(HomeController());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var books = [];

  @override
  void dispose() {
    Hive.box(AppStringConstant.hiveBoxName).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringConstant.appName),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchBookPage(),
                );
              }),
        ],
      ),
      body: Container(
        child: ValueListenableBuilder<Box<BookModel>>(
          valueListenable: Boxes.getBoxBook().listenable(),
          builder: (context, box, _) {
            final book = box.values.toList().cast<BookModel>();
            return buildContent(book);
          },
        ),
      ),
    );
  }

  Widget buildContent(List<BookModel> bookModel) {
    if (bookModel.isEmpty) {
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(AssetsConstants.upload,
                  height: 250.0,
                  width: 250.0
              ),
              Text(AppStringConstant.noBookUploaded),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  Get.to(() => UploadPage());
                },
                child: Text(AppStringConstant.addYourFirstBook),
              ),
            ],
          ));
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              padding: const EdgeInsets.all(8),
              itemCount: bookModel.length,
              itemBuilder: (BuildContext context, int index) {
                final note = bookModel.reversed.toList()[index];
                books.add('${note.title} \n${note.path}');
                return buildBookDetail(context, note);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildBookDetail(BuildContext context, BookModel book) {
    final date = DateFormat.yMMMd().format(book.createdDate);
    final title = book.title;
    final path = book.path;

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          title.substring(0, title.length - 5),
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
          ],
        ),
        children: [
          buildButtons(context, book),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, BookModel bookModel) => Row(
    children: [
      Expanded(
        child: TextButton.icon(
            label: const Text(
              'Read',
              style: TextStyle(color: Colors.green),
            ),
            icon: const Icon(
              CupertinoIcons.book,
              color: Colors.green,
            ),
            onPressed: () async{
              VocsyEpub.setConfig(
                themeColor: Colors.green,
                identifier: "book",
                scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                allowSharing: true,
                enableTts: true,
                nightMode: false,
              );

              //***** get current locator
              VocsyEpub.locatorStream.listen((locator) {
                print('Locator: $locator');
              });

              VocsyEpub.open(bookModel.path);
            }),
      ),
      Expanded(
        child: TextButton.icon(
          label: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            CupertinoIcons.delete,
            color: Colors.red,
          ),
          onPressed: () => {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Confirm',
              desc: 'Are you sure to delete?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                //Delete note
                await widget.homeController.deleteNote(bookModel);
              },
            )..show()
          },
        ),
      )
    ],
  );
}
