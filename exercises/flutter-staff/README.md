# FieldOps

Job management for field technicians. Technicians see the jobs assigned to them
for the day, open a job for customer and site details, and mark it complete with
notes once the work is done.

## Running

```bash
flutter pub get
flutter run
```

No code generation step - models are hand-written.

## Layout

Feature-first clean architecture. Each feature under `lib/src/features/<name>/`
owns its own layers:

```
data/         datasources, models (wire/row formats), repository implementations
domain/       entities, repository interfaces, use cases
presentation/ blocs, pages, widgets
di/           dependency registration for the feature
```

`presentation` and `data` both depend on `domain`; `domain` depends on neither.
Blocs reach data through use cases. Shared infrastructure lives in
`lib/src/core/`.

## Checks

```bash
flutter analyze
flutter test
```
