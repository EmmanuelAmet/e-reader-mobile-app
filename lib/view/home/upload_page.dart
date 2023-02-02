import 'dart:io';

import 'package:e_reader_app/util/constants/assets_constants.dart';
import 'package:e_reader_app/view/dashboard/DashboardPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

import '../../controller/note/book_controller.dart';

class UploadPage extends StatelessWidget {
  UploadPage({Key? key}) : super(key: key);
  //***** Dependency Injection
  final bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload"),
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
                Get.offAll(() => DashboardPage());
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

  Future<File> saveFile(PlatformFile file) async{
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }
}
