# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

**Implemented.** Flutter/Dart app, scaffolded for Android, iOS, macOS, Windows and Linux. All three required ciphers (Morse, Cesare, sostituzione numerica) plus the optional Pigpen cipher are implemented and tested. Storage, sharing/QR, Scout theme, branding and the About page are done too. Windows/Linux builds have not been exercised (developed on macOS); macOS, iOS (simulator) and Android (emulator) have all been built and run successfully — verified end-to-end on 2026-07-26 while producing App Store/Play Store screenshots (workflow and gotchas logged in the local, untracked `istruzioni_store.md`). Real iOS/Android hardware has not been exercised in this environment.

`istruzioni.md` is the source of truth for requirements (in Italian); the summary below is for orientation. The "Encoding specs" section documents exact rules including some formatting details not explicit in `istruzioni.md` that were resolved with the app owner (see inline notes) — treat those as settled, not open questions.

## What ScoutCode ("Nodo Segreto") is

An offline-first, cross-platform (mobile + desktop) app for encoding/decoding messages in Morse code and substitution ciphers, for use in AGESCI Scout games (Gruppo Avellino 1). Product requirements:

- **Modular architecture**: each cipher is a self-contained plugin; the core (input, UI shell, storage, sharing) has no knowledge of which ciphers are registered.
- **Fully offline**: no network dependency. Encoded/decoded messages are saved locally on-device (SQLite via Drift).
- **App icon & splash screen**: `assets/icons/app_icon_source.png` (+ `.svg`) is a full-bleed square (green `#438226` background, yellow lock/knot/Morse glyph, no pre-baked corner rounding — platforms apply their own mask). Splash screens (`assets/splash/`) are generated only for Android and iOS via `flutter_native_splash` (config in `pubspec.yaml`), since those are the only platforms with a native splash-screen concept and the only ones the package supports; macOS/Windows/Linux just open the Flutter window directly and only get the app icon.
- **Sharing**: messages can be shared via file export, native share sheet, or QR code (generate + import from image).
- **Input methods**: manual text entry, import from a text file, or import from a QR code image.
- **UI**: Scout-themed (forest green / rope tan palette), cipher selection via dropdown, dedicated output area.
- **Branding**: app title is **"Nodo Segreto"** (chosen by the app owner among proposed alternatives). App icon is a Scout knot with a Morse dot/dash motif on one rope tail (`assets/icons/app_icon_source.png`, source SVG alongside it). About page credits "Sviluppato da Andrea Bruno (<https://www.bruand81.it>) del gruppo Avellino 1", with the Avellino 1 and bruand81 logos under `assets/branding/`.

## Comandi

- `flutter pub get` — installa le dipendenze
- `flutter analyze` — analisi statica (deve restare pulita)
- `dart format .` — formattazione (CI-equivalente: `dart format --output=none --set-exit-if-changed .`)
- `flutter test` — intera suite di test
  - singolo file: `flutter test test/plugins/morse/morse_encoder_test.dart`
  - singolo test: `flutter test --plain-name "<nome del test>"`
  - con coverage: `flutter test --coverage`
