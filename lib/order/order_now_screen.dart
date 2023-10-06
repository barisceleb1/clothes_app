import 'package:clothes_app/users/controllers/order_now_controller.dart';
import 'package:clothes_app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItem;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["FedX", "DHL", "United Parcel Service"];
  List<String> paymentSystemNamesList = ["Apple Pay", "Wire Transfer", "Google Pay"];

   OrderNowScreen(
      {this.selectedCartListItem, this.totalAmount, this.selectedCartIDs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          //----------delivery system-----------
           Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
             child: Text(
                 "Delivery System:", style: TextStyle(
               fontSize: Dimensions.height18,
               color: Colors.white70,
               fontWeight: FontWeight.bold,

             ),),
          ),
          Padding(padding: EdgeInsets.all(Dimensions.height18),
          child: Column(
            children: deliverySystemNamesList.map((deliverySystemName)
            {
              return Obx(() =>
                  RadioListTile<String>(value: deliverySystemName, dense: true, activeColor:Colors.red, groupValue: orderNowController.deliverySys, onChanged: (newDeliverySystemValue)
                  {
                    orderNowController.setDeliverySystem(newDeliverySystemValue!);
                  }
                  ));



            }).toList(),


          ),


          ),

          //---------payment system ------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.height16),
            child: Text(
              "Payment System:", style: TextStyle(
              fontSize: Dimensions.height18,
              color: Colors.white70,
              fontWeight: FontWeight.bold,

            ),),
          ),
          Padding(padding: EdgeInsets.all(Dimensions.height18),
            child: Column(
              children: paymentSystemNamesList.map((paymentSystemName)
              {
                return Obx(() =>
                    RadioListTile<String>(value: paymentSystemName,
                        dense: true,
                        activeColor:Colors.red,
                        groupValue: orderNowController.paymentSys,
                        onChanged: (newPaymentSystemValue)
                    {
                      orderNowController.setPaymentSystem(newPaymentSystemValue!);
                    }
                    ));



              }).toList(),


            ),


          ),
        ],


      ),


    );
  }
}
