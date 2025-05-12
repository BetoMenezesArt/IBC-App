class BibleModel {
  final List<Book> books;
  final String? name;

  BibleModel({required this.books, this.name});

  factory BibleModel.fromJson(dynamic json) {
    if (json is List) {
      // Caso o JSON seja uma lista direta de livros
      return BibleModel(
        books: json.map((e) => Book.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return BibleModel(
        name: json['name'] as String?,
        books: (json['books'] as List)
            .map((e) => Book.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      throw Exception('Formato de JSON de bíblia não suportado');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'books': books.map((e) => e.toJson()).toList(),
    };
  }
}

class Book {
  final String name;
  final List<Chapter> chapterList;

  Book({required this.name, required this.chapterList});

  factory Book.fromJson(Map<String, dynamic> json) {
    final chaptersRaw = json['chapters'] as List;
    return Book(
      name: json['name'] as String,
      chapterList: List<Chapter>.generate(
        chaptersRaw.length,
        (i) => Chapter(
          chapter: i + 1,
          verses: List<Verse>.generate(
            (chaptersRaw[i] as List).length,
            (j) => Verse(
              verse: j + 1,
              text: (chaptersRaw[i] as List)[j] as String,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'chapterList': chapterList.map((e) => e.toJson()).toList(),
    };
  }
}

class Chapter {
  final int chapter;
  final List<Verse> verses;

  Chapter({required this.chapter, required this.verses});

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'verses': verses.map((e) => e.toJson()).toList(),
    };
  }
}

class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'text': text,
    };
  }
} 