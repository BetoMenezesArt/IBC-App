import 'package:flutter/material.dart';
import 'bible/models/bible_model.dart';
import 'bible/services/bible_service.dart';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  BibleModel? _bible;
  String _selectedTranslation = 'KJV'; // Começando com KJV como padrão
  Book? _selectedBook;
  Chapter? _selectedChapter;
  List<String> _availableTranslations = [];

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      _availableTranslations = await BibleService.getAvailableTranslations();
      await _loadTranslation(_selectedTranslation);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar traduções: $e')),
        );
      }
    }
  }

  Future<void> _loadTranslation(String translation) async {
    try {
      final bible = await BibleService.loadTranslation(translation);
      setState(() {
        _bible = bible;
        _selectedBook = bible.books.first;
        _selectedChapter = _selectedBook?.chapterList.first;
        _selectedTranslation = translation;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar tradução: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bible == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_bible?.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () => _showTranslationDialog(),
          ),
        ],
      ),
      body: Row(
        children: [
          // Lista de livros
          SizedBox(
            width: 200,
            child: ListView.builder(
              itemCount: _bible!.books.length,
              itemBuilder: (context, index) {
                final book = _bible!.books[index];
                return ListTile(
                  title: Text(book.name),
                  selected: book == _selectedBook,
                  onTap: () {
                    setState(() {
                      _selectedBook = book;
                      _selectedChapter = book.chapterList.first;
                    });
                  },
                );
              },
            ),
          ),
          // Lista de capítulos
          SizedBox(
            width: 100,
            child: ListView.builder(
              itemCount: _selectedBook?.chapterList.length ?? 0,
              itemBuilder: (context, index) {
                final chapterNumber = index + 1;
                return ListTile(
                  title: Text('$chapterNumber'),
                  selected: _selectedChapter?.chapter == chapterNumber,
                  onTap: () {
                    setState(() {
                      _selectedChapter = _selectedBook?.chapterList[index];
                    });
                  },
                );
              },
            ),
          ),
          // Versículos
          Expanded(
            child: ListView.builder(
              itemCount: _selectedChapter?.verses.length ?? 0,
              itemBuilder: (context, index) {
                final verse = _selectedChapter!.verses[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: '${verse.verse} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(text: verse.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTranslationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione a Tradução'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableTranslations.length,
            itemBuilder: (context, index) {
              final translation = _availableTranslations[index];
              return ListTile(
                title: Text(translation),
                selected: translation == _selectedTranslation,
                onTap: () {
                  _loadTranslation(translation);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}