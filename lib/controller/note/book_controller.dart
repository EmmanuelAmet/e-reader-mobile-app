import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../model/book/book_model.dart';
import '../../service/box.dart';
import '../../util/constants/app_string_constants.dart';

class BookController extends GetxController {

  Future addBook(String title, String path) async {
    final book = BookModel()
      ..title = title
      ..createdDate = DateTime.now()
      ..path = path;

    final box = Boxes.getBoxBook();
    box.add(book);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    closeBox();
    super.onClose();
  }

  closeBox() {
    Hive.box(AppStringConstant.hiveBoxName).close();
  }
}
