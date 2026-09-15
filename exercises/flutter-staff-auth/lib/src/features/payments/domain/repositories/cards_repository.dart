import 'package:kerb/src/features/payments/domain/entities/saved_card.dart';

abstract class CardsRepository {
  Future<List<SavedCard>> cards();
}