- Run: `flutter run -d macos` (o `-d <device-id>` per iOS/Android; su questa macchina Windows/Linux non sono buildabili)
- Build: `flutter build macos` / `flutter build ios --no-codesign` / `flutter build apk`
- Dopo aver modificato lo schema Drift (`lib/core/storage/drift/app_database.dart`): `dart run build_runner build --delete-conflicting-outputs`
- Dopo aver cambiato `assets/icons/app_icon_source.png`: `dart run flutter_launcher_icons` (config in `pubspec.yaml`, chiave `flutter_launcher_icons`)
- Dopo aver cambiato `assets/splash/splash_logo*.png`: `dart run flutter_native_splash:create` (config in `pubspec.yaml`, chiave `flutter_native_splash`; solo Android/iOS)
- iOS e macOS usano Swift Package Manager per i plugin nativi (niente CocoaPods: `ios/Podfile`/`macos/Podfile` sono stati rimossi, i 5 plugin nativi — `mobile_scanner`, `share_plus`, `file_selector_*`, `url_launcher_*`, `package_info_plus` — sono tutti collegati via il package locale generato da Flutter `FlutterGeneratedPluginSwiftPackage`, riferimento `XCLocalSwiftPackageReference` in `Runner.xcodeproj`). `flutter pub get`/`flutter build` rigenerano quel wiring automaticamente; non serve alcun comando CocoaPods.
- Se la build iOS/macOS fallisce con `Target Integrity: ... deployment target versions is 15.0 to ...` (iOS) o `12.0 to ...` (macOS): sono i minimi richiesti dall'Xcode installato su questa macchina, impostati direttamente in `Runner.xcodeproj` (`IPHONEOS_DEPLOYMENT_TARGET`/`MACOSX_DEPLOYMENT_TARGET`). Senza CocoaPods non esiste più un `post_install` centrale da usare come rete di sicurezza: se un plugin dichiara nel proprio `Package.swift` un minimo di piattaforma più alto di quello dell'app, l'unico rimedio è alzare il deployment target dell'app o fissare una versione precedente del plugin. Una `flutter clean` + rebuild risolve i casi di stato cache incoerente.
- I simulatori iOS 27.0 non compilano con l'Xcode 26.6 installato su questa macchina (SDK troppo recente per il toolchain); usare simulatori iOS ≤26.5 finché Xcode non viene aggiornato.

## Architettura

- **Plugin dei cifrari**: contratto in `lib/core/cipher/cipher_plugin.dart` (`CipherPlugin`, non generico di proposito). Ogni cifrario reale vive in `lib/plugins/<nome>/` (config, encoder/decoder, plugin, eventuale form di configurazione). **Unico punto da toccare per aggiungere/rimuovere un cifrario**: `lib/bootstrap/plugin_registration.dart`.
- **Stato**: Riverpod (`lib/core/cipher/providers.dart`) — `cipherRegistryProvider`, `selectedCipherIdProvider`, `cipherConfigProvider` (si resetta al `defaultConfig` quando cambia il cifrario selezionato).
- **Regola condivisa lettere accentate**: `lib/core/text_utils/accent_utils.dart` (usa il package `diacritic`), riusata da tutti i plugin — lettera base + apostrofo letterale `'`.
- **Regola condivisa sui separatori** (decisa con l'utente, non esplicita in `istruzioni.md`): un simbolo/punteggiatura tra due lettere codificate non ha separatore intorno — il simbolo si inserisce grezzo e adiacente. Il separatore (`|` in Morse, `" • "` in Cesare/numerico) vale solo tra due lettere consecutive.
- **Storage**: Drift/SQLite in `lib/core/storage/drift/` (tabella `SavedMessages`), dietro l'interfaccia `MessageRepository`. Ogni "Esegui" in `HomePage` salva un record.
- **Sharing**: export file, condivisione (share sheet) e QR condividono sempre il **testo cifrato così com'è** (l'output mostrato in UI), non un envelope — chi riceve legge/decodifica scegliendo lui stesso cifrario e configurazione nell'app (coerente con l'uso da gioco scout). `share_service.dart` (export/import file + share sheet nativo, mimetype `text/plain`), `qr_decode_service.dart` (decodifica QR da immagine via `mobile_scanner`), `qr_display_dialog.dart` (generazione QR via `pretty_qr_code`). `lib/core/sharing/share_envelope.dart` (JSON: `{app, v, cipherId, direction, config, text}`) resta solo come formato d'**importazione opzionale**: se un file/QR importato è un envelope valido, `HomePage._applyImportedContent` ripristina anche cifrario e config; altrimenti il contenuto viene trattato come testo semplice.
- **Output view personalizzata per plugin**: `CipherPlugin.buildOutputView()` ha un default (testo selezionabile) ma può essere sovrascritto — usato da `PigpenCipherPlugin` per renderizzare i glifi (`lib/plugins/pigpen/pigpen_glyph.dart` genera la tabella A-Z da regole geometriche, non da 26 costanti scritte a mano; `pigpen_glyph_painter.dart` la disegna con `CustomPainter`).
- **Tema**: `lib/app/theme/` (`ScoutTheme`, `ScoutColors`) — palette ufficiale AGESCI (Verde E/G come brand principale, Giallo oro come accento/selezioni, Viola scuro per testo/accenti secondari, Azzurro come tertiary, Rosso R/S per error/distruttivo), coerente con l'icona (verde + giallo).
- **Numero decrittazione nel cifrario numerico**: l'utente sceglie esplicitamente (campo UI, default automatico = numero della prima lettera del messaggio) quale coppia numero→lettera mostrare come chiave finale — vedi `NumericConfig.demoNumber`.

