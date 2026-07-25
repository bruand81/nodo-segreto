<p align="center">
  <img src="assets/icons/app_icon_source.png" width="120" alt="Icona Nodo Segreto" />
</p>

<h1 align="center">Nodo Segreto</h1>

<p align="center">
  App Flutter offline-first per codificare e decodificare messaggi in Morse e cifrari a sostituzione, pensata per i giochi scout del Gruppo AGESCI Avellino 1.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License: MIT" />
  <img src="https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey" alt="Piattaforme supportate" />
  <img src="https://img.shields.io/badge/offline--first-yes-forestgreen" alt="Offline-first" />
</p>

---

## Cos'è

**Nodo Segreto** è un'app multipiattaforma (mobile + desktop) per cifrare e decifrare messaggi durante i giochi scout, completamente **offline**: nessuna dipendenza di rete, nessun server, nessun dato che lascia il dispositivo.

Supporta tre cifrari richiesti più uno opzionale:

- **Morse** — variante non standard con simboli `•` / `⁃`, usata per il gioco di gruppo.
- **Cesare** — shift configurabile, alfabeto italiano (21 lettere) o inglese (26 lettere).
- **Sostituzione numerica** — chiave numerica configurabile, shift lineare o circolare.
- **Pigpen** — cifrario visuale opzionale, con glifi disegnati proceduralmente.

## Funzionalità

- **Architettura a plugin**: ogni cifrario è un modulo autonomo; il core dell'app (UI, storage, condivisione) non conosce i dettagli dei singoli cifrari.
- **Input flessibile**: digitazione manuale, importazione da file di testo o da immagine QR.
- **Output dedicato**: area di visualizzazione del risultato, con rendering personalizzato per cifrario (es. i glifi Pigpen).
- **Storage locale**: i messaggi codificati/decodificati vengono salvati su SQLite (via Drift), interamente sul dispositivo.
- **Condivisione**: esportazione su file, share sheet nativo o QR code (generazione e importazione da immagine).
- **Tema Scout**: palette verde foresta / tan corda, coerente con l'icona a nodo con motivo Morse.

## Piattaforme

Sviluppato e testato su **macOS**; build effettuate (non eseguite) per **iOS** e **Android**. Gli scaffold per **Windows** e **Linux** sono presenti ma non ancora verificati su hardware dedicato.

## Per iniziare

```bash
flutter pub get              # installa le dipendenze
flutter analyze              # analisi statica
flutter test                 # esegue la suite di test
flutter run -d macos         # avvia l'app (o -d <device-id>)
```

Dopo modifiche allo schema Drift (`lib/core/storage/drift/app_database.dart`):

```bash
dart run build_runner build --delete-conflicting-outputs
```

Dopo modifiche all'icona sorgente (`assets/icons/app_icon_source.png`):

```bash
dart run flutter_launcher_icons
```

Per i dettagli su architettura, regole di codifica e comandi completi, vedi [CLAUDE.md](CLAUDE.md).

## Credits

Sviluppato da **Andrea Bruno** ([bruand81.it](https://www.bruand81.it)) del **Gruppo Scout AGESCI Avellino 1**.

## Licenza

Distribuito con licenza [MIT](LICENSE).

## Privacy Policy

[Privacy Policy](https://bruand81.github.io/nodo-segreto/privacy-policy.html) (da linkare in App Store Connect / Google Play Console — richiede GitHub Pages abilitato su questo repo, cartella `/docs`).
