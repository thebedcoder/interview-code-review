import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitat/src/core/di/service_locator.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:habitat/src/features/listings/presentation/widgets/listing_card.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListingsBloc>(
      create: (_) =>
          serviceLocator<ListingsBloc>()..add(const ListingsRequested()),
      child: const _ListingsView(),
    );
  }
}

class _ListingsView extends StatelessWidget {
  const _ListingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habitat')),
      body: BlocBuilder<ListingsBloc, ListingsState>(
        builder: (BuildContext context, ListingsState state) {
          return switch (state) {
            ListingsInitial() || ListingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ListingsFailure(:final AppException error) => Center(
              child: Text(error.message),
            ),
            ListingsLoaded(
              :final List<Listing> listings,
              :final Set<String> favouriteIds,
            ) =>
              ListView.builder(
                itemCount: listings.length,
                itemBuilder: (BuildContext context, int index) {
                  final Listing listing = listings[index];
                  return ListingCard(
                    key: ValueKey<String>(listing.id),
                    listing: listing,
                    isFavourite: favouriteIds.contains(listing.id),
                    onFavouriteToggled: () => context
                        .read<ListingsBloc>()
                        .add(ListingFavouriteToggled(listingId: listing.id)),
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
