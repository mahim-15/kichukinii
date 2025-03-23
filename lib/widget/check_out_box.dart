import 'package:flutter/material.dart';
import 'package:kichukini/mainScreen/home_screen.dart';
import 'package:kichukini/models/cart_item.dart';

const Color kPrimaryColor = Colors.blue; // Define the primary color
const Color kContentColor = Colors.grey; // Define the content color

class CheckOutBox extends StatelessWidget {
  final List<CartItem> items;
  
  const CheckOutBox({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    double subtotal = items.isNotEmpty
        ? items.map((e) => e.quantity * e.product.price).fold(0, (a, b) => a + b)
        : 0.0;

    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              filled: true,
              fillColor: kContentColor.withOpacity(0.2),
              hintText: "Enter Discount Code",
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              suffixIcon: TextButton(
                onPressed: () {},
                child: const Text(
                  "Apply",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow("Subtotal", subtotal),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          _buildPriceRow("Total", subtotal),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
