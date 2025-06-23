import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    final article = controller.article;
    final mainGreen = const Color(0xFF316B5C);

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: mainGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Text(
            article.fullDefinisi,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
