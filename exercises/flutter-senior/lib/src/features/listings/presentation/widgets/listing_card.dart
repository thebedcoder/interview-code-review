import 'package:flutter/material.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:intl/intl.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    required this.listing,
    required this.isFavourite,
    required this.onFavouriteToggled,
    super.key,
  });

  final Listing listing;
  final bool isFavourite;
  final VoidCallback onFavouriteToggled;

  @override
  Widget build(BuildContext context) {
    final NumberFormat price = NumberFormat.currency(
      locale: 'en_GB',
      symbol: '£',
      decimalDigits: 0,
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              listing.imageUrl,
              fit: BoxFit.cover,
              cacheWidth: 800,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: Color(0xFFE0E0E0)),
            ),
          ),
          ListTile(
            title: Text(listing.title),
            subtitle: Text(
              '${listing.town} · ${listing.bedrooms} bed · '
              '${price.format(listing.pricePence / 100)}',
            ),
            trailing: IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite ? Colors.red : null,
              ),
              onPressed: onFavouriteToggled,
            ),
          ),
        ],
      ),
    );
  }
}
