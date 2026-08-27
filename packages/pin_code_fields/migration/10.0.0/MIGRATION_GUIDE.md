# Migration Guide: pin_code_fields 9.x → 10.0.0

v10.0.0 migrates the package to Flutter 3.47's standalone design-system packages. The PIN field API is unchanged — this is an ecosystem / import migration.

See also: [What's new in Flutter 3.47](https://flutter.dev/blog/whats-new-in-flutter-3-47)

## Why this is a major version

Flutter 3.47 publishes [`material_ui`](https://pub.dev/packages/material_ui) and [`cupertino_ui`](https://pub.dev/packages/cupertino_ui) as 1.0 packages on pub.dev. The copies bundled in the Flutter SDK are scheduled for deprecation in the following stable release.

The Flutter team recommends treating ecosystem packages that switch to these libraries as a **major** release: `ThemeData`, `ColorScheme`, selection handles, and context menus now come from `material_ui` / `cupertino_ui` instead of `package:flutter/material.dart`. Mixing the two without a compatibility bridge can cause type mismatches.

## Requirements

| | v9.x | v10.0.0 |
|---|---|---|
| Dart | `^3.5.0` | `^3.12.0` |
| Flutter | `>=3.0.0` | `>=3.44.0` (tested on 3.47.1) |
| Material | `package:flutter/material.dart` | `package:material_ui/material_ui.dart` |
| Cupertino | `package:flutter/cupertino.dart` | `package:cupertino_ui/cupertino_ui.dart` |

## Step 1: Upgrade Flutter

```bash
flutter upgrade
```

`material_ui` 1.0 requires Flutter **3.44+**. Flutter **3.47** is the release that introduces the standalone packages as the recommended path.

## Step 2: Update pubspec.yaml

```yaml
dependencies:
  pin_code_fields: ^10.0.0
  material_ui: ^1.0.0
```

Then:

```bash
flutter pub get
```

`cupertino_ui` is pulled in transitively. Add it directly only if your app imports Cupertino widgets.

## Step 3: Migrate design-system imports

```bash
dart fix --apply --code=migrate_design_widgets
```

This rewrites:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
```

to:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
```

If the fix does not update `pubspec.yaml`, add the packages by hand and run the command again:

```bash
flutter pub add material_ui
# flutter pub add cupertino_ui  # only if you use Cupertino widgets
dart fix --apply --code=migrate_design_widgets
```

## Step 4: Bridge leftover SDK Material (if needed)

If **your app** has migrated but some **other packages** still import `package:flutter/material.dart`, wrap the app with `MaterialUiCompatibilityBridge`:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MaterialUiCompatibilityBridge(child: child!);
      },
      home: Scaffold(
        body: MaterialPinField(
          length: 6,
          onCompleted: (pin) {},
        ),
      ),
    );
  }
}
```

You can also wrap a single subtree that still uses a legacy package.

## Localizations

If you set `localizationsDelegates` from `package:flutter_localizations`, switch to the delegates from `material_ui`:

```dart
import 'package:material_ui/material_ui.dart';

MaterialApp(
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  // ...
)
```

`GlobalMaterialLocalizations.delegates` now includes the Cupertino and Widgets delegates as well.

## What did not change

`MaterialPinField`, `PinInput`, `PinInputController`, `MaterialPinTheme`, and the rest of the public PIN API are the same as in 9.x. No widget or parameter renames in this release.

## Troubleshooting

**Theme / type errors involving `ThemeData` or `ThemeExtension`**
You are mixing SDK Material with `material_ui`. Migrate the import or add `MaterialUiCompatibilityBridge`.

**Analyzer: `depend_on_referenced_packages` for `material_ui`**
Declare `material_ui` in your own `pubspec.yaml` even though `pin_code_fields` already depends on it.

**Still on Flutter < 3.44**
Stay on `pin_code_fields` 9.x until you can upgrade.
