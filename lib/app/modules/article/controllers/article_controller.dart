import 'package:get/get.dart';
import 'package:therapalsy_capstone/app/modules/models/article_model.dart';

class ArticleController extends GetxController {
  late Article article;

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as Article;
  }
}
