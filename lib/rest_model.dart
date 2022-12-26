import 'dart:convert';

import 'rest.dart';
import 'rest_card.dart';
import 'package:http/http.dart' as http;

class RestModel {
  static const imagePathes = <String>[
    'asset/rest1.jpg',
    'asset/rest2.jpg',
    'asset/rest3.jpg',
    'asset/rest4.jpg',
    'asset/rest5.jpg',
    'asset/rest6.jpg',
    'asset/rest7.jpg',
    'asset/rest8.jpg',
    'asset/rest9.jpg',
    'asset/rest10.jpg',
    'asset/rest11.jpg',
    'asset/rest12.jpg',
  ];

  static const titles = <String>[
    '七海魚皮',
    '開元路無名虱目魚 ‧ 肉燥飯',
    '懷舊小棧杏仁豆腐冰',
    '鮨瑀壽司',
    '櫻之庭食堂',
    '神戶廚房 日本料理',
    '隱糧義式餐館 SECRET AND SENSES',
    'The Sober Foodie 食上主義餐酒館',
    '饗義廚房 台南義大利麵',
    '亞芙 The Artful Dodger',
    'Factory 共嚐美式餐酒館',
    'Nest_de_O_bar',
  ];

  static const plot = <String>[
    '食怪特意挑了剛開始營業的時間去才能優閒地吃，不然第一次跟朋友吃的時候很多東西都已經賣完了，而且人又非常的多，建議可以早點去才不用人擠人喔',
    '很多人推薦用料實在的鮮美虱目魚肚湯，還有入口即化黏嘴的肉燥飯，一大早來的朋友更是會點隱藏版魚腸，還有晚來就賣光的魚皮湯唷。',
    '五妃廟旁專賣杏仁豆腐冰，加上湯圓更好吃！超滑順口感份量十足吃起來超有爽度～',
    '台南壽司日式料理「鮨瑀壽司」嚴選新鮮漁獲！生魚握壽司！北海膽進口海膽太推薦~｜無菜單料理|',
    '小資族看過來!平價定食135元起~隱身在住宅區巷內的食堂，近成功大學。台南午餐|北區美食',
    '東豐路上平價高CP值日本料理餐館',
    '傳統經典卻在地的義式餐館，頂級主廚以正統義式烹調手法、保留食材原始風味，演繹出帶有府城故事味的多元西餐風貌，再佐以原創調酒，讓客人盡情享受煙波獨有的義式佳餚酩釀。',
    '店內提供義大利麵、燉飯、排餐及各式各樣的小點菜色，份量偏多，適合跟朋友一起分食享用，用餐氣氛也很棒，約會也蠻適合的哦！',
    '義大利和台南共同精神象徵都是懂得細細品嚐、慢慢生活， 這裡的"慢"，指的是花時間去享受、品味! 擷取義大利人料理時對食材原味的重視。',
    '"亞芙英式餐廳" 是由一位英國主廚開的英式風格的餐廳，供應英式、美式和歐式料理，並結合運動酒吧風格，可以說是蠻有特色的異國料理餐廳。',
    '有別於一般美式餐廳的風格設計，外觀相當具有質感。其中最大特色就是美籍主廚，料理出一道道相當具有創意的道地美式加州創意菜色！',
    '裝潢和滿滿的電影人物玩偶，營造出驚悚美式遊樂場風！酒也很好喝！台南必去的酒吧推薦給你們！',
  ];

  static var favorites = <RestCard>[];

  static void toggleFav(RestCard rest) {
    favorites.contains(rest) ? favorites.remove(rest) : favorites.add(rest);
  }

  static int getFavLen() => favorites.length;

  static RestCard getFavByIndex(int index) {
    return favorites[index];
  }

  static Rest getMovieByIndex(int row, int index) {
    return Rest(
      imagePath: imagePathes[row * 3 + index],
      title: titles[row * 3 + index],
      plot: plot[row * 3 + index],
    );
  }

  static Future<List<Rest>> getRest(String? selectedCategory) async {
    final res = await http.post(
      Uri.parse('http://192.168.211.36:30011/get_data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String?>{
        'value': selectedCategory,
      }),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json
          .map<Rest>((result) => Rest.fromJson(result))
          .toList();
    } else {
      throw Exception('Failed to load restaurant: ${res.body}');
    }
  }
}
