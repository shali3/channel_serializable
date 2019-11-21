*This example assumes you're using a recent version of the Dart or Flutter SDK.*

To use [package:channel_serializable][channel_serializable] in your package, add these
dependencies to your `pubspec.yaml`.

```yaml
dependencies:
  channel_annotation: ^0.0.1

dev_dependencies:
  build_runner: ^1.0.0
  channel_serializable: ^0.0.1
```

Annotate your code with classes defined in
[package:channel_annotation][channel_annotation].

* See [`lib/example.dart`][example] for an example of a file using these
  annotations.

* See [`lib/example.g.dart`][example_g] for the generated file.

Run `pub run build_runner build` to generate files into your source directory.

```console
> pub run build_runner build
[INFO] ensureBuildScript: Generating build script completed, took 368ms
[INFO] BuildDefinition: Reading cached asset graph completed, took 54ms
[INFO] BuildDefinition: Checking for updates since last build completed, took 663ms
[INFO] Build: Running build completed, took 10ms
[INFO] Build: Caching finalized dependency graph completed, took 44ms
[INFO] Build: Succeeded after 4687ms with 1 outputs
```

*NOTE*: If you're using Flutter, replace `pub run` with `flutter packages pub run`.

[example]: lib/example.dart
[example_g]: lib/example.g.dart
[channel_annotation]: https://pub.dev/packages/channel_annotation
[channel_serializable]: https://pub.dev/packages/channel_serializable
