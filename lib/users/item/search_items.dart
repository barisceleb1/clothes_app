import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/favorite.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class SearchItems extends StatefulWidget {

final String? typedKeyWords;
SearchItems({this.typedKeyWords});

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
                  "typedKeyWords" : searchController.text,

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
    searchController.text = widget.typedKeyWords!;
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
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.red,)),
      ),
      body: searchItemDesignWidget(context),


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
                setState(() {

                });
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
              searchController.clear();
              setState(() {

              });
            },
            icon: Icon(Icons.close),
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

  searchItemDesignWidget(context) {
    return FutureBuilder(
        future: readSearchRecordFound(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
            return const Center(
              child: Text("Empty no data"),
            );
          }
        });
  }


}
