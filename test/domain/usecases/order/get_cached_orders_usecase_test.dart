import 'package:dartz/dartz.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/domain/repositories/order_repository.dart';
import 'package:eshop/domain/usecases/order/get_cached_orders_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/constant_objects.dart';

class MockCartRepository extends Mock implements OrderRepository {}

void main() {
  late GetCachedOrdersUseCase usecase;
  late MockCartRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockCartRepository();
    usecase = GetCachedOrdersUseCase(mockProductRepository);
  });

  test(
    'Should get order from the repository when Order Repository add data successfully',
        () async {
      /// Arrange
      when(() => mockProductRepository.getCachedOrders())
          .thenAnswer((_) async => Right([tOrderDetailsModel]));

      /// Act
      final result = await usecase(NoParams());

      /// Assert
      result.fold(
            (failure) => fail('Test Fail!'),
            (cart) => expect(cart, [tOrderDetailsModel]),
      );
      verify(() => mockProductRepository.getCachedOrders());
      verifyNoMoreInteractions(mockProductRepository);
    },
  );

  test('should return a Failure from the repository', () async {
    /// Arrange
    final failure = NetworkFailure();
    when(() => mockProductRepository.getCachedOrders())
        .thenAnswer((_) async => Left(failure));

    /// Act
    final result = await usecase(NoParams());

    /// Assert
    expect(result, Left(failure));
    verify(() => mockProductRepository.getCachedOrders());
    verifyNoMoreInteractions(mockProductRepository);
  });
}