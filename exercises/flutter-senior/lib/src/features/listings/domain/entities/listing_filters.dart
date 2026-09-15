import 'package:equatable/equatable.dart';

class ListingFilters extends Equatable {
  const ListingFilters({this.minBedrooms, this.maxPricePence});

  static const ListingFilters none = ListingFilters();

  final int? minBedrooms;
  final int? maxPricePence;

  ListingFilters copyWith({int? minBedrooms, int? maxPricePence}) {
    return ListingFilters(
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxPricePence: maxPricePence ?? this.maxPricePence,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (minBedrooms != null) 'min_bedrooms': minBedrooms,
      if (maxPricePence != null) 'max_price_pence': maxPricePence,
    };
  }

  @override
  List<Object?> get props => <Object?>[minBedrooms, maxPricePence];
}
