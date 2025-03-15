import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kichukini/models/products.dart';

class ProductServices {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Products>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isEmpty) {
          throw Exception('No products found.');
        }

        return data.map((product) => Products.fromJson(product)).toList();
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}