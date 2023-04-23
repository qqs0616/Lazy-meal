import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_app/untils/index.dart';
import 'package:food_app/widgets/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/index.dart';
import '../main.dart';

///计划页
class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  State<PlanPage> createState() => _PlanPageState();
}

///用于局部刷新
ValueNotifier<List> planDataList = ValueNotifier([]);

///所有的plan的数据
ValueNotifier<List<Map>> planList = ValueNotifier([]);

Future getPlanData() async {
  sharedPreferences = await SharedPreferences.getInstance();
  var planString = sharedPreferences.getString("plan") ?? "";
  if (planString.isNotEmpty) {
    planDataList.value = json.decode(planString);
    planDataList.notifyListeners();
    //初始化List
    planList.value = [];
    for (var element1 in planDataList.value) {
      //判断是否在这个时间点已经存有数据
      bool isHave =
          planList.value.any((element) => element["time"] == element1["time"]);

      //如果已经包含
      if (isHave) {
        //找到那条Map，将数据添加到最后
        Map firstWhere = planList.value
            .firstWhere((element) => element["time"] == element1["time"]);
        firstWhere["data"].add(element1);
      } else {
        //没有找到就自己添加进去数据
        Map map = {
          "time": element1["time"],
          "data": [element1],
        };
        planList.value.add(map);
      }
      planList.notifyListeners();
    }
  }
}

