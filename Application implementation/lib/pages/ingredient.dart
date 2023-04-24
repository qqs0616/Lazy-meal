import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_app/common/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../untils/index.dart';
import '../widgets/index.dart';

ValueNotifier<List> ingreList = ValueNotifier([]);

Future getIngreData() async {
  var favString = sharedPreferences.getString("fav") ?? "";
  if (favString.isNotEmpty) {
    ingreList.value = json.decode(favString);
    ingreList.notifyListeners();
  }
}

///食材清单页面
class IngredientPage extends StatefulWidget {
  const IngredientPage({Key? key}) : super(key: key);

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIngreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: ingreList,
        builder: (BuildContext context, List<dynamic> value, Widget? child) {
          return value.isEmpty
              ? const Center(
                  child: Text(
                    "No food ingredient list",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "TiltNeon"),
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: CustomScrollView(
                      slivers: [
                        _buildTitle(),
                        const SliverToBoxAdapter(
                          child: SpaceVerticalWidget(),
                        ),
                        _buildList(value),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return SliverToBoxAdapter(
      child: TitleWidget(
          title: "Ingredient",
          onPress: () async {
            await sharedPreferences.setString("fav", "");
            var data = sharedPreferences.getString("fav");
            print(data);
            ingreList.value = [];
            ingreList.notifyListeners();
          }),
    );
  }

  ///列表
  SliverList _buildList(List<dynamic> value) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        Map data = value[index];
        //找到收藏的食品清单
        List<Map> collectList = getAllCollectList(data);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceVerticalWidget(),
            Text(
              data["strMeal"].toString().trim(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            const SpaceVerticalWidget(),
            ...collectList.map((e) => _buildSlidable(e, data))
          ],
        );
      },
      childCount: value.length,
    ));
  }

  ///滑动项
  Slidable _buildSlidable(Map<dynamic, dynamic> e, Map<dynamic, dynamic> data) {
    return Slidable(
      key: ValueKey("$e"),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              //删除菜品
              data.removeWhere((key, value) => value == e["ingredient"]);
              ingreList.notifyListeners();
              await sharedPreferences.setString(
                  "fav", json.encode(ingreList.value));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: padding),
        child: SizedBox(
          width: double.infinity,
          child: ListTitleWidget(
            title: e["ingredient"],
            subTitle: e["measure"],
          ),
        ),
      ),
    );
  }

  ///获取所有当前食物的清单
  List<Map> getAllCollectList(dynamic data) {
    List<Map> collectList = [];
    if (data == null) return collectList;
    for (int i = 1; i <= 20; i++) {
      if (data["strIngredient$i"] == "" || data["strIngredient$i"] == null) {
        continue;
        // break;
      }
      if (data["strMeasure$i"] == "" || data["strMeasure$i"] == null) {
        continue;
      }

      String ingredient = data["strIngredient$i"];
      String measure = data["strMeasure$i"];
      Map map = {
        "ingredient": ingredient,
        "measure": measure,
      };
      collectList.add(map);
    }
    return collectList;
  }
}
