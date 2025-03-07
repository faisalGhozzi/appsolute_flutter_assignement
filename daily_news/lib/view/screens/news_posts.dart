import 'package:daily_news/model/article.dart';
import 'package:daily_news/view/screens/favorites_page.dart';
import 'package:daily_news/view/screens/search_form.dart';
import 'package:daily_news/view/screens/show_details.dart';
import 'package:daily_news/viewmodel/article_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_news/model/services/helper_functions.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:loadmore/loadmore.dart';
class NewsPosts extends StatefulWidget {
  const NewsPosts({Key? key}) : super(key: key);

  @override
  _NewsPostsState createState() => _NewsPostsState();
}

class _NewsPostsState extends State<NewsPosts> {
  List<Article> items = [];
  String _selectedCountry="fr";
  TextEditingController search = TextEditingController();

  int page = 1;

  @override
  void initState() {
    super.initState();
        Provider.of<ArticleViewModel>(context, listen: false)
        .topHeadlinesByCountry(country: _selectedCountry);
  }

  Widget _buildList(ArticleViewModel articleView) {
    switch (articleView.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _ui(articleView) 
        );
      case LoadingStatus.empty:
      default:
        return const Center(
          child: Text("No results found"),
        );
    }
  }

 void _selectCountry(ArticleViewModel articleViewModel, String country, int page){
    articleViewModel.topHeadlinesByCountry(country: country);
  }

  @override
  Widget build(BuildContext context) {
    var articleView = Provider.of<ArticleViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => SearchForm()
                  )
                  );
            }, 
            icon: const Icon(Icons.search)),
        centerTitle: true,
        title: const Text(
                "NewsFeed",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: "News by country",
            onSelected: (value) {
              articleView.articles.clear();
              setState(() {
                _selectedCountry=value;
                _selectCountry(articleView, _selectedCountry, 1);
              });
            },
              icon: const Icon(Icons.language),
              itemBuilder: (_) {
                return Countries.keys.map((e) => PopupMenuItem(
                  value: Countries[e],
                  child: Text(e)
                  )
                ).toList();
              },
            ),
         
          ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildList(articleView),
            ),
          ],
        ),
      ),
      
      floatingActionButton: Tooltip(
        richMessage: const TextSpan(text: 'Saved articles'),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FavoritesPage()
                ));
          },
          backgroundColor: Colors.red,
          child:  const Icon(Icons.favorite),
        ),
      )
    );
  }

  static const Map<String, String> Countries = {
    "Françe" : "fr",
    "England": "gb",
  };

  _ui(ArticleViewModel articleViewModel) {
    return articleViewModel.articles.isNotEmpty ? ListView.separated(
        itemBuilder: ((context, index) {
          Article article = articleViewModel.articles[index];
          return Container(
            padding: const EdgeInsets.all(2),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ShowDetails(article: article)));
              },
              title: Text(
                article.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text("Source : " + article.source.name),
              leading: Container(
                width: MediaQuery.of(context).size.width * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: !HelperFunctions.urlExtension(article.urlToImage)
                        ? Image.network(
                            article.urlToImage,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return const CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Text("Image unavailable");
                            },
                          ).image
                        : Svg(
                            article.urlToImage,
                            source: SvgSource.network,
                          ),
                  ),
                ),
              ),
            ),
          );
        }),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: articleViewModel.articles.length) : const Center(child: CircularProgressIndicator(color: Colors.red),);
  }
}