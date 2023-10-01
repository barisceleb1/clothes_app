
import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
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
          (responseBodyOfCurrentUserFavoriteListItems['currentUserCartData'] as List).forEach((eachCurrentUserFavoriteItemData )
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
    catch(errMsg)
    {
      Fluttertoast.showToast(msg: "Error:"+errMsg.toString());
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
            Padding(padding: EdgeInsets.fromLTRB(Dimensions.height16, Dimensions.height24, Dimensions.height8, Dimensions.height8),
              child: Text("My Favorite List", style: TextStyle(
                color: Colors.grey,
                fontSize: Dimensions.height16,
                fontWeight: FontWeight.w300,
              ),),),
            SizedBox(height: Dimensions.height24,),
            //------------displaying favoriteList------------
          ],
      ),


    );
  }
}
