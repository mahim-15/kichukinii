class Category {
  final String title;
  final String image;
  Category({
  required this.title,
  required this.image,});

}
final List<Category>categories=[
  Category(title: "Shoes", image: "images/shoes.jpg"),
  Category(title: "Beauty", image: "images/beauty.png"),
  Category(title: "PC", image: "images/pc.jpg"),
  Category(title: "Watch", image: "images/watch.png"),
  Category(title: "Mobile", image: "images/mobile.jpg"),
];