class _PlanPageState extends State<PlanPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    planDataList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ValueListenableBuilder(
        builder: (BuildContext context, List value, Widget? child) {
          //除了今天以外的数据

          return value.isEmpty
              ? const Center(
                  child: Text(
                    "No Meal Plan list",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                        _buildTodayList(size, value),
                        const SliverToBoxAdapter(
                          child: SpaceVerticalWidget(),
                        ),
                        _secondTitle(),
                        const SliverToBoxAdapter(
                          child: SpaceVerticalWidget(),
                        ),
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            var previousData = _getPreviousData(value)[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTime(previousData["time"]),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                ),
                                const SpaceVerticalWidget(),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var data = previousData["data"][index];
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: CheckPlanWidget(
                                          src: '${data["strMealThumb"]}',
                                          isCheck: data["isCheck"],
                                          onTap: () async {
                                            await _checkPlan(data);
                                          },
                                        ),
                                      );
                                    },
                                    itemCount: previousData["data"].length,
                                  ),
                                ),
                                const SpaceVerticalWidget(),
                              ],
                            );
                          }, childCount: _getPreviousData(value).length),
                        ),
                        // _buildTestButton()
                      ],
                    ),
                  ),
                );
        },
        valueListenable: planList,
      ),
    );
  }

  ///将时间转换成想要的格式
  String getTime(String time) {
    String date = "";
    int firstIndex = time.indexOf("-");
    int lastIndex = time.lastIndexOf("-");
    String? month = monthMap[time.substring(firstIndex + 1, lastIndex)];
    String day = time.substring(lastIndex + 1, time.length);
    date = "$month ${day}th";
    return date;
  }

  ///测试添加数据
  SliverToBoxAdapter _buildTestButton() {
    return SliverToBoxAdapter(
      child: TextButton(
          onPressed: () async {
            Map map = {
              "idMeal": "52842",
              "strMeal": "Broccoli & Stilton soup",
              "strDrinkAlternate": null,
              "strCategory": "Starter",
              "strArea": "British",
              "strInstructions":
                  "Heat the rapeseed oil in a large saucepan and then add the onions. Cook on a medium heat until soft. Add a splash of water if the onions start to catch.\r\n\r\nAdd the celery, leek, potato and a knob of butter. Stir until melted, then cover with a lid. Allow to sweat for 5 minutes. Remove the lid.\r\n\r\nPour in the stock and add any chunky bits of broccoli stalk. Cook for 10 – 15 minutes until all the vegetables are soft.\r\n\r\nAdd the rest of the broccoli and cook for a further 5 minutes. Carefully transfer to a blender and blitz until smooth. Stir in the stilton, allowing a few lumps to remain. Season with black pepper and serve.",
              "strMealThumb":
                  "https://www.themealdb.com/images/media/meals/tvvxpv1511191952.jpg",
              "strTags": null,
              "strYoutube": "https://www.youtube.com/watch?v=_HgVLpmNxTY",
              "strIngredient1": "Rapeseed Oil",
              "strIngredient2": "Onion",
              "strIngredient3": "Celery",
              "strIngredient4": "Leek",
              "strIngredient5": "Potatoes",
              "strIngredient6": "Butter",
              "strIngredient7": "Vegetable Stock",
              "strIngredient8": "Broccoli",
              "strIngredient9": "Stilton Cheese",
              "strIngredient10": "",
              "strIngredient11": "",
              "strIngredient12": "",
              "strIngredient13": "",
              "strIngredient14": "",
              "strIngredient15": "",
              "strIngredient16": "",
              "strIngredient17": "",
              "strIngredient18": "",
              "strIngredient19": "",
              "strIngredient20": "",
              "strMeasure1": "2 tblsp ",
              "strMeasure2": "1 finely chopped ",
              "strMeasure3": "1",
              "strMeasure4": "1 sliced",
              "strMeasure5": "1 medium",
              "strMeasure6": "1 knob",
              "strMeasure7": "1 litre hot",
              "strMeasure8": "1 Head chopped",
              "strMeasure9": "140g",
              "strMeasure10": "",
              "strMeasure11": "",
              "strMeasure12": "",
              "strMeasure13": "",
              "strMeasure14": "",
              "strMeasure15": "",
              "strMeasure16": "",
              "strMeasure17": "",
              "strMeasure18": "",
              "strMeasure19": "",
              "strMeasure20": "",
              "strSource":
                  "https://www.bbcgoodfood.com/recipes/1940679/broccoli-and-stilton-soup",
              "strImageSource": null,
              "strCreativeCommonsConfirmed": null,
              "dateModified": null,
              "time": "2023-3-6",
              "isCheck": false
            };
            planDataList.value.add(map);
            await sharedPreferences.setString(
                "plan", json.encode(planDataList.value));
          },
          child: Text("123")),
    );
  }

  ///第二个标题
  SliverToBoxAdapter _secondTitle() {
    return const SliverToBoxAdapter(
      child: TitleWidget(
        title: "Previous meal plans",
        fontSize: 30,
        hasButton: false,
      ),
    );
  }

  SliverToBoxAdapter _buildTodayList(Size size, List<dynamic> value) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: size.height * .28,
        //判断有没有今天的
        child: value.any(_todayCondition)
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var data = _getTodayFirstData(value)[index];
                  return _buildItem(size, data);
                },
                itemCount: _getTodayFirstData(value).length,
              )
            : _buildNoToadyData(),
      ),
    );
  }

  ///List item
  Container _buildItem(Size size, data) {
    return Container(
      margin: const EdgeInsets.only(right: padding * 2),
      width: size.height * .2,
      height: size.width * .28,
      child: Column(
        children: [
          SizedBox(
            width: size.height * .2,
            height: size.height * .2,
            child: CheckPlanWidget(
              src: data["strMealThumb"],
              isCheck: data["isCheck"],
              onTap: () async {
                await _checkPlan(data);
              },
            ),
          ),
          // _buildImagePlan(data, size),
          const SpaceVerticalWidget(),
          Expanded(
            child: Text(
              data["strMeal"],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  ///如果没有今天的数据
  Center _buildNoToadyData() {
    return const Center(
      child: Text(
        "You haven't added a plan today",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  ///改变是否完成今日计划状态
  Future<void> _checkPlan(data) async {
    data["isCheck"] = !data["isCheck"];
    planList.notifyListeners();
    //找到ID和时间相同的，存储数据
    Map map = planDataList.value.firstWhere((element) =>
        element["idMeal"] == data["idMeal"] && element["time"] == data["time"]);
    map["isCheck"] = data["isCheck"];
    await sharedPreferences.setString("plan", json.encode(planDataList.value));
  }

  ///标题
  SliverToBoxAdapter _buildTitle() {
    return SliverToBoxAdapter(
      child: TitleWidget(
        title: 'Meal Plan',
        onPress: () async {
          planList.value = [];
          planDataList.value = [];
          planList.notifyListeners();
          planDataList.notifyListeners();
          await sharedPreferences.setString("plan", "");
        },
      ),
    );
  }

  ///获取今天的数据
  List<dynamic> _getTodayFirstData(List<dynamic> value) {
    return (value.firstWhere(_todayCondition))["data"];
  }

  //获取往期的数据
  List<dynamic> _getPreviousData(List<dynamic> value) {
    return value.where((element) => _previousCondition(element)).toList();
  }

  //判断是否是今天的数据的条件
  bool _todayCondition(element) =>
      element["time"] == DateTime.now().toString().substring(0, 10);

  ///不是今天的数据的条件
  bool _previousCondition(element) =>
      element["time"] != DateTime.now().toString().substring(0, 10);

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///带选择器的图片
class CheckPlanWidget extends StatelessWidget {
  final String src;
  final GestureTapCallback? onTap;
  final bool isCheck;

  const CheckPlanWidget(
      {Key? key, required this.src, this.onTap, this.isCheck = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(padding * 2),
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: padding,
          top: padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                Icons.done,
                size: 25,
                color: isCheck ? Colors.black : Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }
}
