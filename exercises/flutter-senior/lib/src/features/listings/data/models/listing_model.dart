import 'package:habitat/src/features/listings/domain/entities/listing.dart';

class ListingModel {
  const ListingModel({
    required this.id,
    required this.title,
    required this.town,
    required this.pricePence,
    required this.bedrooms,
    required this.imageUrl,
    required this.epcRating,
    required this.addedAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      title: json['title'] as String,
      town: json['town'] as String,
      pricePence: json['price_pence'] as int,
      bedrooms: json['bedrooms'] as int,
      imageUrl: json['image_url'] as String,
      epcRating: json['epc_rating'] as String,
      addedAt: json['added_at'] as int,
    );
  }

  final String id;
  final String title;
  final String town;
  final int pricePence;
  final int bedrooms;
  final String imageUrl;
  final String epcRating;
  final int addedAt;

  Listing toEntity() {
    return Listing(
      id: id,
      title: title,
      town: town,
      pricePence: pricePence,
      bedrooms: bedrooms,
      imageUrl: imageUrl,
      epcRating: epcRating,
      addedAt: DateTime.fromMillisecondsSinceEpoch(addedAt),
    );
  }
}
