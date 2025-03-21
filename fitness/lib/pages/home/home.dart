import 'package:fitness/models/diet_model.dart';
import 'package:fitness/models/popular_model.dart';
import 'package:fitness/models/category_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<CategoryModel> categories = CategoryModel.getCategories();
  final List<DietModel> diets = DietModel.getDiets();
  final List<PopularDietsModel> popular = PopularDietsModel.getPopularDiets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        children: [
          _buildSearchBar(),
          _buildSectionTitle('Category'),
          _buildCategoryList(),
          _buildSectionTitle('Recommendation for Diet'),
          _buildDietRecommendationList(),
          _buildSectionTitle('Popular'),
          _buildPopularList(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Breakfast",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: _buildIconButton('assets/icons/arrow.svg'),
      actions: [_buildIconButton('assets/icons/dots.svg', size: 37)],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search Pancakes',
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xffDDDADA)),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset('assets/icons/Search.svg'),
          ),
          suffixIcon: _buildFilterIcon(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterIcon() {
    return SizedBox(
      width: 100,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const VerticalDivider(
              color: Colors.black,
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/icons/Filter.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: category.boxColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: SvgPicture.asset(category.iconPath),
                ),
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDietRecommendationList() {
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: diets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          final diet = diets[index];
          return Container(
            width: 210,
            decoration: BoxDecoration(
              color: diet.boxColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(diet.iconPath),
                Text(
                  diet.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${diet.level} | ${diet.duration} | ${diet.calorie}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: popular.length,
      separatorBuilder: (_, __) => const SizedBox(height: 25),
      itemBuilder: (context, index) {
        final item = popular[index];
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: item.boxIsSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                item.boxIsSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 10),
                        blurRadius: 40,
                      ),
                    ]
                    : [],
          ),
          child: ListTile(
            leading: SvgPicture.asset(item.iconPath, width: 65, height: 65),
            title: Text(
              item.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${item.level} | ${item.duration} | ${item.calorie}',
              style: const TextStyle(fontSize: 14),
            ),
            trailing: SvgPicture.asset(
              "assets/icons/button.svg",
              height: 30,
              width: 30,
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(String assetPath, {double size = 37}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        width: size,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF7F8F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(assetPath, height: 20, width: 20),
      ),
    );
  }
}
