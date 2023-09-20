
import 'package:clothes_app/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController
{
  RxList<Cart> _cartList = <Cart>[].obs;
  RxList<int> _selectedItemList = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;


  setList(List<Cart> list) {
    _cartList.value = list;
  }
  addselectedItem(int itemSelectedID) {
    _selectedItemList.value.add(itemSelectedID);
    update();
  }
  deleteSelectedItem(int itemSelectedID) {
    _selectedItemList.value.remove(itemSelectedID);
    update();
  }
  setIsSelectedAll()
  {
    _isSelectedAll.value = !_isSelectedAll.value;
  }
  clearAllSelectedItems()
  {
    _selectedItemList.value.clear();
    update();
  }
  setTotal(double overallTotal)
  {
    _total.value = overallTotal;
  }


}