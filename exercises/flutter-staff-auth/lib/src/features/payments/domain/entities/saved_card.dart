import 'package:equatable/equatable.dart';

class SavedCard extends Equatable {
  const SavedCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.networkToken,
  });

  final String id;
  final String brand;
  final String last4;
  final int expiryMonth;
  final int expiryYear;

  /// Reusable token from the payment processor. Charging it does not require
  /// the card number, only this value.
  final String networkToken;

  @override
  List<Object?> get props => <Object?>[
    id,
    brand,
    last4,
    expiryMonth,
    expiryYear,
    networkToken,
  ];
}
