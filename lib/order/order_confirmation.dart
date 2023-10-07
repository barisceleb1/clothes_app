import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {

 final List<int>? selectedCartIDs;
 final List<Map<String, dynamic>>? selectedCartListItemsInfo;
 final double? totalAmount;
 final String? deliverySystem;
 final String? paymentSystem;
 final String? phoneNumber;
 final String? shipmentAddress;
 final String? note;

  const OrderConfirmationScreen({this.selectedCartIDs, this.selectedCartListItemsInfo, this.totalAmount, this.deliverySystem, this.paymentSystem, this.phoneNumber, this.shipmentAddress, this.note});



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
