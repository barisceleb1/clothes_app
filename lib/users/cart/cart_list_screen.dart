import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/model/cart.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:clothes_app/widget/small_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfCurrentUser = [];

    try
    {
      var res = await http.post(Uri.parse(API.getCartList),
      body:
      {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
        
      }
      );
      if(res.statusCode == 200)
        {
            var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

      if(responseBodyOfGetCurrentUserCartItems['success'] == true )
        {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List).forEach((eachCurrentUserCartItemData )
          {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));

          });
        }
      else
        {
          Fluttertoast.showToast(msg: "Error Occured while executing query");
        }
      cartListController.setList(cartListOfCurrentUser);

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
  }
  calculateTotalAmount()
  {
    cartListController.setTotal(0);
    if(cartListController.selectedItemList.length > 0)
      {
        cartListController.cartList.forEach((itemInCart)
        {
          if(cartListController.selectedItemList.contains(itemInCart.item_id))
            {
              double eachItemTotalAmount = (itemInCart.price!) * (double.parse(itemInCart.quantity.toString()));

              cartListController.setTotal(cartListController.total + eachItemTotalAmount);
            }
        });
      }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() =>
          cartListController.cartList.length > 0 ?
              ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index)
                {
                  Cart cartModel = cartListController.cartList[index];
                  Clothes clothesModel = Clothes(
                    item_id: cartModel.item_id,
                    colors: cartModel.colors,
                    image: cartModel.image,
                    name: cartModel.name,
                    price: cartModel.price ,
                    rating: cartModel.rating,
                    sizes: cartModel.sizes ,
                    description: cartModel.description,
                    tags: cartModel.tags,
                  );
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        //-----check box------
                        GetBuilder(
                            init: CartListController(),
                            builder: (c)
                        {
                          return IconButton(onPressed: (){},
                              icon: Icon(cartListController.selectedItemList.contains(cartModel.item_id)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                                color: cartListController.isSelectedAll
                                    ? Colors.white
                                    : Colors.grey,
                              ));
                        }),
                        //--------name-------
                        //--------color size + price--------
                        //-------image---------
                        Expanded(child:
                        GestureDetector(
                          onTap: ()
                          {

                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, index == 0 ? Dimensions.height16 : Dimensions.height8, Dimensions.height16 ,
                                index == cartListController.cartList.length -1 ? Dimensions.height16 : Dimensions.height8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.height20),
                              color: Colors.black,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(child:
                                Padding(padding:
                                EdgeInsets.all(Dimensions.height10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SmallText(text: clothesModel.name.toString(),maxLines: 2,color: Colors.grey,
                                      weight: FontWeight.bold,size: Dimensions.height18,),
                                    SizedBox(height: Dimensions.height20,),
                                    //--------color size + price--------
                                    Row(
                                      children: [
                                        Expanded(child: 
                                        SmallText(text: "Color: ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}"+ "\n" + "Size: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                        maxLines: 3,
                                        color: Colors.white60,),
                                        ),
                                        //------price------
                                        Padding(
                                          padding: EdgeInsets.only(
                                          left: Dimensions.height12,
                                          right: Dimensions.height12,

                                        ),
                                        child: SmallText(text: "\$"+clothesModel.price.toString(),size: Dimensions.height20,
                                          color: Colors.red,weight: FontWeight.bold,),),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.height20,),
                                    //+ -
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // (-)
                                        IconButton(onPressed: ()
                                        {

                                        }, icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.grey,
                                          size: Dimensions.height30,
                                        ),),
                                        SizedBox(width: Dimensions.width10,),
                                        Text(cartModel.quantity.toString(),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: Dimensions.height20,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        SizedBox(width: Dimensions.width10,),
                                        // (+)
                                        IconButton(onPressed: ()
                                        {

                                        }, icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.grey,
                                          size: Dimensions.height30,
                                        ),),

                                      ],
                                    )

                                    

                                  ],
                                ),)
                                )
                              ],
                            ),

                          ),
                        ))

                      ],
                    ),
                  );
                },
              )
              : const Center(
            child: Text("Cart is Empty"),
          )
      ),
    );
  }
}
