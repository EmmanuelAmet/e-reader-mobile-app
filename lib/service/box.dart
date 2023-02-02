import 'package:hive/hive.dart';

import '../model/book/book_model.dart';
import '../util/constants/app_string_constants.dart';

class Boxes {
  static Box<BookModel> getBoxBook() =>
      Hive.box<BookModel>(AppStringConstant.hiveBoxName);
}
