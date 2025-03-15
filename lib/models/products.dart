import 'dart:convert';

class Products{
  final int id;
  final String title;
  final double price;
  final String image;
  final String description;

  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,

  });
  //factory method
  factory Products.fromJson(Map<String,dynamic>json){
    return Products(
      id: json['id'], 
      title: json['title'],
      price: json['price'].toDouble(),
       image: json['image'], 
       description: json['description'],
       );
  }
}