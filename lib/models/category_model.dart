import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  String name;
  String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  static CategoryModel empty() => CategoryModel(id: '', name: '', image: '');

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }

  /// Factory method to create a CategoryModel from a DocumentSnapshot
  factory CategoryModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return CategoryModel(
      id: documentSnapshot.id,
      name: data['name'],
      image: data['image'],
    );
  }
}