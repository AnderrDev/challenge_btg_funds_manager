import 'package:btg_funds_manager/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BTGValidators', () {
    group('validateEmail', () {
      test('should return error message if email is null', () {
        final result = BTGValidators.validateEmail(null);
        expect(result, 'Ingrese su email');
      });

      test('should return error message if email is empty', () {
        final result = BTGValidators.validateEmail('');
        expect(result, 'Ingrese su email');
      });

      test('should return error message if email is invalid', () {
        final result = BTGValidators.validateEmail('invalid-email');
        expect(result, 'Email inválido');
      });

      test('should return null if email is valid', () {
        final result = BTGValidators.validateEmail('test@example.com');
        expect(result, null);
      });
    });

    group('validatePhone', () {
      test('should return error message if phone is null', () {
        final result = BTGValidators.validatePhone(null);
        expect(result, 'Ingrese su teléfono');
      });

      test('should return error message if phone is empty', () {
        final result = BTGValidators.validatePhone('');
        expect(result, 'Ingrese su teléfono');
      });

      test('should return error message if phone has less than 10 digits', () {
        final result = BTGValidators.validatePhone('123456789');
        expect(result, 'Mínimo 10 dígitos');
      });

      test('should return null if phone has 10 or more digits', () {
        final result = BTGValidators.validatePhone('1234567890');
        expect(result, null);
      });

      test('should ignore non-numeric characters when checking length', () {
        final result = BTGValidators.validatePhone('123-456-7890');
        expect(result, null);
      });
    });

    group('required', () {
      test('should return error message if value is null', () {
        final result = BTGValidators.required(null, 'Nombre');
        expect(result, 'Ingrese Nombre');
      });

      test('should return error message if value is empty', () {
        final result = BTGValidators.required('', 'Nombre');
        expect(result, 'Ingrese Nombre');
      });

      test('should return null if value is not empty', () {
        final result = BTGValidators.required('John Doe', 'Nombre');
        expect(result, null);
      });
    });
  });
}
