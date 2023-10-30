import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/order/history_screen.dart';
import 'package:clothes_app/users/order/order_details.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderFragmentScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];

    debugPrint("Bu Order =" + Order().toString());
    try {
      var res = await http.post(Uri.parse(API.readOrders), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });
      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List)
              .forEach((eachCurrentUserOrderData) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:" + errorMsg.toString());
    }
    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Order image   // history image ----
            // ------ MyOrder title  // history title ----

            Padding(padding: EdgeInsets.fromLTRB(Dimensions.height16, Dimensions.height24, Dimensions.height8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Column(
            children: [
            Image.asset(
              "assets/orders_icon.png",
              width: Dimensions.width140,

            ),
      Text("My orders",style: TextStyle(
        color: Colors.red,
        fontSize: Dimensions.height24,                           // Dimensions.height24,
        fontWeight: FontWeight.bold,
      ),)
      ],
    ),
                GestureDetector(
                  onTap: ()
                  {
                    //send user to orders history screen
                    Get.to(HistoryScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height8),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/history_icon.png",
                          width: Dimensions.width45,

                        ),
                        Text("History",style: TextStyle(
                          color: Colors.red,
                          fontSize: Dimensions.height12,                           // Dimensions.height24,
                          fontWeight: FontWeight.bold,
                        ),)
                      ],
                    ),
                  ),
                ),



              ],
            ),),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Dimensions.height30),
              child: Text("Here are your successfully placed orders",
              style: TextStyle(
                fontSize: Dimensions.height16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),),
            ),
            
            //---displaying the user orderList---
            Expanded(child: displayOrdersList(context)),

          ],
        ));
  }
 Widget displayOrdersList(context) {
    return FutureBuilder(
        future: getCurrentUserOrdersList(),
        builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {

            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Connection Waiting...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SpinKitFadingCircle(
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                )

              ],
            );
          }
          if (dataSnapshot.data == null) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "No orders found yet...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          if (dataSnapshot.data!.length > 0) {
            List<Order> orderList = dataSnapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(Dimensions.height16),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                Order eachOrderData = orderList[index];
                return Card(
                  color: Colors.white24,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height18),
                    child: ListTile(
                      onTap: ()
                      {
                        Get.to(OrderDetailsScreen(
                          clickedOrderInfo: eachOrderData


                        ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID # " + eachOrderData.order_id.toString(),
                            style: TextStyle(
                                fontSize: Dimensions.height16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Amount: \₺" + eachOrderData.totalAmount.toString(),
                            style: TextStyle(
                                fontSize: Dimensions.height16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //------date-----
                          //------time-----

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat("dd MMM, yyy")
                                    .format(eachOrderData.dateTime!),
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: Dimensions.height4,),
                              Text(
                                DateFormat("hh:mm a")
                                    .format(eachOrderData.dateTime!),
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          SizedBox(width: Dimensions.width6,),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.red,
                          )

                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if(dataSnapshot.data?.length == 0)
            {
              return Column(
             children: [
                Center(child: Padding(
                  padding:  EdgeInsets.all(Dimensions.height10),
                  child: Text("Order Empty",style: TextStyle(color: Colors.white),),
                )),
             ],
              );
            }

          else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Nothing to show ...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
        });
  }

}



