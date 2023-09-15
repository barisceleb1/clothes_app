import 'package:clothes_app/users/controllers/cart_list_controller.dart';
import 'package:clothes_app/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
