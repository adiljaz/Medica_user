import 'dart:convert';
import 'package:fire_login/screens/news/newmodel.dart';
import 'package:http/http.dart' as http;

class NewsaRepository {
  Future<List<Articles>> fetchNews() async {
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=8d79c652be654febac0fc46ef4ae5ef3'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Articles> newsList = [];
      for (var item in data['articles']) {
        newsList.add(Articles.fromJson(item));
      }
      return newsList;
    } else {
      throw Exception('Failed to load news');
    }
  }
}
