/*
Modelo Chapter adaptado do Elisha
*/
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Chapter {
  int? id;
  int? bookId;
  int? chapter;
  List<dynamic>? verses;

  Chapter({
    this.id,
    this.bookId,
    this.chapter,
    this.verses,
  });

  Chapter copyWith({
    int? id,
    int? bookId,
    int? chapter,
    List<dynamic>? verses,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verses: verses ?? this.verses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'verses': verses?.map((x) => x?.toMap()).toList(),
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      bookId: map['bookId'],
      chapter: map['chapter'],
      verses: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) => Chapter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chapter(id: $id, bookId: $bookId, chapter: $chapter, verses: $verses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chapter &&
        other.id == id &&
        other.bookId == bookId &&
        other.chapter == chapter &&
        listEquals(other.verses, verses);
  }

  @override
  int get hashCode {
    return id.hashCode ^ bookId.hashCode ^ chapter.hashCode ^ verses.hashCode;
  }
}
class ChapterId {
  int? id;
  ChapterId({this.id});

  ChapterId copyWith({
    int? id,
  }) {
    return ChapterId(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory ChapterId.fromMap(Map<String, dynamic> map) {
    return ChapterId(
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChapterId.fromJson(String source) => ChapterId.fromMap(json.decode(source));

  @override
  String toString() => 'ChapterId(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterId && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 
