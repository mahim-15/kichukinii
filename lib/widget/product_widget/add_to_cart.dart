import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kichukini/mainScreen/cart_screen.dart';

class AddToCart extends StatelessWidget {
  final Function() onAdd;
  final Function() onRemove;
  final int currentNumber;
  final bool showAddToCartButton;
  final VoidCallback? onAddToCartPressed;

  const AddToCart({
    super.key,
    required this.currentNumber,
    required this.onAdd,
    required this.onRemove,
    this.showAddToCartButton = true,
    this.onAddToCartPressed,
  }) : assert(currentNumber > 0, 'Current number must be positive');

  @override
  Widget build(BuildContext context) {
    final bool canDecrease = currentNumber > 1;
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: canDecrease ? onRemove : null, 
                  iconSize: 18,
                  icon: Icon(
                    Ionicons.remove_outline,
                    color: canDecrease ? Colors.white : Colors.grey,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  currentNumber.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: onAdd, 
                  iconSize: 18,
                  icon: const Icon(
                    Ionicons.add_outline,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (showAddToCartButton)
            GestureDetector(
              onTap: onAddToCartPressed ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}