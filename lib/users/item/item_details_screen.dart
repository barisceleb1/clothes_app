import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/item_details_controller.dart';
import 'package:clothes_app/users/fragments/dashboard_of_fragments.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/users/userPreferences/user_preferences.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:clothes_app/widget/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class ItemDetailsScreen extends StatefulWidget {
  final Clothes? itemInfo;

  const ItemDetailsScreen({this.itemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
      'user_id': currentOnlineUser.user.user_id.toString(),
      'item_id': widget.itemInfo!.item_id.toString(),
      'quantity': itemDetailsController.quantity.toString(),
      'color': widget.itemInfo!.colors![itemDetailsController.color],
      'size': widget.itemInfo!.sizes![itemDetailsController.size],
      },
      );

      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        print("Giriş başarılı");
        if (resBodyOfAddCart['success'] == true)
        {
          Fluttertoast.showToast(
              msg: 'item saved to Cart Succesfully');

        }
        else
        {
          Fluttertoast.showToast(msg: 'Error Occur. Item not saved to Cart and Try Again');
        }
      }
      else{
        Fluttertoast.showToast(msg: "Status is not 200");
      }

    }
    catch(errMsg)
    {
      print("Error: "+ errMsg.toString());
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        //----item image----
        children: [
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("assets/place_holder.png"),
            image: NetworkImage(widget.itemInfo!.image!),
            imageErrorBuilder: (context, error, stackTraceError) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),

          //--------item information-------
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )
        ],
      ),
    );
  }

  itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.height30),
            topRight: Radius.circular(Dimensions.height30),
          ),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -3),
                blurRadius: Dimensions.height6,
                color: Colors.grey)
          ]),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.height18,
            ),

            Center(
              child: Container(
                height: Dimensions.height8,
                width: Dimensions.width140,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(Dimensions.height30),
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.height30,
            ),
            //----name---
            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Dimensions.height24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),

            //rating + rating num
            //tags
            //price
            //quantity item counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //rating + rating num
                //tags
                //price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //rating + rating num
                      Row(
                        children: [
                          //rating bar
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c) =>const Icon(
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
                            "(" + widget.itemInfo!.rating.toString() + ")",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      //tags
                      SmallText(
                        text: widget.itemInfo!.tags!
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: Dimensions.height16,
                      ),
                      //price
                      Text(
                        "\$" + widget.itemInfo!.price.toString(),
                        style: TextStyle(
                          fontSize: Dimensions.height24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  //quantity item counter
                ),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //+
                        IconButton(
                          onPressed: () {
                            itemDetailsController.setQuantityItem(
                                itemDetailsController.quantity + 1);
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          itemDetailsController.quantity.toString(),
                          style: TextStyle(
                            fontSize: Dimensions.height20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //-
                        IconButton(
                          onPressed: () {
                            if (itemDetailsController.quantity - 1 >= 1) {
                              itemDetailsController.setQuantityItem(
                                  itemDetailsController.quantity - 1);
                            } else {
                              Get.snackbar("Warning",
                                  "Quantity must be 1 or greater than 1",
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Colors.white38,
                                  snackPosition: SnackPosition.BOTTOM);
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            //---sizes---
           SmallText(text: "Size:", size: Dimensions.height18,weight: FontWeight.bold),
            SizedBox(height: Dimensions.height8,),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.sizes!.length, (index)
              {
                return Obx(
                    ()=> GestureDetector(
                      onTap: ()
                      {
                        itemDetailsController.setSizeItem(index);
                      },
                      child: Container(
                        height: Dimensions.height35,
                        width: Dimensions.width60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: Dimensions.height2,
                            color: itemDetailsController.size== index
                              ? Colors.transparent : Colors.grey,
                          ),
                          color: itemDetailsController.size == index
                              ? Colors.red.withOpacity(0.4)
                              : Colors.black,
                        ),
                        alignment: Alignment.center,
                        child: SmallText(text:widget.itemInfo!.sizes![index].replaceAll("[", "").replaceAll("]", ""),
                         color: Colors.grey,size: Dimensions.height16,
                        ),
                      ),
                    ),
                );
              }),
            ),
            SizedBox(height: Dimensions.height20,),

            //---colors---
            SmallText(text: "Color:", size: Dimensions.height18, weight: FontWeight.bold,),
            SizedBox(height: Dimensions.height8,),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.colors!.length, (index)
              {
                return Obx(
                      ()=> GestureDetector(
                    onTap: ()
                    {
                      itemDetailsController.setColorItem(index);

                    },
                    child: Container(
                      height: Dimensions.height35,
                      width: Dimensions.width60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: Dimensions.height2,
                          color: itemDetailsController.color== index
                              ? Colors.transparent : Colors.grey,
                        ),
                        color: itemDetailsController.color == index
                            ? Colors.red.withOpacity(0.4)
                            : Colors.black,
                      ),
                      alignment: Alignment.center,
                      child: SmallText(text:widget.itemInfo!.colors![index].replaceAll("[", "").replaceAll("]", ""),
                        color: Colors.grey,size: Dimensions.height16,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: Dimensions.height20,),
            //---description---
            SmallText(text: "Description:", size: Dimensions.height18,weight: FontWeight.bold,),
            SizedBox(height: Dimensions.height8,),
            SmallText(text: widget.itemInfo!.description!,textAlign: TextAlign.justify,color: Colors.grey,),
            SizedBox(height: Dimensions.height30,),
            //------add to cart button------
            Material(
              elevation: 4,
              color: Colors.red,
              borderRadius: BorderRadius.circular(Dimensions.height10),
              child: InkWell(
                onTap: ()
                {
                    addItemToCart();
                },
                borderRadius: BorderRadius.circular(Dimensions.height10),
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height50,
                  child: SmallText(text: "Add to Cart",size: Dimensions.height20,color: Colors.white,),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30,),





          ],
        ),
      ),
    );
  }


}
