import 'dart:convert';
import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:food_app/main.dart';
import 'package:food_app/pages/index.dart';
import 'package:food_app/untils/index.dart';

import '../api/index.dart';
import '../common/index.dart';
import '../widgets/index.dart';

///食物详情页
class FoodDetailsPage extends StatefulWidget {
  final int id;

  const FoodDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  Map<String, dynamic> dataMap = {};

  //随机评分
  String randomRank = "";

  List<String> ingredientsList = [];
  List<String> measureList = [];

  //收藏列表
  List favList = [];

  //计划列表
  List planList = [];

  //是否已经添加收藏
  bool isFav = false;

  //是否已经添加到计划中
  bool isPlan = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    randomRank =
        "${Random().nextInt(5)}.${Random().nextInt(5)}(${Random().nextInt(1000)})";

    var data = await searchById(id: widget.id);
    dataMap = data["meals"][0];

    for (int i = 1; i <= 20; i++) {
      if (dataMap["strIngredient$i"] == "" ||
          dataMap["strIngredient$i"] == null) {
        break;
      }
      if (dataMap["strMeasure$i"] == "" || dataMap["strMeasure$i"] == null) {
        break;
      }
      ingredientsList.add(dataMap["strIngredient$i"]);
      measureList.add(dataMap["strMeasure$i"]);
    }

    //获取收藏数据
    String favString = sharedPreferences.getString("fav") ?? "";
    if (favString.isNotEmpty) {
      favList = json.decode(favString);
    }
    //判断是否收藏
    for (var data in favList) {
      if (data["idMeal"] == dataMap["idMeal"]) {
        isFav = true;
      }
    }

    //计划收藏数据
    String planString = sharedPreferences.getString("plan") ?? "";
    if (planString.isNotEmpty) {
      planList = json.decode(planString);
    }
    //判断是否收藏
    for (var data in planList) {
      if (data["idMeal"] == dataMap["idMeal"]) {
        isPlan = true;
      }
    }

    setState(() {});
  }

  ///收藏方法
  Future<void> _favFun() async {
    //判断是否已经收藏
    if (isFav) {
      //收藏了则删除id相同的
      favList.removeWhere((element) => element["idMeal"] == dataMap["idMeal"]);
    } else {
      //没有收藏则添加到第一个
      favList.insert(0, dataMap);
    }
    //保存数据
    await sharedPreferences.setString("fav", json.encode(favList));
    isFav = !isFav;

    //刷新收藏数据
    await getIngreData();
    setState(() {});
  }

  ///添加到计划方法
  Future<void> _planFun() async {
    //判断是否已经添加到计划
    if (isPlan) {
      //添加了则删除id相同的
      planList.removeWhere((element) => element["idMeal"] == dataMap["idMeal"]);
    } else {
      //没有收藏则添加到第一个
      dataMap.addAll({
        "time": DateTime.now().toString().substring(0, 10),
        "isCheck": false,
      });
      planList.insert(0, dataMap);
    }
    //保存数据
    await sharedPreferences.setString("plan", json.encode(planList));
    isPlan = !isPlan;
    await getPlanData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: dataMap.isEmpty
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumb(),
                  const SpaceVerticalWidget(),
                  _builtTitle(title: dataMap["strMeal"]),
                  const SpaceVerticalWidget(),
                  _buildTopAirBubble(),
                  const SpaceVerticalWidget(),
                  _buildInstructions(),
                  const SpaceVerticalWidget(),
                  const DuDivide(),
                  const SpaceVerticalWidget(),
                  _builtTitle(title: "Recipe details"),
                  const SpaceVerticalWidget(),
                  _buildBottomAirBubble(),
                  const SpaceVerticalWidget(),
                  _builtSubTitle(title: "Ingredients and Measures"),
                  const SpaceVerticalWidget(),
                  _buildIngAndMea(),
                  const SpaceVerticalWidget(
                    space: 50,
                  ),
                ],
              ),
            ),
    );
  }

  ///材料以及用量
  Padding _buildIngAndMea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            ingredientsList.length,
            (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: ingredientsList[index]),
                        TextSpan(
                            text: " [${measureList[index]}]",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: "TiltNeon"),
                    ),
                  ),
                )),
      ),
    );
  }

  ///底部气泡
  Padding _buildBottomAirBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: padding,
        runSpacing: padding,
        children: dataMap["strTags"] == null
            ? []
            : dataMap["strTags"]
                .toString()
                .split(",")
                .map((e) => AirBubbleWidget(
                    icon: const Icon(Icons.fastfood_outlined), title: e))
                .toList(),
      ),
    );
  }

  ///appbar
  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: _buildAction(),
    );
  }

  //action
  List<Widget> _buildAction() {
    return [
      IconButton(
        onPressed: () async {
          await _favFun();
        },
        icon: Icon(isFav ? Icons.star : Icons.star_border_outlined),
        color: Colors.red,
      ),
      IconButton(
        onPressed: () async {
          await _planFun();
        },
        icon:
            Icon(isPlan ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
        color: Colors.red,
      ),
    ];
  }

  ///步骤详细介绍
  Padding _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        dataMap["strInstructions"],
        style: const TextStyle(fontFamily: "TiltNeon", fontSize: 20),
      ),
    );
  }

  ///顶部气泡
  Padding _buildTopAirBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Wrap(
        spacing: padding,
        runSpacing: padding,
        children: [
          AirBubbleWidget(
            icon: const Icon(Icons.star),
            title: randomRank,
          ),
          AirBubbleWidget(
              icon: const Icon(Icons.emoji_food_beverage_outlined),
              title: dataMap["strCategory"]),
          AirBubbleWidget(
              icon: const Icon(Icons.area_chart_outlined),
              title: dataMap["strArea"]),
        ],
      ),
    );
  }

  ///标题
  Padding _builtTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: "TiltNeon", fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  ///小标题
  Padding _builtSubTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: padding),
      child: Text(
        title,
        style: const TextStyle(
            fontFamily: "TiltNeon", fontWeight: FontWeight.w600, fontSize: 20),
      ),
    );
  }

  ///图片
  ExtendedImage _buildThumb() {
    return ExtendedImage.network(
      dataMap["strMealThumb"],
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
      cache: true,
    );
  }
}
