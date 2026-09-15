import 'package:equatable/equatable.dart';

class Listing extends Equatable {
  const Listing({
    required this.id,
    required this.title,
    required this.town,
    required this.pricePence,
    required this.bedrooms,
    required this.imageUrl,
    required this.epcRating,
    required this.addedAt,
  });

  final String id;
  final String title;
  final String town;
  final int pricePence;
  final int bedrooms;
  final String imageUrl;
  final String epcRating;
  final DateTime addedAt;

  @override
  List<Object?> get props => <Object?>[
    id,
    title,
    town,
    pricePence,
    bedrooms,
    imageUrl,
    epcRating,
    addedAt,
  ];
}
