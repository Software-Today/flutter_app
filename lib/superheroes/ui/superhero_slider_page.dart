import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_projects/superheroes/models/superhero.dart';
import 'package:flutter_projects/superheroes/ui/widgets/superhero_card.dart';

class SuperheroSliderPage extends StatefulWidget {
  const SuperheroSliderPage({
    Key key,
  }) : super(key: key);
  @override
  _SuperheroSliderPageState createState() => _SuperheroSliderPageState();
}

class _SuperheroSliderPageState extends State<SuperheroSliderPage> {
  PageController _pageController;
  int _index;
  int _auxIndex;
  double _percent;
  double _auxPercent;
  bool _isScrolling;

  @override
  void initState() {
    _pageController = PageController();
    _index = 0;
    _auxIndex = _index + 1;
    _percent = 0.0;
    _auxPercent = 1.0 - _percent;
    _pageController.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    super.dispose();
  }

  // PAGE VIEW LISTENER
  void _pageListener() {
    _index = _pageController.page.floor();
    _auxIndex = _index + 1;
    _percent = (_pageController.page - _index).abs();
    _auxPercent = 1.0 - _percent;

    _isScrolling = (_pageController.page % 1.0 != 0);
    setState(() {}); // refresh values on the ui
  }

  @override
  Widget build(BuildContext context) {
    final heroes = Superhero.marvelHeroes;
    final angleRotate = (-pi * .5);
    return Scaffold(
      appBar: AppBar(
        title: Text("movies"),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          // SUPERHERO CARDS
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0,
            bottom: 0,
            right: _isScrolling ? 10 : 0,
            left: _isScrolling ? 10 : 0,
            child: Stack(
              children: [
                // BACK CARD
                Transform.translate(
                  offset: Offset(0, 50 * _auxPercent),
                  child: SuperheroCard(
                    superhero: heroes[_auxIndex.clamp(0, heroes.length - 1)],
                    factorChange: _auxPercent,
                  ),
                ),
                // FRONT CARD
                Transform.translate(
                  offset: Offset(-800 * _percent, 100 * _percent),
                  child: Transform.rotate(
                    angle: angleRotate * _percent,
                    child: SuperheroCard(
                      superhero: heroes[_index],
                      factorChange: _percent,
                    ),
                  ),
                )
              ],
            ),
          ),
          // VOID PAGE VIEW
          // This pageview is just for using the pagecontroller
          PageView.builder(
            controller: _pageController,
            itemCount: heroes.length,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }

}
