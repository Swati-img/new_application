import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import '../../common/colors.dart';
import '../models/listdata_model.dart';
import '../models/news_model.dart';
import '../services/Api.dart';

class NewsProvider {
  Future<ListData> GetEverything(String keyword, int page) async {
    ListData articles = ListData([], 0, false);
    try {
      await ApiService().getEverything(keyword, page).then((response) {
        // print('response --> $response');
        if (response.statusCode == 200) {
          Iterable data = jsonDecode(response.body)['articles'];
          articles = ListData(
            data.map((e) => News.fromJson(e)).toList(),
            jsonDecode(response.body)['totalResults'],
            true,
          );
        } else {
          Fluttertoast.showToast(
            msg: jsonDecode(response.body)['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.lighterGray,
            textColor: AppColors.black,
            fontSize: 16.0,
          );
          throw Exception(response.statusCode);
        }
      }).catchError((err) {
        print('error $err');
      });
    } catch (e) {
      print('Error occurred: $e');
    }

    return articles;
  }
}
