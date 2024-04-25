import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/category_model.dart';

class CategoryRepository {
  // Singleton instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection("categories").get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                CategoryModel.fromSnapshot(e))
            .toList();
      } else {
        return [];
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get category by name
  Future<CategoryModel> getCategoryByName(String name) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection("categories")
          .where('name', isEqualTo: name)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return CategoryModel.fromSnapshot(querySnapshot.docs.first);
      } else {
        throw CategoryModel.empty();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
