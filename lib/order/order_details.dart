import 'dart:convert';

import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {

  final Order? clickedOrderInfo;

  OrderDetailsScreen({this.clickedOrderInfo});


  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          DateFormat(
            "dd MMM, yyyy - hh:mm a").format(widget.clickedOrderInfo!.dateTime!),
          style: TextStyle(fontSize: Dimensions.height14),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(Dimensions.height16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayClickOrderItems(),
            SizedBox(height: Dimensions.height16),


          ],
        ),),
      ),


    );
  }
  displayClickOrderItems() {
    List<String> clickedOrderItemsInfo = widget.clickedOrderInfo!.selectedItems!.split("||");
    return Column(
        children: List.generate(clickedOrderItemsInfo.length, (index) {
          Map<String, dynamic> itemInfo = jsonDecode(clickedOrderItemsInfo[index]);
          return Container(
            margin: EdgeInsets.fromLTRB(
                Dimensions.height16,
                index == 0 ? Dimensions.height16 : Dimensions.height8,
                Dimensions.height16,
                index == clickedOrderItemsInfo.length - 1
                    ? Dimensions.height16
                    : Dimensions.height8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height20),
                color: Colors.white24,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: Dimensions.height6,
                      color: Colors.black26)
                ]),
            child: Row(
              children: [
                //-------image-------
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.height20),
                    bottomLeft: Radius.circular(Dimensions.height20),
                  ),
                  child: FadeInImage(
                    height: Dimensions.height150,
                    width: Dimensions.height200,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage("assets/place_holder.png"),
                    image: NetworkImage(itemInfo["image"]),
                    imageErrorBuilder: (context, error, stackTraceError) {
                      return const Center(
                        child: Icon(Icons.broken_image_outlined),
                      );
                    },
                  ),
                ),
                //----name----
                //----size----
                //----total amount------
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //---name---
                        Text(
                          itemInfo["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: Dimensions.height18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height16,
                        ),
                        //-----size+color-----
                        Text(
                          itemInfo["size"].replaceAll("[", "").replaceAll("]", "") +"\n"+ itemInfo["color"].replaceAll("[", "").replaceAll("]", ""),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height16,
                        ),
                        //-----total amount------
                        Text(itemInfo["totalAmount"].toString()+" \₺",
                          overflow:  TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Dimensions.height18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                          ),),
                        Text(itemInfo["price"].toString() +" x "
                            + itemInfo["quantity"].toString()
                            + " = " + itemInfo["totalAmount"].toString(),
                          style: TextStyle(
                            fontSize: Dimensions.height12,
                            color: Colors.grey,

                          ),)


                      ],
                    ),
                  ),
                ),
                //----quantity----
                Padding(
                  padding: EdgeInsets.all(Dimensions.height8),
                  child: Text("Q:"+ itemInfo["quantity"].toString(),
                    style: TextStyle(fontSize: Dimensions.height23,
                        color: Colors.red),),
                )

              ],
            ),
          );
        }));
  }
}
