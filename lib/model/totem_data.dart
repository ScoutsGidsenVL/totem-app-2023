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
class AnimalData {
  AnimalData(this.id, this.name, this.synonyms, this.traits, this.description);

  int id;
  String name;
  List<String>? synonyms;
  List<String> traits;
  String description;

  factory AnimalData.fromJson(Map<String, dynamic> json) =>
      _$AnimalDataFromJson(json);
}