## Encoding specs (exact rules — implement precisely, don't approximate)

All three ciphers share this accented-letter rule: accented letters are treated as their unaccented base letter, encoded normally, then followed by a literal `'` (apostrophe) marker (e.g. à → a encoded, then `'`).

**Formatting rule resolved with the app owner** (not explicit in `istruzioni.md`): a non-letter symbol between two encoded letters gets **no separator around it** — it's inserted raw, adjacent to its neighbours. The separator (`|` in Morse, `" • "` in Cesare/numeric) only appears *between two consecutive letter tokens*.

### Morse (non-standard, group-specific subset)

- A-Z and 0-9 → standard Morse.
- `.` and `|` in the input text are skipped entirely (not encoded, no gap left in separators).
- All other symbols (`!?@#$%&*()-_+={}[]\/:;"'<>,` etc.) are passed through unencoded, as-is, with no separator around them.
- Letter separator: `|`. Word separator: `||` (emitted for a literal space in the input).
- Visually distinct glyphs for dot/dash: `•` for dot and `⁃` for dash.

### Caesar cipher

- Configurable shift, positive integer only; can be specified as a number (e.g. `3`) or as a mapping like `"B -> E"` (derive the shift from it) — both available in the config form.
- Shift applies only to alphabetic letters; digits and symbols are unchanged.
- Supports Italian-alphabet-only (21 letters, no J/K/W/X/Y) vs. English-alphabet (26 letters) mode.
- Encoded letters are separated by `" • "`; punctuation/symbols pass through as-is, no separator around them.
- The decryption key is appended to the end of the output message as `"E -> B"` (cipher letter → plain letter), computed from the alphabet's first letter (e.g. shift 3 on English → `"D -> A"`). Decoding auto-detects and strips this trailing key line if present, otherwise uses the config's shift/alphabet.

### Numeric substitution cipher

- User-defined numeric key: standard (A=1 … Z=26) or a shift from standard (e.g. A=3 … Z=28).
- Shift can be **circular** (wraps, e.g. A=3 → ... → Z=2) or **linear** (no wrap, e.g. A=3 → ... → Z=28).
- The decryption key is appended at the end as `"4 -> B"` — the number is **chosen explicitly by the user in the config form** (`NumericConfig.demoNumber`), defaulting automatically to the number of the first letter in the message if left blank.
- Encoded letters separated by `" • "`; punctuation/symbols pass through as-is, no separator around them.

### Pigpen cipher (implemented)

- Purely visual: `encode`/`decode` just normalize the text (uppercase + shared accent rule); the actual "cipher" is the glyph rendering done by `PigpenCipherPlugin.buildOutputView`. Glyph shapes are derived programmatically from grid position (A-I plain grid, J-R same grid + dot, S-V "X" wedges, W-Z same wedges + dot) rather than hand-authored per letter — see `lib/plugins/pigpen/pigpen_glyph.dart`.

## Cose note, non ancora fatte

- Windows e Linux non sono mai stati buildati/testati (nessuna macchina disponibile in questa sessione) — il codice non ha dipendenze note che dovrebbero romperli, ma vanno verificati quando disponibile una macchina/CI adatta.
- La scansione QR dal vivo (fotocamera) non è cablata in UI — solo l'import da immagine già scelta (`mobile_scanner.analyzeImage`), che copre Android/iOS/macOS. Su Windows/Linux `mobile_scanner` non è supportato: andrebbe aggiunto un fallback (es. `zxing2` + `image`, pure Dart) se servirà importare QR su quelle piattaforme.
