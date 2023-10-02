import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchItems extends StatefulWidget {

final String? typeKeywords;
SearchItems({this.typeKeywords});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {

    super.initState();
    searchController.text = widget.typeKeywords!;
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
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
              onPressed: () {


              },
              icon: Icon(
                Icons.search,
                color: Colors.red,
              )),
          hintText: "Search best clothes here ",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.height12,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              Get.to(CartListScreen());
            },
            icon: Icon(Icons.shopping_cart),
            color: Colors.red,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(width: Dimensions.height3, color: Colors.red)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: Dimensions.height3, color: Colors.red)),
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
