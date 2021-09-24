import 'package:chiggy_wiggy/api_service.dart';
import 'package:chiggy_wiggy/config.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:chiggy_wiggy/models/category.dart' as cat;
import 'package:chiggy_wiggy/models/product.dart';
import 'package:chiggy_wiggy/pages/cart.dart';
import 'package:chiggy_wiggy/pages/login_page.dart';
import 'package:chiggy_wiggy/pages/products_list.dart';
import 'package:chiggy_wiggy/provider/cart_provider.dart';
import 'package:chiggy_wiggy/utils/carausel.dart';
import 'package:chiggy_wiggy/utils/card_carousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  APIService apiService = APIService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    apiService.getCategories();
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.1),
      key: _scaffoldKey,
      drawer: _openDrawer(),
      // appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBarPartTwo(
              getThemeColor(),
              getThemeColor(),
              'CHIGGY WIGGY',
            ),
            SizedBox(
              height: 10,
            ),
            getRoundCategory(),
            SizedBox(
              height: 15,
            ),
            CarouselWithIndicatorDemo(),
            // SizedBox(
            //   height: 5,
            // ),
            Image.asset('assets/images/banne1.png'),

            getText('Explore By Category'),

            _categoriesList(),

            getText('Popular'),
            SizedBox(
              height: 10,
            ),
            _productsList(Config.popularIdTag),
            SizedBox(
              height: 10,
            ),
            // card.BasicDemo(),
          ],
        ),
      ),
    );
  }

  Drawer _openDrawer() {
    int _selectedDestination = 0;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Header',
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Item 1'),
            selected: _selectedDestination == 0,
            onTap: () => selectDestination(0),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Item 2'),
            selected: _selectedDestination == 1,
            onTap: () => selectDestination(1),
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Text('Item 3'),
            selected: _selectedDestination == 2,
            onTap: () => selectDestination(2),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Label',
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Item A'),
            selected: _selectedDestination == 3,
            onTap: () => selectDestination(3),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0,
      title: Text(
        'Chiggy Wiggy',
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            color: Color.fromRGBO(244, 91, 85, 1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          size: 30,
        ),
        color: Color.fromRGBO(244, 91, 85, 1),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cart(true),
              ),
            );
          },
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 30,
          ),
          color: Color.fromRGBO(244, 91, 85, 1),
        ),
      ],
    );
  }

  Padding getText(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        top: 10,
      ),
      child: Text(
        text,
        style: GoogleFonts.varelaRound(
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column getCategory(String itemName, String itemURL) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width / 2 - 10,
          margin: EdgeInsets.all(10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(itemURL)),
        ),
        Text(itemName,
            style: GoogleFonts.varelaRound(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
      ],
    );
  }

  Widget _buildCategoryList(List<cat.Category> category) {
    category.removeLast();
    return Container(
        alignment: Alignment.center,
        height: 364,
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: category.map((cat.Category cat) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductList(
                                categoryId: cat.categoryId,
                                categoryName: cat.categoryName,
                              )));
                },
                child: Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 2 - 22,
                      margin: EdgeInsets.all(10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(cat.image.url)),
                    ),
                    Text(cat.categoryName,
                        style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)))
                  ],
                ),
              );
            }).toList()));
  }

  Widget _categoriesList() {
    return new FutureBuilder(
        future: apiService.getCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<cat.Category>> model) {
          if (model.hasData) {
            return _buildCategoryList(model.data.toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _productsList(String tagId) {
    return new FutureBuilder(
        future: apiService.getProducts(tagId),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
          if (model.hasData) {
            return CardCarousal(product: model.data.toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildAppBarPartTwo(
      Color lightColor, Color darkColor, String heading) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 95,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                lightColor,
                darkColor,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
                color: Colors.white,
                textColor: Colors.black,
                child: Icon(
                  Icons.menu,
                  size: 18,
                ),
                padding: EdgeInsets.all(5),
                shape: CircleBorder(),
              ),
              Text(
                heading,
                style: GoogleFonts.bevan(
                  textStyle: TextStyle(
                      fontSize: 19,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                textAlign: TextAlign.start,
              ),
              // Container(
              //   width: 50,
              //   child: Image.asset('assets/images/chiggywiggy.png'),
              // ),
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser == null
                      ? Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart(true)));
                },
                color: Colors.white,
                textColor: Colors.black,
                child: Stack(alignment: Alignment.topRight, children: [
                  Icon(
                    Icons.shopping_cart_rounded,
                    size: 18,
                  ),
                  Provider.of<CartProvider>(context, listen: false)
                              .cartItems
                              .length !=
                          0
                      ? new Positioned(
                          top: 0,
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            child: Text(
                              Provider.of<CartProvider>(context, listen: false)
                                  .cartItems
                                  .length
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container(
                          padding: EdgeInsets.all(2),
                          width: 0,
                          height: 0,
                        )
                ]),
                padding: EdgeInsets.all(5),
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
        ),
      ],
    );
  }

  selectDestination(int i) {}
  Widget getRoundCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        getCircleCat('Chicken', 'assets/images/chicken_darkred_icon.png', 31),
        getCircleCat('Mutton', 'assets/images/goat_darkred_icon.png', 30),
        getCircleCat('Sea Food', 'assets/images/fish_darkred_icon.png', 33),
      ],
    );
  }

  Widget getCircleCat(String catName, String img, int catId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductList(
                      categoryId: catId,
                      categoryName: catName,
                    )));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(img),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 5,
          ),
          getBoldText(catName, 12, Colors.black)
        ],
      ),
    );
  }
}
