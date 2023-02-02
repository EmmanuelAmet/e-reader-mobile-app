import 'dart:io';

import 'package:e_reader_app/util/constants/assets_constants.dart';
import 'package:e_reader_app/view/dashboard/DashboardPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../../controller/note/book_controller.dart';
import 'book_page.dart';

class UploadPage extends StatelessWidget {
  UploadPage({Key? key}) : super(key: key);
  //***** Dependency Injection
  final bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AssetsConstants.upload,
              height: 250.0,
              width: 250.0
            ),
            ElevatedButton(
              onPressed: () async{
                final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['epub']
                );
                if(result == null) return;

                final file = result.files.first;

                final newFile = await saveFile(file);
                bookController.addBook(file.name, newFile.path);
                Get.to(DashboardPage());
              },
              child: Text(
                "Choose epub file",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      )
    );
  }

  void openFiles(List<PlatformFile> files) =>
      Get.to(
          BookPage(files: files, onOpenedFile: openFile)
      );

  void openFile(PlatformFile file){
    VocsyEpub.setConfig(
      themeColor: Colors.green,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    // get current locator
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });

    VocsyEpub.open(
      file.path!,
    );
  }

  Future<File> saveFile(PlatformFile file) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}
