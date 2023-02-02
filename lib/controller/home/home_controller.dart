import 'package:get/get.dart';

import '../../model/book/book_model.dart';

class HomeController extends GetxController {

  @override
  void onInit() async {
    super.onInit();
  }

  //***** Delete book
  deleteNote(BookModel bookModel) {
    bookModel.delete();
  }
}
