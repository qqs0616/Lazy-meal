import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_app/common/constant.dart';
import 'package:food_app/widgets/air.dart';
import 'package:food_app/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../untils/index.dart';

///购物车页
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

ValueNotifier<List> favList = ValueNotifier([]);

Future getFavData() async {
  var favString = sharedPreferences.getString("fav") ?? "";
  if (favString.isNotEmpty) {
    favList.value = json.decode(favString);
    favList.notifyListeners();
  }
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavData();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('123');
    return ValueListenableBuilder(
      valueListenable: favList,
      builder: (BuildContext context, List<dynamic> value, Widget? child) {
        return Scaffold(
          body: value.isEmpty
              ? const Center(
                  child: Text(
                    "No food collection list",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "TiltNeon"),
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      children: [
                        // _buildTitle(),
                        TitleWidget(
                            title: "Favorites",
                            onPress: () async {
                              await sharedPreferences.setString("fav", "");
                              value = [];
                              favList.notifyListeners();
                            }),
                        const SpaceVerticalWidget(),
                        _buildList()
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  ///收藏食物列表
  Expanded _buildList() {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) {
        var data = favList.value[index];
        return _item(index, data);
      },
      itemCount: favList.value.length,
    ));
  }


  ///item
  Slidable _item(int index, data) {
    return Slidable(
      key: ValueKey("$index"),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              await _remove(index);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: padding),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                data["strMealThumb"],
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SpaceHorizontalWidget(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemText(
                  data: data["strMeal"].toString().trim(),
                ),
                const SpaceVerticalWidget(),
                _buildItemText(
                    data: data["strInstructions"].toString().trim(),
                    fontSize: 15),
                const SpaceVerticalWidget(),
                Wrap(
                  spacing: padding,
                  runSpacing: padding,
                  children: [
                    AirBubbleWidget(
                        icon: const Icon(Icons.fastfood_outlined),
                        title: data["strCategory"]),
                    AirBubbleWidget(
                        icon: const Icon(Icons.area_chart_outlined),
                        title: data["strArea"])
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  ///删除方法
  Future<void> _remove(int index) async {
    favList.value.removeAt(index);
    favList.notifyListeners();
    //保存数据
    await sharedPreferences.setString("fav", json.encode(favList.value));
    setState(() {});
  }

  ///列表中的标题集合
  Text _buildItemText({required String data, double? fontSize}) {
    return Text(
      data,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: fontSize ?? 20,
          fontWeight: FontWeight.bold,
          fontFamily: "TiltNeon"),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
