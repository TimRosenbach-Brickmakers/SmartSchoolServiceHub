# Smart School Service Hub: Programmcode (Meilenstein 2)

Das hier ist nur der Anfang vom Programmcode. Es gibt die Projektstruktur, ein paar Skelett-Dateien und die Übersetzungsdateien. Fachlogik ist noch nicht drin. Der Stand wurde **nicht kompiliert und nicht getestet**.

## Ordnerbaum

```
Programmcode/
├── app/                        Flutter-App
│   ├── pubspec.yaml
│   ├── l10n.yaml
│   └── lib/
│       ├── main.dart
│       ├── model/              Ticket
│       ├── view/               (leer)
│       ├── controller/         TicketController
│       ├── service/            ApiClient
│       ├── state/              RoomState
│       ├── observer/           (leer)
│       ├── factory/            (leer)
│       ├── i18n/               ARB-Dateien, LocaleController
│       └── util/               (leer)
├── backend/SmartSchoolHub.Api/ C#/.NET-REST-API
│   ├── Controllers/            TicketsController
│   ├── Services/               (leer)
│   ├── Repositories/           (leer)
│   ├── Domain/                 Ticket
│   ├── Dtos/                   (leer)
│   ├── Patterns/               Observer, Factory
│   ├── Resources/              Messages*.resx
│   └── Infrastructure/         DbConnectionProvider
└── i18n/
    ├── bundles/                messages_de / messages_en (.properties)
    └── properties_to_arb.py
```

## Verantwortlichkeiten

| Ordner | Aufgabe | Name |
|---|---|---|
| app/lib/model, view, controller | MVC in der App | _(Name eintragen)_ |
| app/lib/service, util | API-Zugriff, Hilfsklassen | _(Name eintragen)_ |
| app/lib/state, observer, factory | Patterns in der App | _(Name eintragen)_ |
| backend Controllers, Services, Dtos | REST-Schnittstelle | _(Name eintragen)_ |
| backend Repositories, Domain, Infrastructure | Datenbankzugriff, Entitäten | _(Name eintragen)_ |
| backend Patterns | Observer, Factory | _(Name eintragen)_ |
| i18n, Resources | Sprachdateien | _(Name eintragen)_ |

## Patterns

- MVC: `model`, `view`, `controller` in der App, Controller und Domain im Backend
- State: `app/lib/state/room_state.dart` (Raumzustände)
- Singleton: `LocaleController`, `ApiClient`, `DbConnectionProvider`
- Observer: `Patterns/Observer/SensorEventBus.cs`
- Factory: `Patterns/Factory/DeviceFactory.cs`

## i18n

Die Quelle sind die `.properties`-Dateien in `i18n/bundles` (Schlüssel nach dem Schema `bereich.element.zweck`, z. B. `ticket.form.title`).

- Flutter: `python3 i18n/properties_to_arb.py` erzeugt daraus `app_de.arb` und `app_en.arb`. Mit `flutter gen-l10n` entsteht dann `AppLocalizations`.
- C#: Die serverseitigen Meldungen (`api.*`, `error.*`) stehen in `Resources/Messages.resx`, `Messages.de.resx` und `Messages.en.resx`. Sie sind bisher von Hand gepflegt. Die Sprache kommt über `UseRequestLocalization` aus dem Header `Accept-Language`.
- Sprachwechsel: Der `LocaleController` ist ein `ChangeNotifier`. Ohne eigene Auswahl nimmt er die Systemsprache (Fallback Deutsch). `setLocale()` ändert die Sprache zur Laufzeit, und die `MaterialApp` baut sich neu auf.

## Noch offen

- Screens in `view/`, Login, Dashboard
- Services und Repositories im Backend, Datenbankanbindung
- Observer und Factory in der App
- Tests
