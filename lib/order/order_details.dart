import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {

  final Order? clickedOrderInfo;

  OrderDetailsScreen({this.clickedOrderInfo});


  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  RxString _status = "new".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelReceived)
  {
    _status.value = parcelReceived;
  }
  showDialogForParcelConfirmation() async
  {
    if(widget.clickedOrderInfo!.status == "new")
      {
        var response = await Get.dialog(
         AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "Confirmation",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            content: Text(
              "Have you received your parcel?",
              style: TextStyle(
                color: Colors.grey
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Get.back();

                },
                child: Text(
                  "No",
                  style: TextStyle(
                      color: Colors.red
                  ),

                ),
              ),
              TextButton(
                onPressed: ()
                {
                  Get.back(result: "yesConfirmed");

                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: Colors.green
                  ),

                ),
              ),
            ],
          )

        );

    if(response == "yesConfirmed")
      {
        updateStatusValueInDatabase();
      }
     }
  }
  updateStatusValueInDatabase()
  {

  }


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
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(Dimensions.height8, Dimensions.height8, Dimensions.height16, Dimensions.height8),
            child: Material(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(Dimensions.circular10),
              child: InkWell(
                onTap: ()
                {
                  showDialogForParcelConfirmation();

                },
                borderRadius: BorderRadius.circular(Dimensions.height30),
                child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.height16,vertical: Dimensions.height4),
                child: Row(
                  children: [
                    Text("Received",
                    style: TextStyle(
                      fontSize: Dimensions.height14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),

                    SizedBox(width: Dimensions.height8,),
                    Obx(() => status == "new"
                        ? const Icon(Icons.help_outline, color: Colors.red,)
                        : const Icon(Icons.check_circle_outline, color: Colors.green,)

                    )
                  ],
                ),

                ),
              ),

            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(Dimensions.height16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayClickOrderItems(),
            SizedBox(height: Dimensions.height16),

            //-----phoneNumber----
            showTitleText("Phone Number:"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.phoneNumber!),
            SizedBox(height: Dimensions.height26),
            //-----Shipment Address----
            showTitleText("Shipment Address:"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.shipmentAddress!),
            SizedBox(height: Dimensions.height26),
            //------delivery------
            showTitleText("Delivery System:"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.deliverySystem!),

            SizedBox(height: Dimensions.height26),

            //-----payment----
            showTitleText("Payment System:"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.paymentSystem!),
            SizedBox(height: Dimensions.height26),

            //-----Note-----
            showTitleText("Note to Seller"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.note!),
            SizedBox(height: Dimensions.height26),

            //----Total Amount------
            showTitleText("Total Amount:"),
            SizedBox(height: Dimensions.height8),
            showContentText(widget.clickedOrderInfo!.totalAmount.toString()),
            SizedBox(height: Dimensions.height26),

            //----Payment Proof------
            showTitleText("Proof of Payment/Transaction:"),
            SizedBox(height: Dimensions.height8),
            FadeInImage(
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.fitWidth,
              placeholder: const AssetImage("assets/place_holder.png"),
              image: NetworkImage(API.hostImages + widget.clickedOrderInfo!.image!),
              imageErrorBuilder: (context, error, stackTraceError) {
                return const Center(
                  child: Icon(Icons.broken_image_outlined),
                );
              },
            ),


          ],
        ),),
      ),


    );
  }
  Widget showTitleText(String titleText)
  {
    return Text(
      titleText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.height20,
        color: Colors.grey,
      ),
    );

  }
  Widget showContentText(String contentText)
  {
    return Text(
      contentText,
      style: TextStyle(
        fontSize: Dimensions.height14,
        color: Colors.white38,
      ),
    );

  }

  Widget displayClickOrderItems() {
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
