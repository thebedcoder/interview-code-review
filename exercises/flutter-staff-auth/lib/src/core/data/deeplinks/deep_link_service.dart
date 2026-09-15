import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:kerb/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kerb/src/features/sessions/presentation/bloc/parking_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Routes incoming `kerb://` links.
///
/// Two shapes are handled: the OAuth callback, and the bay links printed on the
/// QR stickers at each parking bay.
class DeepLinkService {
  DeepLinkService({required this._authBloc, required this._parkingBloc})
    : _appLinks = AppLinks();

  final AuthBloc _authBloc;
  final ParkingBloc _parkingBloc;
  final AppLinks _appLinks;

  StreamSubscription<Uri>? _subscription;

  void start() {
    _subscription = _appLinks.uriLinkStream.listen(_handle);
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  void _handle(Uri uri) {
    developer.log('deep link: $uri', name: 'deeplink');
    if (uri.host == 'auth') {
      _authBloc.add(AuthCallbackReceived(callback: uri));
      return;
    }
    if (uri.host == 'bay') {
      final String bayCode = uri.pathSegments.last;
      _parkingBloc.add(ParkingStarted(bayCode: bayCode));
      return;
    }
    if (uri.host == 'wallet') {
      unawaited(
        navigatorKey.currentState?.pushNamed('/wallet') ?? Future<void>.value(),
      );
    }
  }
}
