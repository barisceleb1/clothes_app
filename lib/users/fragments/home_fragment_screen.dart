import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>?> getTrendingClothItems() async
  {
    List<Clothes> trendingClothItemsList = [];

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.height16,),
          //------search bar widget--------------
          showSearchBarWidget(),
          SizedBox(height: Dimensions.height24,),
          //-------trending-popular items---------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height18),
            child: Text("Trending",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.height24,
            ),),
          ),
          SizedBox(height: Dimensions.height24,),
          //--------all new collections/items----------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height18),
            child: Text("New Collections",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.height24,
              ),),
          )
        ],
      ),

    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.height18),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.purpleAccent,
                )),
            hintText: "Search best clothes here ",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: Dimensions.height12,
            ),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart),
              color: Colors.purpleAccent,
            ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: Dimensions.height3,
            color: Colors.purpleAccent
          )
        ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: Dimensions.height3,
                  color: Colors.purple
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: Dimensions.height3,
                  color: Colors.purpleAccent
              )
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.height16,
            vertical: Dimensions.height10,
          ),
          fillColor: Colors.black,
          filled: true,
        ),
      ),
    );
  }
}
