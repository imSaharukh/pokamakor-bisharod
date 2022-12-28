// To parse this JSON data, do
//
//     final DataModel = DataModelFromJson(jsonString);

import 'dart:convert';

List<DataModel> dataModelFromJson(String str) =>
    List<DataModel>.from(json.decode(str).map((x) => DataModel.fromJson(x)));

// String dataModelToJson(List<DataModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataModel {
  DataModel({
    required this.name,
    required this.simtom,
    required this.karon,
    required this.joiboniyantron,
    required this.rasioniknyontron,
    required this.bebostha,
  });

  String name;
  String simtom;
  String karon;
  String joiboniyantron;
  String rasioniknyontron;
  String bebostha;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        name: json["Name"] == null ? null : json["Name"],
        simtom: json["উপসর্গ"] == null ? null : json["উপসর্গ"],
        karon: json["এটা কি কারণে হয়েছে"] == null
            ? null
            : json["এটা কি কারণে হয়েছে"],
        joiboniyantron:
            json["জৈব নিয়ন্ত্রণ"] == null ? null : json["জৈব নিয়ন্ত্রণ"],
        rasioniknyontron: json["রাসায়নিক নিয়ন্ত্রণ"] == null
            ? null
            : json["রাসায়নিক নিয়ন্ত্রণ"],
        bebostha: json["প্রতিরোধমূলক ব্যবস্থা"] == null
            ? null
            : json["প্রতিরোধমূলক ব্যবস্থা"],
      );

  // Map<String, dynamic> toJson() => {
  //       "Name": name == null ? null : name,
  //       "উপসর্গ": empty == null ? null : empty,
  //       "এটা কি কারণে হয়েছে": DataModel == null ? null : DataModel,
  //       "জৈব নিয়ন্ত্রণ": purple == null ? null : purple,
  //       "রাসায়নিক নিয়ন্ত্রণ": tentacled == null ? null : tentacled,
  //       "প্রতিরোধমূলক ব্যবস্থা": fluffy == null ? null : fluffy,
  //     };
}
