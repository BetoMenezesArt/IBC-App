/* Tela da Bíblia adaptada do Elisha */
import 'package:flutter/material.dart';
import 'models/bible_model.dart';
import 'services/bible_service.dart';
import 'dart:math';

class BiblePage extends StatefulWidget {
  const BiblePage({super.key});

  @override
  State<BiblePage> createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  BibleModel? _bible;
  String _selectedTranslation = 'Almeida Atualizada';
  Book? _selectedBook;
  Chapter? _selectedChapter;
  List<String> _availableTranslations = [];
  bool _isBookmarked = false;
  double _fontSize = 26;
  double _lineSpacing = 1.4;
  String _fontFamily = 'Inter';
  double _brightness = 0.5;
  final List<String> _availableFonts = ['New York', 'Inter', 'Georgia', 'Times New Roman', 'Serif'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _goToPreviousChapter() {
    if (_selectedBook == null || _selectedChapter == null) return;
    final chapters = _selectedBook!.chapterList;
    final idx = chapters.indexOf(_selectedChapter!);
    if (idx > 0) {
      setState(() {
        _selectedChapter = chapters[idx - 1];
      });
    }
  }

  void _goToNextChapter() {
    if (_selectedBook == null || _selectedChapter == null) return;
    final chapters = _selectedBook!.chapterList;
    final idx = chapters.indexOf(_selectedChapter!);
    if (idx < chapters.length - 1) {
      setState(() {
        _selectedChapter = chapters[idx + 1];
      });
    }
  }

  void _showBookChapterDialog() async {
    if (_bible == null) return;
    final books = _bible!.books;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  height: 6,
                  width: 60,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const Text('Livros', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 22,
                  )
                ),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: books.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
                    itemBuilder: (context, i) {
                      final book = books[i];
                      return ExpansionTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            book.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        initiallyExpanded: false,
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              const int crossAxisCount = 5;
                              const double spacing = 12.0;
                              
                              // Calculate item width based on available width
                              final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1)) - 48) / crossAxisCount;
                              final itemHeight = itemWidth; // Square aspect ratio
                              
                              return Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 8),
                                child: Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: book.chapterList.map((chapter) {
                                    final isSelected = book == _selectedBook && chapter == _selectedChapter;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedBook = book;
                                          _selectedChapter = chapter;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: itemWidth,
                                        height: itemHeight,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected ? Colors.black : Colors.grey[300]!,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          color: isSelected ? Colors.grey[200] : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          (chapter.chapter).toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: isSelected ? Colors.black : Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTranslationDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            // Mudar a cor de seleção para cinza
            listTileTheme: ListTileThemeData(
              selectedTileColor: Colors.grey[200],
              selectedColor: Colors.black,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 60,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const Text('Traduções', 
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _availableTranslations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final translation = _availableTranslations[index];
                    final isSelected = translation == _selectedTranslation;
                    String acronym = '';
                    if (translation == 'Almeida Atualizada') acronym = 'AA';
                    else if (translation == 'Almeida Corrigida Fiel') acronym = 'ACF';
                    else if (translation == 'Nova Versão Internacional') acronym = 'NVI';
                    else if (translation == 'King James Version') acronym = 'KJV';
                    else if (translation == 'American Standard Version') acronym = 'ASV';
                    else if (translation == 'Bible in Basic English') acronym = 'BBE';
                    else if (translation == 'World English Bible') acronym = 'WEB';
                    else if (translation == 'Young Literal Translation') acronym = 'YLT';
                    else acronym = translation.substring(0, min(3, translation.length));
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      title: Text(
                        translation,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        acronym,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: Colors.grey[200],
                      onTap: () {
                        _loadTranslation(translation);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 6,
                    width: 60,
                    margin: const EdgeInsets.only(bottom: 24, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.center,
                  ),
                  Row(
                    children: [
                      Icon(Icons.brightness_low, color: Colors.grey),
                      Expanded(
                        child: Slider(
                          value: _brightness,
                          onChanged: (value) {
                            setModalState(() {
                              setState(() {
                                _brightness = value;
                              });
                            });
                          },
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      Icon(Icons.brightness_high, color: Colors.grey),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tamanho do Texto', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w500,
                        )
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: IconButton(
                              icon: Text(
                                'A', 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 18,
                                )
                              ),
                              onPressed: () {
                                setModalState(() {
                                  setState(() {
                                    if (_fontSize > 15) _fontSize -= 1;
                                  });
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: IconButton(
                              icon: Text(
                                'A', 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 24,
                                )
                              ),
                              onPressed: () {
                                setModalState(() {
                                  setState(() {
                                    if (_fontSize < 40) _fontSize += 1;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Escolha a fonte',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _availableFonts.length,
                                itemBuilder: (context, index) {
                                  final font = _availableFonts[index];
                                  return ListTile(
                                    title: Text(
                                      font,
                                      style: TextStyle(fontFamily: font),
                                    ),
                                    selected: font == _fontFamily,
                                    selectedTileColor: Colors.grey[200],
                                    onTap: () {
                                      setModalState(() {
                                        setState(() {
                                          _fontFamily = font;
                                        });
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fonte', 
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.w500,
                          )
                        ),
                        Row(
                          children: [
                            Text(
                              _fontFamily,
                              style: TextStyle(
                                fontSize: 16, 
                                fontFamily: _fontFamily,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Espaçamento', 
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.w500,
                        )
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.format_align_center, color: Colors.white),
                              onPressed: () {
                                setModalState(() {
                                  setState(() {
                                    if (_lineSpacing > 1.3) _lineSpacing -= 0.1;
                                  });
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.format_line_spacing, color: Colors.white),
                              onPressed: () {
                                setModalState(() {
                                  setState(() {
                                    if (_lineSpacing < 2.0) _lineSpacing += 0.1;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 24),
            onPressed: () => _showSettingsBottomSheet(),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              _showBookChapterDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedBook != null && _selectedChapter != null
                        ? '${_selectedBook!.name} ${_selectedChapter!.chapter}'
                        : '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 20,
                    width: 1,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _showTranslationDialog,
                    child: Text(
                      _selectedTranslation == 'Almeida Atualizada' ? 'AA' : 
                      _selectedTranslation == 'King James Version' ? 'KJV' : 
                      _selectedTranslation.substring(0, min(3, _selectedTranslation.length)).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 24),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 24),
            onPressed: _goToPreviousChapter,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 24),
            onPressed: _goToNextChapter,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bible == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildHeader(context),
            ),
            Expanded(
              child: _selectedChapter == null
                  ? const SizedBox.shrink()
                  : Theme(
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.all(Colors.grey[400]),
                          thickness: MaterialStateProperty.all(6.0),
                          radius: const Radius.circular(3.0),
                          thumbVisibility: MaterialStateProperty.all(true),
                        ),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: _buildVerseSpans(),
                                ),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.home_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.people_outline,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    // Ação para a página de rede social
                  },
                ),
                const SizedBox(width: 60), // Manter consistência com a Home
                IconButton(
                  icon: const Icon(
                    Icons.church_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  elevation: 0,
                  child: InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: const Icon(Icons.menu_book, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<InlineSpan> _buildVerseSpans() {
    if (_selectedChapter == null) {
      return [];
    }
    
    // Estilo para o texto principal
    final textStyle = TextStyle(
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      height: _lineSpacing,
      fontWeight: FontWeight.w400, // Sem negrito no texto principal
      color: Colors.black,
      letterSpacing: 0,
    );
    
    // Estilo para os números dos versículos
    final numberStyle = TextStyle(
      fontFamily: _fontFamily,
      fontSize: _fontSize * 0.45, // Números menores
      color: Colors.grey[500], // Números em cinza
      fontWeight: FontWeight.w400,
    );
    
    List<InlineSpan> spans = [];
    
    for (int i = 0; i < _selectedChapter!.verses.length; i++) {
      final verse = _selectedChapter!.verses[i];
      
      // Menos espaço entre versículos
      if (i > 0) {
        spans.add(const TextSpan(text: "\n\n"));
      }
      
      // Primeiro versículo com recuo
      final String verseText = verse.text;
      
      // Número do versículo pequeno e em cinza
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.top,
          child: Transform.translate(
            offset: const Offset(0, 2),
            child: Text(
              verse.verse.toString(),
              style: numberStyle,
            ),
          ),
        ),
      );
      
      // Texto do versículo
      spans.add(
        TextSpan(
          text: " " + verseText,
          style: textStyle,
        ),
      );
    }
    
    return spans;
  }
} 