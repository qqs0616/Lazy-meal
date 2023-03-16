import '../http/index.dart';

///获取所有区域
Future getAllArea() async {
  return await HttpService.getInstance().get(path: "list.php?a=list");
}

///根据国家过滤
Future filterArea({required String area}) async {
  return await HttpService.getInstance().get(path: "filter.php?a=$area");
}

///根据类别过滤
Future filterCuisine({required String cuisine}) async {
  return await HttpService.getInstance().get(path: "filter.php?c=$cuisine");
}

///根据成分过滤
Future filterIngredients({required String ingredients}) async {
  return await HttpService.getInstance().get(path: "filter.php?i=$ingredients");
}

///获取所有类别
Future getAllCategory() async {
  return await HttpService.getInstance().get(path: "list.php?c=list");
}

///获取所有成分
Future getAllIngredients() async {
  return await HttpService.getInstance().get(path: "list.php?i=list");
}

///通过名字获取食物列表
Future getFoodFromName({required String name}) async {
  return await HttpService.getInstance().get(path: "search.php?s=$name");
}
