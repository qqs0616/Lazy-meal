import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/api/index.dart';
import 'package:food_app/pages/details.dart';
import 'package:food_app/untils/index.dart';

import '../common/index.dart';
import '../widgets/index.dart';

///搜索页
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  //Title的脸形
  String face = smilingFace;

  //类型
  String category = "";
  List categoryList = [];

  //食物
  String ingredients = "";
  List ingredientsList = [];

  //地区
  String area = "";
  List areaList = [];

  //食物
  List foodList = [];

  List tempFoodList = [];

  //排序
  String sort = sortString[0];

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  //获取数据
  Future getData() async {
    var category = await getAllCategory();
    var ingredients = await getAllIngredients();
    var area = await getAllArea();

    //默认查询所有英国的食物
    var britishArea = await filterArea(area: "British");

    categoryList = category["meals"];
    ingredientsList = ingredients["meals"];
    areaList = area["meals"];
    foodList = britishArea["meals"];
    tempFoodList = List.from(foodList);

    //数据量太多，截取一下
    if (categoryList.length > 10) {
      categoryList = categoryList.sublist(0, 10);
    }

    if (ingredientsList.length > 10) {
      ingredientsList = ingredientsList.sublist(0, 10);
    }

    if (areaList.length > 10) {
      areaList = areaList.sublist(0, 10);
    }

    setState(() {});
  }

  ///排序方法
  void sortFun() {
    if (sort != "Sort By") {
      if (sort == "Newest") {
        foodList.sort((a, b) => a["idMeal"].compareTo(b["idMeal"]));
      } else {
        foodList.sort((a, b) => b["idMeal"].compareTo(a["idMeal"]));
      }
    } else {
      // //如果没有排序，则恢复原来的数据
      resetFoodList();
    }
    setState(() {});
  }

  ///搜索方法
  Future<void> searchFun() async {
    String search = textEditingController.text;
    var data;
    if (search.isNotEmpty) {
      data = await getFoodFromName(name: search);
      foodList = data["meals"];
      copyFoodList();
    } else {
      //如果搜索内容为空，则变成原来的数据
      resetFoodList();
    }

    sortFun();
    setState(() {});
  }

  //复制数组
  void copyFoodList() async {
    tempFoodList = List.from(foodList);
  }

  ///通过tempFood恢复数组
  void resetFoodList() async {
    foodList = List.from(tempFoodList);
  }

  ///pop刷新页面统一方法
  void popFun(data) {
    //先将数据赋值
    foodList = data["meals"];

    //将原有数据拷贝
    copyFoodList();

    //拷贝后看是否需要排序
    sortFun();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildSearch(),
            _buildPopMenu(),
            _buildSort(),
            _buildFoodList()
          ],
        ),
      ),
    );
  }

  ///食物列表
  Expanded _buildFoodList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          var data = foodList[index];
          String randomTime = data["idMeal"].substring(1, 2) +
              data["idMeal"].substring(data["isMeal"].toString().length - 1,
                  data["isMeal"].toString().length);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FoodDetailsPage(id: int.parse(data["idMeal"]))));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            data["strMealThumb"],
                            fit: BoxFit.cover,
                          ),
                        ),
                        _buildTimeCircle(randomTime),
                        // SizedBox(
                        //   width: 30,
                        //   height: 30,
                        //   child: CircularProgressIndicator(
                        //     value: randomTime,
                        //     strokeWidth: 3,
                        //     color: Colors.black,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  const SpaceHorizontalWidget(),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        data["strMeal"],
                        style: const TextStyle(
                            fontSize: 25,
                            fontFamily: "TiltNeon",
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        },
        itemCount: foodList.length,
      ),
    );
  }

  ///时间圈
  Positioned _buildTimeCircle(String randomTime) {
    return Positioned(
      bottom: padding,
      left: padding,
      child: CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 20,
        child: Stack(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: SizedBox(
                  child: CircularProgressIndicator(
                    value: int.parse(randomTime) / 100,
                    strokeWidth: 3,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 10,
                child: Center(
                  child: Text(
                    randomTime,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///排序部分
  Padding _buildSort() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
              value: sort,
              icon: const SizedBox.shrink(),
              underline: const SizedBox.shrink(),
              items: sortString
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  sort = value!;
                  sortFun();
                });
              },
            ),
          ),
          const Icon(Icons.arrow_drop_down_outlined)
        ],
      ),
    );
  }

  ///分类
  Padding _buildPopMenu() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: PopMenuWidget(
              icon: const Icon(Icons.menu_open),
              title: 'Cuisine',
              items: categoryList
                  .map((e) => PopupMenuItem(
                        value: e["strCategory"],
                        child: Text(e["strCategory"]),
                      ))
                  .toList(),
              initialValue: category,
              onSelected: (val) async {
                category = val;
                var data = await filterCuisine(cuisine: category);
                popFun(data);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: PopMenuWidget(
              initialValue: ingredients,
              onSelected: (val) async {
                ingredients = val;
                var data = await filterIngredients(ingredients: ingredients);
                popFun(data);
                setState(() {});
              },
              icon: const Icon(Icons.apple),
              title: 'Ingredients',
              items: ingredientsList
                  .map((e) => PopupMenuItem(
                        value: e["strIngredient"],
                        child: Text(e["strIngredient"]),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: PopMenuWidget(
              initialValue: area,
              onSelected: (val) async {
                area = val;
                var data = await filterArea(area: area);
                popFun(data);
                setState(() {});
              },
              icon: const Icon(Icons.area_chart_outlined),
              title: 'Area',
              items: areaList
                  .map((e) => PopupMenuItem(
                        value: e["strArea"],
                        child: Text(e["strArea"]),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  ///Search输入框
  Container _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(padding),
      color: homeTitleColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextField(
            controller: textEditingController,
            onSubmitted: (val) async {
              await searchFun();
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(padding),
                  borderSide: BorderSide.none),
              filled: true,
              hintText: "Search what you want",
              prefixIcon: const Icon(Icons.search),
            ),
          )),
          const SpaceHorizontalWidget(),
          GestureDetector(
            onTap: () async {
              await searchFun();
            },
            child: const Text(
              "Search",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  ///AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: homeTitleColor,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          if (face == smilingFace) {
            face = cryingFace;
          } else {
            face = smilingFace;
          }
          setState(() {});
        },
        child: Text(
          "Food can heal all your unhappiness$face",
          style:
              const TextStyle(fontFamily: "TiltNeon", color: Color(0xffBD3124)),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
