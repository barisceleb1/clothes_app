import 'package:clothes_app/users/controllers/order_now_controller.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = [
    "FedX",
    "DHL",
    "United Parcel Service"
  ];
  List<String> paymentSystemNamesList = [
    "Apple Pay",
    "Wire Transfer",
    "Google Pay"
  ];

  TextEditingController phpneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController notToSellerController = TextEditingController();

  OrderNowScreen(
      {this.selectedCartListItemsInfo, this.totalAmount, this.selectedCartIDs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Order Now"),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          //--------display selected items from cart List----------
          displaySelectedItemsFromUserCart(),

          SizedBox(
            height: Dimensions.height30,
          ),

          //----------delivery system-----------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Text(
              "Delivery System:",
              style: TextStyle(
                fontSize: Dimensions.height18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.height18),
            child: Column(
              children: deliverySystemNamesList.map((deliverySystemName) {
                return Obx(() => RadioListTile<String>(
                    value: deliverySystemName,
                    dense: true,
                    tileColor: Colors.white24,
                    activeColor: Colors.red,
                    groupValue: orderNowController.deliverySys,
                    title: Text(
                      deliverySystemName,
                      style: TextStyle(
                          fontSize: Dimensions.height16, color: Colors.white38),
                    ),
                    onChanged: (newDeliverySystemValue) {
                      orderNowController
                          .setDeliverySystem(newDeliverySystemValue!);
                    }));
              }).toList(),
            ),
          ),
          SizedBox(
            height: Dimensions.height16,
          ),

          //---------payment system ------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment System:",
                  style: TextStyle(
                    fontSize: Dimensions.height18,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.height2),
                Text(
                  "Company Account Number / ID: \nY87Y-HJF9-CVBN-4321",
                  style: TextStyle(
                    fontSize: Dimensions.height18,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.height18),
            child: Column(
              children: paymentSystemNamesList.map((paymentSystemName) {
                return Obx(() => RadioListTile<String>(
                    value: paymentSystemName,
                    tileColor: Colors.white24,
                    dense: true,
                    activeColor: Colors.red,
                    title: Text(
                      paymentSystemName,
                      style: TextStyle(
                          fontSize: Dimensions.height16, color: Colors.white38),
                    ),
                    groupValue: orderNowController.paymentSys,
                    onChanged: (newPaymentSystemValue) {
                      orderNowController
                          .setPaymentSystem(newPaymentSystemValue!);
                    }));
              }).toList(),
            ),
          ),
          SizedBox(
            height: Dimensions.height16,
          ),
          //-------phone number---------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Text(
              "Phone Number:",
              style: TextStyle(
                fontSize: Dimensions.height18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Dimensions.height16,
                Dimensions.height8, Dimensions.height16, Dimensions.height16),
            child: TextField(
              style: TextStyle(color: Colors.white54),
              controller: phpneNumberController,
              decoration: InputDecoration(
                hintText: 'Any Contact Number.',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.height12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.grey, width: Dimensions.height2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.white24, width: Dimensions.height2)),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height16,
          ),
          //-------shipment address---------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Text(
              "Shipment Address:",
              style: TextStyle(
                fontSize: Dimensions.height18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Dimensions.height16,
                Dimensions.height8, Dimensions.height16, Dimensions.height16),
            child: TextField(
              style: TextStyle(color: Colors.white54),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintText: 'Your Shipment Adress..',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.height12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.grey, width: Dimensions.height2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.white24, width: Dimensions.height2)),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height16,
          ),
          //-------note to seller---------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Text(
              "Note to Seller:",
              style: TextStyle(
                fontSize: Dimensions.height18,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Dimensions.height16,
                Dimensions.height8, Dimensions.height16, Dimensions.height16),
            child: TextField(
              style: TextStyle(color: Colors.white54),
              controller: notToSellerController,
              decoration: InputDecoration(
                hintText: 'Any note you want to write to seller..',
                hintStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.height12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.grey, width: Dimensions.height2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.height12),
                    borderSide: BorderSide(
                        color: Colors.white24, width: Dimensions.height2)),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height30,
          ),
          //-------pay amount now btn----------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Material(
              color: Colors.red,
              borderRadius: BorderRadius.circular(Dimensions.height30),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(Dimensions.height30),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height16,
                    vertical: Dimensions.height12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "\$" + totalAmount!.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: Dimensions.height20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Pay Amount Now",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: Dimensions.height16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.height30,
          ),
        ],
      ),
    );
  }

  displaySelectedItemsFromUserCart() {
    return Column(
        children: List.generate(selectedCartListItemsInfo!.length, (index) {
      Map<String, dynamic> eachSelectedItem = selectedCartListItemsInfo![index];
      return Container(
        margin: EdgeInsets.fromLTRB(
            Dimensions.height16,
            index == 0 ? Dimensions.height16 : Dimensions.height8,
            Dimensions.height16,
            index == selectedCartListItemsInfo!.length - 1
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
                image: NetworkImage(eachSelectedItem["image"]),
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
                      eachSelectedItem["name"],
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
                      eachSelectedItem["size"].replaceAll("[", "").replaceAll("]", "") +"\n"+ eachSelectedItem["color"].replaceAll("[", "").replaceAll("]", ""),
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
                    Text(eachSelectedItem["totalAmount"].toString()+" \₺",
                      overflow:  TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.height18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),),
                    Text(eachSelectedItem["price"].toString() +" x "
                      + eachSelectedItem["quantity"].toString()
                      + " = " + eachSelectedItem["totalAmount"].toString(),
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
              child: Text("Q:"+ eachSelectedItem["quantity"].toString(),
              style: TextStyle(fontSize: Dimensions.height23,
              color: Colors.red),),
            )

          ],
        ),
      );
    }));
  }
}
