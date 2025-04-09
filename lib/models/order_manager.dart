// lib/models/order_manager.dart

import 'package:kichukini/models/cart_item.dart';

class OrderManager {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  List<List<CartItem>> _orders = [];

  List<List<CartItem>> get orders => _orders;

  void addOrder(List<CartItem> order, {bool replace = false}) {
    if (replace && _orders.isNotEmpty) {
      _orders[0] = order;
    } else {
      _orders.add(order);
    }
  }

  void clearOrders() {
    _orders.clear();
  }
}
