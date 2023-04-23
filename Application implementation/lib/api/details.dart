import 'package:food_app/http/http.dart';

///按 id 查找完整膳食详细信息
Future searchById({required int id}) async {
  return await HttpService.getInstance().get(path: "lookup.php?i=$id");
}
