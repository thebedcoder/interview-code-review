import 'package:kerb/src/features/payments/domain/entities/saved_card.dart';

class SavedCardModel {
  const SavedCardModel({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.networkToken,
  });

  factory SavedCardModel.fromJson(Map<String, dynamic> json) {
    return SavedCardModel(
      id: json['id'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expiryMonth: json['expiry_month'] as int,
      expiryYear: json['expiry_year'] as int,
      networkToken: json['network_token'] as String,
    );
  }

  factory SavedCardModel.fromRow(Map<String, Object?> row) {
    return SavedCardModel(
      id: row['id']! as String,
      brand: row['brand']! as String,
      last4: row['last4']! as String,
      expiryMonth: row['expiry_month']! as int,
      expiryYear: row['expiry_year']! as int,
      networkToken: row['network_token']! as String,
    );
  }

  final String id;
  final String brand;
  final String last4;
  final int expiryMonth;
  final int expiryYear;
  final String networkToken;

  Map<String, Object?> toRow() => <String, Object?>{
    'id': id,
    'brand': brand,
    'last4': last4,
    'expiry_month': expiryMonth,
    'expiry_year': expiryYear,
    'network_token': networkToken,
  };

  SavedCard toEntity() => SavedCard(
    id: id,
    brand: brand,
    last4: last4,
    expiryMonth: expiryMonth,
    expiryYear: expiryYear,
    networkToken: networkToken,
  );
}
