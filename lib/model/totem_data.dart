import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:totem_app/util.dart';

part 'totem_data.g.dart';

@JsonSerializable(createToJson: false)
class TotemData {
  TotemData(this.animals, this.traits);

  List<AnimalData> animals;
  List<TraitData> traits;

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
  @JsonKey(includeFromJson: false)
  bool get isShowSuspension;

  @override
  String getSuspensionTag() {
    return getFirstLetter(name);
  }

  factory AnimalData.fromJson(Map<String, dynamic> json) =>
      _$AnimalDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class TraitData extends ISuspensionBean {
  TraitData(this.id, this.name);

  int id;
  String name;

  @override
  @JsonKey(includeFromJson: false)
  bool get isShowSuspension;

  @override
  String getSuspensionTag() {
    return getFirstLetter(name);
  }

  factory TraitData.fromJson(Map<String, dynamic> json) =>
      _$TraitDataFromJson(json);
}
