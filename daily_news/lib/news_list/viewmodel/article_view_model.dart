import 'package:daily_news/news_list/data/api_status.dart';
import 'package:daily_news/news_list/data/news_service.dart';
import 'package:daily_news/news_list/models/article_model.dart';
import 'package:flutter/material.dart';

class ArticleViewModel extends ChangeNotifier{
  bool _loading = false;
  List<Article> _articleList = [];

  bool get loading => _loading;
  List<Article> get articleList => _articleList;

  ArticleViewModel(){
    getArticles();
  }

  setLoading(bool loading) async{
    _loading = loading;
    notifyListeners();
  }

  setArticleList(List<Article> articleList){
    _articleList = articleList;
  }

  getArticles()async{
    setLoading(true);
    var response = await NewsService.getNews();
    if(response.isNotEmpty){
      setArticleList(response);
    }
    setLoading(false);
  }
}