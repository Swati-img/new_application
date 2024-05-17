import 'package:http/http.dart' as http;
// import 'package:news_app/common/constants.dart';

class ApiService {
  var client = http.Client();
  String endpoint = 'https://newsapi.org/v2';
  // String endpoint = Constants.API_BASE_URL + Constants.API_PREFIX;
  String apiKey = 'f029c4accc9e404e9844d7e34cf5ba39';
  // String apiKey = Constants.API_KEY;

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Accept": "application/json"
  };

  Future<http.Response> getTopHeadlines() {
    return client.get(
      Uri.parse('$endpoint/top-headlines?country=us&apiKey=$apiKey'),
      headers: headers,
    );
  }

  Future<http.Response> getEverything(String keyword, int page) async {
    // print('keyword --> $keyword');
    return await http.get(
        // Uri.parse('https://newsapi.org/v2/everything?q=business&from=2024-04-14&sortBy=popularity&apiKey=f029c4accc9e404e9844d7e34cf5ba39')
        Uri.parse(
            '$endpoint/everything?q=$keyword&language=en&sortBy=publishedAt&page=$page&apiKey=$apiKey')
        // headers: headers,
        );
  }
}