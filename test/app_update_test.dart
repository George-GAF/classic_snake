import 'package:classic_snake/gaf_package/gaf_service/app-update.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUpdate.haveLastVersion', () {
    test('equal versions means no update', () {
      expect(AppUpdate.haveLastVersion('3.0.1', '3.0.1'), isTrue);
    });

    test('newer major/minor/patch means update available', () {
      expect(AppUpdate.haveLastVersion('3.0.2', '3.0.1'), isFalse);
      expect(AppUpdate.haveLastVersion('3.1.0', '3.0.9'), isFalse);
      expect(AppUpdate.haveLastVersion('4.0.0', '3.9.9'), isFalse);
    });

    test('older last version means no update', () {
      expect(AppUpdate.haveLastVersion('3.0.0', '3.0.1'), isTrue);
      expect(AppUpdate.haveLastVersion('2.9.0', '3.0.0'), isTrue);
    });

    test('numeric compare beats lexicographic order', () {
      expect(AppUpdate.haveLastVersion('1.10.0', '1.2.0'), isFalse);
      expect(AppUpdate.haveLastVersion('2.0.5', '1.10.10'), isFalse);
      expect(AppUpdate.haveLastVersion('1.2.0', '1.10.0'), isTrue);
    });

    test('variable length segments are padded with zero', () {
      expect(AppUpdate.haveLastVersion('3.0', '3.0.1'), isTrue);
      expect(AppUpdate.haveLastVersion('3.1', '3.0.1'), isFalse);
    });

    test('non-numeric segments are ignored', () {
      expect(AppUpdate.parseVersion('3.0.1-b'), [3, 0]);
      expect(AppUpdate.haveLastVersion('3.0.1-b', '3.0.1'), isTrue);
    });
  });
}