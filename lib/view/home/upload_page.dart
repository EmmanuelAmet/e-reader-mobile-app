import 'dart:io';

import 'package:e_reader_app/util/constants/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'book_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Choose Epub'),
          onPressed: () async{
            final result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['epub']
            );
            if(result == null) return;

            final file = result.files.first;

            final newFile = await saveFile(file);

            openFiles(result.files);
          },
        ),
      ),
    );
  }

  void openFiles(List<PlatformFile> files) =>
      Get.to(
          BookPage(files: files, onOpenedFile: openFile)
      );

  void openFile(PlatformFile file){
    VocsyEpub.setConfig(
      themeColor: AppColor.primary,
      identifier: "book",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: false,
      enableTts: true,
      nightMode: false,
    );

    VocsyEpub.open(file.path!);
  }

  Future<File> saveFile(PlatformFile file) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}
