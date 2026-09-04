import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:photos/utils/image_decode_size.dart';

void main() {
  group('imageDecodeSizeForDisplay', () {
    test('samples a 50 MP camera image for a low resolution phone', () {
      final result = imageDecodeSizeForDisplay(
        sourceWidth: 8160,
        sourceHeight: 6120,
        viewportSize: const Size(720, 1600),
        devicePixelRatio: 1,
        maxDecodedPixels: lowMemoryImageDecodePixelLimit,
      );

      expect(result, isNotNull);
      expect(result!.width, closeTo(1440, 2));
      expect(result.height, closeTo(1080, 2));
      expect(result.width * result.height, lessThan(8 * 1000 * 1000));
    });

    test('keeps an image that is already below the display requirement', () {
      final result = imageDecodeSizeForDisplay(
        sourceWidth: 1200,
        sourceHeight: 1600,
        viewportSize: const Size(1080, 2400),
        devicePixelRatio: 2,
        maxDecodedPixels: defaultImageDecodePixelLimit,
      );

      expect(result, isNull);
    });

    test('enforces the memory cap on a high density display', () {
      final result = imageDecodeSizeForDisplay(
        sourceWidth: 8000,
        sourceHeight: 6000,
        viewportSize: const Size(1440, 3200),
        devicePixelRatio: 3,
        maxDecodedPixels: lowMemoryImageDecodePixelLimit,
      );

      expect(result, isNotNull);
      expect(result!.width * result.height, closeTo(8 * 1000 * 1000, 5000));
    });
  });
}
