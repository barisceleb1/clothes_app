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
    calculateTotalAmount();
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
  deleteSelectedItemsFromUserCartList(int cartID) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.deleteSelectedItemsFromCartList),
          body:
          {
            "cart_id": cartID.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if(responseBodyFromDeleteCart["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  updateQuantityInUserCart(int cartID, int newQuantity) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.updateItemInCartList),
          body:
          {
            "cart_id": cartID.toString(),
            "quantity": newQuantity.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);

        if(responseBodyOfUpdateQuantity["success"] == true)
        {
          getCurrentUserCartList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("My Cart"),

      actions: [

        //---------to select all items-------
        Obx(()=>
            IconButton(
              onPressed: ()
              {
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();

                if(cartListController.isSelectedAll)
                {
                  cartListController.cartList.forEach((eachItem)
                  {
                    cartListController.addSelectedItem(eachItem.cart_id!);
                  });
                }

                calculateTotalAmount();
              },
              icon: Icon(
                cartListController.isSelectedAll
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: cartListController.isSelectedAll
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
        ),

        //---------to delete selected item/items--------
        GetBuilder(
            init: CartListController(),
            builder: (c)
            {
              if(cartListController.selectedItemList.length > 0)
              {
                return IconButton(
                  onPressed: () async
                  {
                    var responseFromDialogBox = await Get.dialog(
                      AlertDialog(
                        backgroundColor: Colors.grey,
                        title: const Text("Delete"),
                        content: const Text("Are you sure to Delete selected items from your Cart List?"),
                        actions:
                        [
                          TextButton(
                            onPressed: ()
                            {
                              Get.back();
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: ()
                            {
                              Get.back(result: "yesDelete");
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if(responseFromDialogBox == "yesDelete")
                    {
                      cartListController.selectedItemList.forEach((selectedItemUserCartID)
                      {
                        //delete selected items now
                        deleteSelectedItemsFromUserCartList(selectedItemUserCartID);
                      });
                    }

                    calculateTotalAmount();
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 26,
                    color: Colors.redAccent,
                  ),
                );
              }
              else
              {
                return Container();
              }
            }
        ),

      ],
      ),
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
                          return IconButton(onPressed: ()
                          {
                            if(cartListController.selectedItemList.contains(cartModel.cart_id))
                            {
                              cartListController.deleteSelectedItem(cartModel.cart_id!);
                            }
                            else
                            {
                              cartListController.addSelectedItem(cartModel.cart_id!);
                            }
                            calculateTotalAmount();
                          },
                              icon: Icon(cartListController.selectedItemList.contains(cartModel.cart_id)
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
                                          if(cartModel.quantity! - 1 >= 1)
                                          {
                                            updateQuantityInUserCart(
                                              cartModel.cart_id!,
                                              cartModel.quantity! - 1,
                                            );
                                          }

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
                                          updateQuantityInUserCart(
                                            cartModel.cart_id!,
                                            cartModel.quantity! + 1,
                                          );

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
                        )),
                        //image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(Dimensions.height22),
                            bottomRight: Radius.circular(Dimensions.height22),
                          ),
                          child: FadeInImage(
                            height: Dimensions.height150,
                            width: Dimensions.height150,
                            fit: BoxFit.cover,
                            placeholder:
                            const AssetImage("assets/place_holder.png"),
                            image: NetworkImage(cartModel.image!) ,
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
                  );
                },
              )
              : const Center(
            child: Text("Cart is Empty"),
          )
      ),
      bottomNavigationBar: GetBuilder(
          init: CartListController(),
          builder:(c)
      {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                offset: Offset(0,Dimensions.minusheight3),
                color: Colors.white24,
                blurRadius: 6,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.height16,
            vertical: Dimensions.height8,

          ),
          child: Row(
            children: [
              Text("Total Amount:",style: TextStyle(fontSize: Dimensions.height14,
                  color: Colors.white38,fontWeight: FontWeight.bold),),
              SizedBox(width: Dimensions.height4,),
              Obx(() => Text("\$" + cartListController.total.toStringAsFixed(2),
              maxLines: 1,
              style: TextStyle(
                color: Colors.white70,
                fontSize: Dimensions.height20,
                fontWeight: FontWeight.bold
              ),
              ),
              ),
              const Spacer(),
              //-----order now btn-------
              Material(
                color: cartListController.selectedItemList.length > 0
                    ? Colors.purpleAccent
                    : Colors.white24,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {

                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        );
      }
      ),
    );
  }
}
