import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igreja_app/home_page.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:typed_data';

class MockImageProvider extends Fake implements ImageProvider<Object> {
  final Uint8List _transparentImage = Uint8List.fromList([
    0x89,
    0x50,
    0x4e,
    0x47,
    0x0d,
    0x0a,
    0x1a,
    0x0a,
    0x00,
    0x00,
    0x00,
    0x0d,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1f,
    0x15,
    0xc4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0a,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9c,
    0x63,
    0xfc,
    0xff,
    0x00,
    0x05,
    0x00,
    0xfa,
    0xfc,
    0x1c,
    0xe9,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4e,
    0x44,
    0xae,
    0x42,
    0x60,
    0x82,
  ]);

  @override
  ImageStream resolve(ImageConfiguration configuration) {
    final stream = ImageStream();
    _loadAsync(stream);
    return stream;
  }

  Future<void> _loadAsync(ImageStream stream) async {
    final completer = Completer<ImageInfo>();
    stream.setCompleter(OneFrameImageStreamCompleter(completer.future));
    try {
      final codec = await ui.instantiateImageCodec(
        _transparentImage,
      ); // Usar a imagem PNG válida
      final frameInfo = await codec.getNextFrame();
      final imageInfo = ImageInfo(image: frameInfo.image);
      completer.complete(imageInfo);
    } catch (error, stack) {
      completer.completeError(error, stack);
    }
  }

  @override
  Future<ImageStreamCompleter> load(
    ImageConfiguration configuration,
    ImageErrorListener onError,
  ) async {
    try {
      final codec = await ui.instantiateImageCodec(
        _transparentImage,
      ); // Usar a imagem PNG válida
      final frameInfo = await codec.getNextFrame();
      final imageInfo = ImageInfo(image: frameInfo.image);
      return OneFrameImageStreamCompleter(Future.value(imageInfo));
    } catch (error, stack) {
      onError(error, stack);
      rethrow;
    }
  }
}

void main() {
  testWidgets('Testa a tela inicial com mock de imagem', (
    WidgetTester tester,
  ) async {
    final mockImageProvider = MockImageProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(),
          child: HomePage(profileImageProvider: mockImageProvider),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsOneWidget);
    final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(circleAvatar.backgroundImage, isA<MockImageProvider>());

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Olá, Beto'), findsOneWidget);
    expect(find.text('Desejamos graça e paz para seu dia.'), findsOneWidget);
    expect(find.byType(ClipPath), findsOneWidget);
  });
}
