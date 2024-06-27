import 'package:fire_login/blocs/news/news_bloc.dart';
import 'package:fire_login/blocs/news/news_state.dart';
import 'package:fire_login/screens/news/newmodel.dart';
import 'package:fire_login/screens/news/newsdelatils.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Trending News',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<NewsBloc, NewsStates>(
                builder: (context, state) {
                  if (state is NewsLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is NewsLoadedState) {
                    List<Articles> newsList = state.newsList;
                    List<String> imgList = newsList
                        .where((article) => article.urlToImage != null)
                        .map((article) => article.urlToImage!)
                        .toList();

                    return NewsCarousel(imgList: imgList, articles: newsList);
                  } else if (state is NewsErrorState) {
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Latest Articles',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            BlocBuilder<NewsBloc, NewsStates>(
              builder: (context, state) {
                if (state is NewsLoadingState) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is NewsLoadedState) {
                  List<Articles> newsList = state.newsList;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return NewsCard(
                          article: newsList[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailPage(article: newsList[index]),
                              ),
                            );
                          },
                        );
                      },
                      childCount: newsList.length,
                    ),
                  );
                } else if (state is NewsErrorState) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.errorMessage)),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCarousel extends StatefulWidget {
  final List<String> imgList;
  final List<Articles> articles;

  NewsCarousel({required this.imgList, required this.articles});

  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.imgList.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(article: widget.articles[index]),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(item, fit: BoxFit.cover, width: 1000),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == entry.key ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final Articles article;
  final VoidCallback onTap;

  NewsCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                article.urlToImage ?? 'https://example.com/placeholder.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    article.description ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Read More',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 