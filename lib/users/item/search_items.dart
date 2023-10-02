import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/favorite.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class SearchItems extends StatefulWidget {

final String? typeKeywords;
SearchItems({this.typeKeywords});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future <List<Clothes>> readSearchRecordFound() async
  {
    List<Clothes> clothesSearchList = [];

    if(searchController.text!= "")
      {
        try
            {
              var res = await http.post(Uri.parse(API.searchItems),
                body:
                {
                  "typedKeywords" : searchController.text,

                }
              );
              if(res.statusCode == 200)
                {
                  var responseBodyOfSearchItems = jsonDecode(res.body);
                  if(responseBodyOfSearchItems['success'] == true)
                    {
                      (responseBodyOfSearchItems ['itemsFoundData'] as List).forEach((eachItemData) {
                        clothesSearchList.add(Clothes.fromJson(eachItemData));


                      });
                    }

                }
              else
                {
                  Fluttertoast.showToast(msg: "Status Code is not 200");
                }

            }
            catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error :" +errorMsg.toString());
    }
      }
    return clothesSearchList;
  }


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
