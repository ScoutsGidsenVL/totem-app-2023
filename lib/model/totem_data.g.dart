// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totem_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotemData _$TotemDataFromJson(Map<String, dynamic> json) => TotemData(
      (json['animals'] as List<dynamic>)
          .map((e) => AnimalData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

AnimalData _$AnimalDataFromJson(Map<String, dynamic> json) => AnimalData(
      json['id'] as int,
      json['name'] as String,
      (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['traits'] as List<dynamic>).map((e) => e as String).toList(),
      json['description'] as String,
    );
