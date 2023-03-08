import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';

part 'totem_data.g.dart';

@JsonSerializable(createToJson: false)
class TotemData {
  TotemData(this.animals);

  List<AnimalData> animals;

  factory TotemData.fromJson(Map<String, dynamic> json) =>
      _$TotemDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class AnimalData extends ISuspensionBean {
  AnimalData(this.id, this.name, this.synonyms, this.traits, this.description);

  int id;
  String name;
  List<String>? synonyms;
  List<String> traits;
  String description;

  @override
  String getSuspensionTag() {
    return _getSuspensionTag(name);
  }

  factory AnimalData.fromJson(Map<String, dynamic> json) =>
      _$AnimalDataFromJson(json);
}

class TraitData extends ISuspensionBean {
  TraitData(this.trait);

  String trait;

  @override
  String getSuspensionTag() {
    return _getSuspensionTag(trait);
  }
}

String _getSuspensionTag(String value) {
  var tag = value.substring(0, 1).toUpperCase();
  if (RegExp("[A-Z]").hasMatch(tag)) {
    return tag;
  } else {
    return "#";
  }
}
