import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bible_model.dart';

class BibleService {
  static Future<List<String>> getAvailableTranslations() async {
    // Lista baseada nos arquivos em assets/bible
    return [
      'Almeida Atualizada', // aa.json
      'Almeida Corrigida Fiel', // acf.json
      'Nova Versão Internacional', // nvi.json
      'King James Version', // kjv.json
      'Young Literal Translation', // ylt.json
      'World English Bible', // web.json
      'Bible in Basic English', // bbe.json
      'American Standard Version', // asv.json
    ];
  }

  static String _getAssetForTranslation(String translation) {
    switch (translation) {
      case 'Almeida Atualizada':
        return 'assets/bible/aa.json';
      case 'Almeida Corrigida Fiel':
        return 'assets/bible/acf.json';
      case 'Nova Versão Internacional':
        return 'assets/bible/nvi.json';
      case 'King James Version':
        return 'assets/bible/kjv.json';
      case 'Young Literal Translation':
        return 'assets/bible/ylt.json';
      case 'World English Bible':
        return 'assets/bible/web.json';
      case 'Bible in Basic English':
        return 'assets/bible/bbe.json';
      case 'American Standard Version':
        return 'assets/bible/asv.json';
      default:
        return 'assets/bible/aa.json';
    }
  }

  static Future<BibleModel> loadTranslation(String translation) async {
    try {
      final assetPath = _getAssetForTranslation(translation);
      print('Carregando asset: $assetPath');
      final jsonString = await rootBundle.loadString(assetPath);
      print('JSON carregado, decodificando...');
      final jsonData = json.decode(jsonString);
      print('Decodificado, criando modelo...');
      final bible = BibleModel.fromJson(jsonData);
      print('Modelo criado com sucesso!');
      return bible;
    } catch (e, s) {
      print('Erro ao carregar a bíblia: $e');
      print(s);
      rethrow;
    }
  }
} 