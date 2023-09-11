import 'dart:convert';


import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> getTrendingClothItems() async
  {
    List<Clothes> trendingClothItemsList = [];

    try
        {
        var res=  await http.post(
            Uri.parse(API.getTrendingMostPopularClothes)
          );
        if(res.statusCode ==200)
        {
          var responseBodyOfTrending = jsonDecode(res.body);
          if(responseBodyOfTrending["success"]==true)
            {
              (responseBodyOfTrending["clothItemsData"] as List).forEach((eachRecord)
                  {
                    trendingClothItemsList.add(Clothes.fromJson(eachRecord));
                  });
            }

        }
        else
        {
          Fluttertoast.showToast(msg:"Error, status code is not 200");
        }
        }
        catch(errorMsg)
              {
                print("Error::" +errorMsg.toString());
              }
              return  trendingClothItemsList;
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
          trendingMostPopularClothItemWidget(context),
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

 Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(future: getTrendingClothItems() , builder:(context, AsyncSnapshot<List<Clothes>> dataSnapshot)
    {
      if(dataSnapshot.connectionState == ConnectionState.waiting){

        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(dataSnapshot.data == null){
        return const Center(
          child: Text("No trending item found"),
        );
      }
      if(dataSnapshot.data!.length>0){
        return Container(
          height: Dimensions.height260,
          child: ListView.builder(itemCount: dataSnapshot.data!.length,
          scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
            Clothes eachClothItemData = dataSnapshot.data![index];
            return GestureDetector(
               onTap: ()
               {

               },
              child: Container(
                width: Dimensions.width200,
                margin: EdgeInsets.fromLTRB( index == 0 ? Dimensions.height16 : Dimensions.height8, Dimensions.height10,
                    index == dataSnapshot.data!.length -1 ? Dimensions.height16: Dimensions.height8,Dimensions.height10,
                ),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(Dimensions.height20),
  color: Colors.black,
   boxShadow: const[
    BoxShadow(
      offset: Offset(0, 3),
      blurRadius: 6,
      color: Colors.grey
    ),
  ]
),
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
                          placeholder: const AssetImage("asssets/place_holder.png"), image:
                      NetworkImage(eachClothItemData.image!),
                      imageErrorBuilder: (context, error, stackTraceError)
                      {
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
                                child: Text(eachClothItemData.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Dimensions.height16,
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              SizedBox(width: Dimensions.width10,),
                              Text(eachClothItemData.price.toString(),
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: Dimensions.height18
                              ),)
                            ],
                          ),
                          SizedBox(height: Dimensions.height8,),
                          Row(
                            children: [
                              RatingBar.builder(
                                  initialRating: eachClothItemData.rating!,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder:(context, c)=> Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ) , onRatingUpdate: (updateRating){},
                                ignoreGestures: true,
                                unratedColor: Colors.grey,
                                itemSize: Dimensions.height20,

                              ),


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

      }
      else
      {
      return const Center(
        child: Text("Empty, No Data"),
      );
      }
    }


    );


 }
}
