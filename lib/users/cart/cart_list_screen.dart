import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/model/cart.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
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
                        })
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
