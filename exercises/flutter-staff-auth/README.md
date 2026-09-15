# Kerb

Pay for parking by the minute. Sign in, start a session in a bay, stop it when
you leave and the server prices it from the bay's tariff.

## Running

```bash
flutter pub get
flutter run
```

## Layout

Feature-first clean architecture under `lib/src/features/<name>/`:

```
data/         datasources, models, repository implementations
domain/       entities, repository interfaces, use cases
presentation/ blocs, pages
di/           dependency registration
```

`presentation` and `data` depend on `domain`; `domain` depends on neither.

## Checks

```bash
flutter analyze
flutter test
```
