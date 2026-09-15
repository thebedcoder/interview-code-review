# Habitat

Property search. Browse listings, open one for detail, save the ones worth a
second look.

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
presentation/ blocs, pages, widgets
di/           dependency registration
```

`presentation` and `data` depend on `domain`; `domain` depends on neither.

## Checks

```bash
flutter analyze
flutter test
```
