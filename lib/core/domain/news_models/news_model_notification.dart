import 'package:test_app/core/domain/news_models/main_news_model.dart';

class NewsWithNotificationModel {
  final MainNewsModel model;
  final bool isNew;

  const NewsWithNotificationModel({
    required this.model,
    required this.isNew,
  });
  NewsWithNotificationModel copyWith({required bool changedIsNew}) {
    return NewsWithNotificationModel(model: model, isNew: changedIsNew);
  }
}
