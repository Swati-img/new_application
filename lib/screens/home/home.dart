import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import '../../common/colors.dart';
import '../../common/common.dart';
import '../../common/widgets/no_connectivity.dart';
import '../../models/listdata_model.dart';
import '../../models/news_model.dart' as m;
import '../../providers/news_provider.dart';
import '../../screens/home/widgets/CategoryItem.dart';
import '../../screens/home/widgets/newsCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> categories = [
    'all',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  int activeCategory = 0;

  int page = 1;
  bool isFinish = false;
  bool data = false;
  List<m.News> articles = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      getNewsData();
    } else {
      Navigator.of(
        context,
        rootNavigator: true,
      )
          .push(
            MaterialPageRoute(
              builder: (context) => const NoConnectivity(),
            ),
          )
          .then(
            (value) => checkConnectivity(),
          );
    }
  }

  Future<bool> getNewsData() async {
    ListData listData = await NewsProvider()
        .GetEverything(categories[activeCategory].toString(), page++);
    // print('home listData --> $listData');
    if (listData.status) {
      List<m.News> items = listData.data as List<m.News>;
      data = true;

      if (mounted) {
        setState(() {});
      }

      if (items.length == listData.totalContent) {
        isFinish = true;
      }

      if (items.isNotEmpty) {
        articles.addAll(items);
        setState(() {});
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
              color: AppColors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.black,
        elevation: 5,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: size.width,
              child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) => CategoryItem(
                  index: index,
                  categoryName: categories[index],
                  activeCategory: activeCategory,
                  onClick: () {
                    setState(() {
                      activeCategory = index;
                      articles = [];
                      page = 1;
                      isFinish = false;
                      data = false;
                    });
                    getNewsData();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: size.height,
              child: LoadMore(
                isFinish: isFinish,
                onLoadMore: getNewsData,
                whenEmptyLoad: true,
                delegate: const DefaultLoadMoreDelegate(),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) => articles[index].author != null
                      ? NewsCard(article: articles[index])
                      : null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
