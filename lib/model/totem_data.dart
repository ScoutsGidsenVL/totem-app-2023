import 'package:azlistview/azlistview.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:totemapp/util.dart';

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
  AnimalData(this.id, this.name, this.synonyms, this.traits, this.description,
      this.image)
      : isNew = id >= 393 && DateTime.now().isBefore(DateTime(2026, 1, 1));

  int id;
  String name;
  List<String> synonyms;
  List<String> traits;
  String description;
  String image;
  final bool isNew;

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
  TraitData(this.id, this.name, this.synonyms);

  int id;
  String name;
  List<String> synonyms;

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
