import 'package:daily_news/view/screens/news_posts.dart';
import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: NewsPosts(),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
                "NNews",
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 40,
                ),
        )
      )
      ,
      body: NewsPosts(),
    );
  }

  
}