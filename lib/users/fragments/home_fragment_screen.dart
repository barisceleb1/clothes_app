import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/item/search_items.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> getTrendingClothItems() async {
    List<Clothes> trendingClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getTrendingMostPopularClothes));
      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["clothItemsData"] as List)
              .forEach((eachRecord) {
            trendingClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
    }
    return trendingClothItemsList;
  }

  Future<List<Clothes>> getAllClothItems() async {
    List<Clothes> allClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllClothes));
      if (res.statusCode == 200) {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if (responseBodyOfAllClothes["success"] == true) {
          (responseBodyOfAllClothes["clothItemsData"] as List)
              .forEach((eachRecord) {
            allClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error::" + errorMsg.toString());
    }
    return allClothItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Dimensions.height16,
          ),
          //-----------search bar widget--------------
          showSearchBarWidget(),
          SizedBox(
            height: Dimensions.height24,
          ),
          //-------trending-popular items---------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height18),
            child: Text(
              "Trending",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.height24,
              ),
            ),
          ),
          trendingMostPopularClothItemWidget(context),
          SizedBox(
            height: Dimensions.height24,
          ),
          //--------all new collections/items----------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height18),
            child: Text(
              "New Collections",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.height24,
              ),
            ),
          ),
          allItemWidget(context),
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
              onPressed: () {

                Get.to(SearchItems(typedKeyWords: searchController.text));
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

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
        future: getTrendingClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapshot) {
         if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Dimensions.height260,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Shimmer.fromColors(

                    baseColor: Colors.white,
                    highlightColor: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          width: Dimensions.width200,
                          margin: EdgeInsets.fromLTRB(
                            Dimensions.height16 ,
                            Dimensions.height10,
                            Dimensions.height16,
                            Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.grey),
                              ]),
                          child: Column(
                            children: [
                              //-----------item image----------
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height22),
                                  topRight: Radius.circular(Dimensions.height22),
                                ),
                                child: Container(
                                  height: Dimensions.height150,
                                  width: Dimensions.height200,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.height8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //-----------item name & price----------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height8,
                                    ),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, c) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (updateRating) {},
                                          ignoreGestures: true,
                                          unratedColor: Colors.grey,
                                          itemSize: Dimensions.height20,
                                        ),
                                        SizedBox(
                                          width: Dimensions.width8,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Dimensions.width200,
                          margin: EdgeInsets.fromLTRB(
                            Dimensions.height16 ,
                            Dimensions.height10,
                            Dimensions.height16,
                            Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.grey),
                              ]),
                          child: Column(
                            children: [
                              //-----------item image----------
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height22),
                                  topRight: Radius.circular(Dimensions.height22),
                                ),
                                child: Container(
                                  height: Dimensions.height150,
                                  width: Dimensions.height200,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.height8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //-----------item name & price----------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height8,
                                    ),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, c) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (updateRating) {},
                                          ignoreGestures: true,
                                          unratedColor: Colors.grey,
                                          itemSize: Dimensions.height20,
                                        ),
                                        SizedBox(
                                          width: Dimensions.width8,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Dimensions.width200,
                          margin: EdgeInsets.fromLTRB(
                            Dimensions.height16 ,
                            Dimensions.height10,
                            Dimensions.height16,
                            Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.grey),
                              ]),
                          child: Column(
                            children: [
                              //-----------item image----------
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height22),
                                  topRight: Radius.circular(Dimensions.height22),
                                ),
                                child: Container(
                                  height: Dimensions.height150,
                                  width: Dimensions.height200,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.height8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //-----------item name & price----------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height8,
                                    ),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, c) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (updateRating) {},
                                          ignoreGestures: true,
                                          unratedColor: Colors.grey,
                                          itemSize: Dimensions.height20,
                                        ),
                                        SizedBox(
                                          width: Dimensions.width8,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: Dimensions.width200,
                          margin: EdgeInsets.fromLTRB(
                            Dimensions.height16 ,
                            Dimensions.height10,
                            Dimensions.height16,
                            Dimensions.height10,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.grey),
                              ]),
                          child: Column(
                            children: [
                              //-----------item image----------
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimensions.height22),
                                  topRight: Radius.circular(Dimensions.height22),
                                ),
                                child: Container(
                                  height: Dimensions.height150,
                                  width: Dimensions.height200,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.height8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //-----------item name & price----------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Dimensions.width10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height8,
                                    ),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, c) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (updateRating) {},
                                          ignoreGestures: true,
                                          unratedColor: Colors.grey,
                                          itemSize: Dimensions.height20,
                                        ),
                                        SizedBox(
                                          width: Dimensions.width8,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
            ),

          );

          }
          if (dataSnapshot.data == null) {
            return const Center(
              child: Text("No trending item found"),
            );
          }
          if (dataSnapshot.data!.length > 0 ) {
            return SizedBox(
              height: Dimensions.height260,
              child: ListView.builder(
                itemCount: dataSnapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Clothes eachClothItemData = dataSnapshot.data![index];
                  return GestureDetector(
                    onTap: ()
                    {
                      Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                    },
                    child: Container(
                      width: Dimensions.width200,
                      margin: EdgeInsets.fromLTRB(
                        index == 0 ? Dimensions.height16 : Dimensions.height8,
                        Dimensions.height10,
                        index == dataSnapshot.data!.length - 1
                            ? Dimensions.height16
                            : Dimensions.height8,
                        Dimensions.height10,
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Colors.grey),
                          ]),
                      child: Column(
                        children: [
                          //-----------item image----------
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.height22),
                              topRight: Radius.circular(Dimensions.height22),
                            ),
                            child: FadeInImage(
                              height: Dimensions.height150,
                              width: Dimensions.height200,
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage("assets/place_holder.png"),
                              image: NetworkImage(eachClothItemData.image!),
                              imageErrorBuilder:
                                  (context, error, stackTraceError) {
                                return const Center(
                                  child: Icon(Icons.broken_image_outlined),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(Dimensions.height8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //-----------item name & price----------
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachClothItemData.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimensions.height16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimensions.width10,
                                    ),
                                    Text(
                                      eachClothItemData.price.toString(),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: Dimensions.height18,
                                      fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height8,
                                ),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: eachClothItemData.rating!,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, c) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (updateRating) {},
                                      ignoreGestures: true,
                                      unratedColor: Colors.grey,
                                      itemSize: Dimensions.height20,
                                    ),
                                    SizedBox(
                                      width: Dimensions.width8,
                                    ),
                                    Text(
                                      "(" +
                                          eachClothItemData.rating.toString() +
                                          ")",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
                child: Container(
                    height:Dimensions.height180,
                    child: Image(image: AssetImage("assets/no_data.png")))
            );
          }
        });
  }

  allItemWidget(context) {
    return FutureBuilder(
        future: getAllClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Shimmer.fromColors(
                highlightColor: Colors.transparent,
                baseColor: Colors.white,
                child: Column(
                  children: [Container(
                            margin: EdgeInsets.fromLTRB(
                                Dimensions.height16,
                                Dimensions.height16 ,
                                Dimensions.height16,
                                Dimensions.height16
                                   ),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(Dimensions.height20),
                                color: Colors.black,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: Colors.grey),
                                ]),
                            child: Row(
                              children:
                              //--------name+price-------
                              //tags
                              [
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: Dimensions.height15,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //----------name and price---------
                                          Row(
                                            children: [
                                              //-----------Price------------
                                              Padding(
                                                padding: EdgeInsets.only(left: Dimensions.height12,right: Dimensions.height12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Dimensions.height16,
                                          ),
                                        ],
                                      ),
                                    )),
                                //------image clothes--------
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(Dimensions.height20),
                                    bottomRight: Radius.circular(Dimensions.height20),
                                  ),
                                    child: Container(
                                        height: Dimensions.height130,
                                        width: Dimensions.height130,
                                      ),



                                ),
                  ],
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.height16,
                          Dimensions.height16 ,
                          Dimensions.height16,
                          Dimensions.height16
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.height20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.grey),
                          ]),
                      child: Row(
                        children:
                        //--------name+price-------
                        //tags
                        [
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.height15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //----------name and price---------
                                    Row(
                                      children: [
                                        //-----------Price------------
                                        Padding(
                                          padding: EdgeInsets.only(left: Dimensions.height12,right: Dimensions.height12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height16,
                                    ),
                                  ],
                                ),
                              )),
                          //------image clothes--------
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.height20),
                              bottomRight: Radius.circular(Dimensions.height20),
                            ),
                            child: Container(
                              height: Dimensions.height130,
                              width: Dimensions.height130,
                            ),



                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.height16,
                          Dimensions.height16 ,
                          Dimensions.height16,
                          Dimensions.height16
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.height20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.grey),
                          ]),
                      child: Row(
                        children:
                        //--------name+price-------
                        //tags
                        [
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.height15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //----------name and price---------
                                    Row(
                                      children: [
                                        //-----------Price------------
                                        Padding(
                                          padding: EdgeInsets.only(left: Dimensions.height12,right: Dimensions.height12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height16,
                                    ),
                                  ],
                                ),
                              )),
                          //------image clothes--------
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.height20),
                              bottomRight: Radius.circular(Dimensions.height20),
                            ),
                            child: Container(
                              height: Dimensions.height130,
                              width: Dimensions.height130,
                            ),



                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.height16,
                          Dimensions.height16 ,
                          Dimensions.height16,
                          Dimensions.height16
                      ),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.height20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.grey),
                          ]),
                      child: Row(
                        children:
                        //--------name+price-------
                        //tags
                        [
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.height15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //----------name and price---------
                                    Row(
                                      children: [
                                        //-----------Price------------
                                        Padding(
                                          padding: EdgeInsets.only(left: Dimensions.height12,right: Dimensions.height12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height16,
                                    ),
                                  ],
                                ),
                              )),
                          //------image clothes--------
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.height20),
                              bottomRight: Radius.circular(Dimensions.height20),
                            ),
                            child: Container(
                              height: Dimensions.height130,
                              width: Dimensions.height130,
                            ),



                          ),
                        ],
                      ),
                    ),]
                ),
              ),
            );
                }
          if (dataSnapshot.data == null) {
            return const Center(
              child: Text(
                "Not all item found",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (dataSnapshot.data!.length > 0) {
            return ListView.builder(
                itemCount: dataSnapshot.data!.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  Clothes eachClothItemRecord = dataSnapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord,));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimensions.height16,
                          index == 0 ? Dimensions.height16 : Dimensions.height8,
                          Dimensions.height16,
                          index == dataSnapshot.data!.length - 1
                              ? Dimensions.height16
                              : Dimensions.height8),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.height20),
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.grey),
                          ]),
                      child: Row(
                        children:
                            //--------name+price-------
                            //tags
                            [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.only(
                              left: Dimensions.height15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //----------name and price---------
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachClothItemRecord.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Dimensions.height18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    //-----------Price------------
                                    Padding(
                                      padding: EdgeInsets.only(left: Dimensions.height12,right: Dimensions.height12),
                                      child: Text(
                                        "\₺" +
                                            eachClothItemRecord.price.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: Dimensions.height18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dimensions.height16,
                                ),
                                Text(
                                  "Tags: \n" +
                                      eachClothItemRecord.tags
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Dimensions.height12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )),
                              //------image clothes--------
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.height20),
                                  bottomRight: Radius.circular(Dimensions.height20),
                                ),
                                child: FadeInImage(
                                  height: Dimensions.height130,
                                  width: Dimensions.height130,
                                  fit: BoxFit.cover,
                                  placeholder:
                                  const AssetImage("assets/place_holder.png"),
                                  image: NetworkImage(eachClothItemRecord.image!),
                                  imageErrorBuilder:
                                      (context, error, stackTraceError) {
                                    return const Center(
                                      child: Icon(Icons.broken_image_outlined),
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return  Center(
                child: Container(
                    height:Dimensions.height180,
                    child: Image(image: AssetImage("assets/no_data.png")))
            );
          }
        });
  }
}
