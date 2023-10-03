
import 'dart:convert';


import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/item/item_details_screen.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/favorite.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;


class FavoritesFragmentScreen extends StatelessWidget {

final currentOnlineUser= Get.put(CurrentUser());

 Future<List<Favorite>> getCurrentUserFavoriteList() async
  {
    List<Favorite> favoriteListOfCurrentUser = [];

    try
    {
      var res = await http.post(Uri.parse(API.readFavorite),
          body:
          {
            "user_id": currentOnlineUser.user.user_id.toString(),

          }
      );
      if(res.statusCode == 200)
      {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if(responseBodyOfCurrentUserFavoriteListItems['success'] == true )
        {
          (responseBodyOfCurrentUserFavoriteListItems['currentUserFavoriteData'] as List).forEach((eachCurrentUserFavoriteItemData )
          {
            favoriteListOfCurrentUser.add(Favorite.fromJson(eachCurrentUserFavoriteItemData));

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
      Fluttertoast.showToast(msg: "Error:"+errorMsg.toString());
    }
    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.fromLTRB(Dimensions.height16, Dimensions.height24, Dimensions.height8, Dimensions.height8),
            child: Text("My Favorite List", style: TextStyle(
              color: Colors.red,
              fontSize: Dimensions.height30,
              fontWeight: FontWeight.bold,
            ),),),
            Padding(padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
              child: Text("Order these best clothes for yourself now.", style: TextStyle(
                color: Colors.grey,
                fontSize: Dimensions.height16,
                fontWeight: FontWeight.w300,
              ),),),
            SizedBox(height: Dimensions.height24,),
            //------------displaying favoriteList------------
            favoriteListItemDesignWidget(context),
          ],
      ),


    );
  }

favoriteListItemDesignWidget(context) {
  return FutureBuilder(
      future: getCurrentUserFavoriteList(),
      builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot)
      {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null)
        {
          return const Center(
            child: Text(
              "Not favorite item found",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                Clothes clickedClothItem = Clothes(
                  item_id: eachFavoriteItemRecord.item_id,
                  colors: eachFavoriteItemRecord.colors,
                  image: eachFavoriteItemRecord.image,
                  name: eachFavoriteItemRecord.name,
                  price: eachFavoriteItemRecord.price,
                  rating: eachFavoriteItemRecord.rating,
                  sizes: eachFavoriteItemRecord.sizes,
                  description: eachFavoriteItemRecord.description,
                  tags: eachFavoriteItemRecord.tags,



                );

                return GestureDetector(
                  onTap: () {
                    Get.to(ItemDetailsScreen(itemInfo: clickedClothItem,));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        Dimensions.height16,
                        index == 0 ? Dimensions.height16 : Dimensions.height8,
                        Dimensions.height16,
                        index == dataSnapShot.data!.length - 1
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
                      children:[
                      //--------name+price-------
                      //--------tags---------

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
                                          eachFavoriteItemRecord.name!,
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
                                              eachFavoriteItemRecord.price.toString(),
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
                                        eachFavoriteItemRecord.tags
                                            .toString()
                                            .replaceAll("[", "")
                                            .replaceAll("]", ""),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimensions.height12,
                                      color: Colors.grey,
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
                            image: NetworkImage(eachFavoriteItemRecord.image!),
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
            child: Text("Empty no data",style: TextStyle(color: Colors.white),),
          );
        }
      }
      );
}
}
