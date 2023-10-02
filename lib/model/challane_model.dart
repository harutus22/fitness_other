import 'dart:convert';

const challengeId = "challenge_id";
const challengeName = "challenge_name";
const challengeIsPassed = "challenge_is_passed";
const challengeImage = "challenge_image";

class ChallengeModel{
  int? id;
  String? name;
  List<bool>? isPassed;
  String? image;

  ChallengeModel({
    required this.name,
    required this.isPassed,
    required this.image,
});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      challengeId: id,
      challengeName: name,
      challengeIsPassed: jsonEncode(isPassed),
      challengeImage: image,
    };
    return map;
  }

  ChallengeModel.fromMap(Map<dynamic, dynamic> map) {
    final item = map[challengeId];
    id = item == null ? 0 : item as int;
    name = map[challengeName] as String;
    isPassed = getList(jsonDecode(map[challengeIsPassed]));
    image = map[challengeImage] as String;
  }

  List<bool> getList(List<dynamic> a){
    List<bool>list = [];
    for(final item in a){
      list.add(item as bool);
    }
    return list;
  }
}