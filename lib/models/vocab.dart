import 'dart:convert';

Vocab vocabFromJson(String str) => Vocab.fromJson(json.decode(str));

String vocabToJson(Vocab data) => json.encode(data.toJson());

class Vocab {
  final String createdAt;
  final String createdBy;
  final String lang1;
  final String lang2;

  Vocab({
    required this.createdAt,
    required this.createdBy,
    required this.lang1,
    required this.lang2,
  });

  factory Vocab.fromJson(Map<String, dynamic> json) => Vocab(
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        lang1: json["lang_1"],
        lang2: json["lang_2"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "created_by": createdBy,
        "lang_1": lang1,
        "lang_2": lang2,
      };
}
