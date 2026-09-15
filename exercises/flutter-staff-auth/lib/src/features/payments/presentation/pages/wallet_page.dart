import 'package:flutter/material.dart';
import 'package:kerb/src/core/di/service_locator.dart';
import 'package:kerb/src/features/payments/domain/entities/saved_card.dart';
import 'package:kerb/src/features/payments/domain/usecases/get_cards_usecase.dart';
import 'package:local_auth/local_auth.dart';

/// Wallet screen. Reached from the home screen, and from `kerb://wallet`.
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _unlocked = false;
  List<SavedCard> _cards = <SavedCard>[];

  @override
  void initState() {
    super.initState();
    _unlock();
  }

  Future<void> _unlock() async {
    final bool ok = await _localAuth.authenticate(
      localizedReason: 'Unlock your saved cards',
    );
    final List<SavedCard> cards = await serviceLocator<GetCardsUseCase>().call();
    setState(() {
      _unlocked = ok;
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: !_unlocked
          ? const Center(child: Text('Unlock to see your cards'))
          : ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (BuildContext context, int index) {
                final SavedCard card = _cards[index];
                return ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: Text('${card.brand} ····${card.last4}'),
                  subtitle: Text(
                    'Expires ${card.expiryMonth}/${card.expiryYear}',
                  ),
                );
              },
            ),
    );
  }
}
