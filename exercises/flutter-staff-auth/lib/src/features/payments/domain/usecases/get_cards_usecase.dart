import 'package:kerb/src/features/payments/domain/entities/saved_card.dart';
import 'package:kerb/src/features/payments/domain/repositories/cards_repository.dart';

class GetCardsUseCase {
  const GetCardsUseCase(this._repository);

  final CardsRepository _repository;

  Future<List<SavedCard>> call() => _repository.cards();
}
