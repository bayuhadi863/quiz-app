import 'package:flutter/material.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/pages/quiz/category_quizzes_page.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/widgets/home/categories_grid.dart';
import 'package:quiz_app/repositories/category_repository.dart'; // Import CategoryRepository

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Variable to store categories
  List<CategoryModel> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call getCategoryData function when the widget initializes
    getCategoryData();
  }

  // Function to fetch category data from repository
  void getCategoryData() async {
    // Start Loading
    setState(() {
      isLoading = true;
    });

    final CategoryRepository categoryRepository = CategoryRepository();
    final List<CategoryModel> data = await categoryRepository.getCategories();
    setState(() {
      categories = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi layar
    final screenHeight = MediaQuery.of(context).size.height;

    // Menghitung nilai padding vertical
    final verticalPadding = screenHeight * (1 / 3);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getCategoryData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? Center(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: verticalPadding),
                          child: const CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : categories.isEmpty
                        ? Center(
                            child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: verticalPadding),
                            child: Text(
                              'No categories found',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ))
                        : GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            primary: false,
                            padding: EdgeInsets.zero,
                            children: List.generate(
                              categories.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryQuizzesPage(
                                                categoryName:
                                                    categories[index].name),
                                      ),
                                    ).then((value) {
                                      getCategoryData();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/${categories[index].image}',
                                            width: 60,
                                            height: 60,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            categories[index].name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: MyColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
