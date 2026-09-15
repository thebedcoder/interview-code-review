import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitat/src/core/di/service_locator.dart';
import 'package:habitat/src/core/domain/exceptions/app_exception.dart';
import 'package:habitat/src/features/listings/domain/entities/listing.dart';
import 'package:habitat/src/features/listings/domain/entities/listing_filters.dart';
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

class _ListingsView extends StatefulWidget {
  const _ListingsView();

  @override
  State<_ListingsView> createState() => _ListingsViewState();
}

class _ListingsViewState extends State<_ListingsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _page++;
      context.read<ListingsBloc>().add(ListingsNextPageRequested(page: _page));
    }
  }

  void _onQueryChanged(String value) {
    context.read<ListingsBloc>().add(ListingsSearchChanged(query: value));
  }

  void _onBedroomsSelected(int? bedrooms) {
    final ListingsState state = context.read<ListingsBloc>().state;
    final ListingFilters current = state is ListingsLoaded
        ? state.filters
        : ListingFilters.none;
    context.read<ListingsBloc>().add(
      ListingsFiltersChanged(filters: current.copyWith(minBedrooms: bedrooms)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habitat'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onQueryChanged,
              decoration: const InputDecoration(
                hintText: 'Town, postcode or street',
                prefixIcon: Icon(Icons.search),
                filled: true,
              ),
            ),
          ),
        ),
      ),
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
              :final bool isLoadingMore,
            ) =>
              // The filter row scrolls away with the results rather than
              // staying pinned, so both live inside one scroll view.
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: <Widget>[
                    _FilterRow(onBedroomsSelected: _onBedroomsSelected),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Listing listing = listings[index];
                        return ListingCard(
                          listing: listing,
                          isFavourite: favouriteIds.contains(listing.id),
                          onFavouriteToggled: () => context
                              .read<ListingsBloc>()
                              .add(
                                ListingFavouriteToggled(listingId: listing.id),
                              ),
                        );
                      },
                    ),
                    if (isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.onBedroomsSelected});

  final ValueChanged<int?> onBedroomsSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: <Widget>[
          for (final int beds in <int>[1, 2, 3])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text('$beds+ bed'),
                onPressed: () => onBedroomsSelected(beds),
              ),
            ),
          const Spacer(),
          TextButton(
            onPressed: () => onBedroomsSelected(null),
            child: const Text('Any'),
          ),
        ],
      ),
    );
  }
}
