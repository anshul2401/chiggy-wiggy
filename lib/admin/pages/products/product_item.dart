import 'package:chiggy_wiggy/admin/model/product_model.dart';
import 'package:chiggy_wiggy/helper.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final ProductModel model;
  ProductItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        height: 125,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: _card(context),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 5),
          child: Container(
            width: 120,
            alignment: Alignment.center,
            child: Image.network(
              model.images.first.src,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getBoldText(model.name, 16, Colors.black),
                getBoldText(model.price, 15, Colors.black),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.edit_outlined,
                        size: 25,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5),
                        primary: Colors.orangeAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.delete,
                        size: 25,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5),
                        primary: Colors.redAccent,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
