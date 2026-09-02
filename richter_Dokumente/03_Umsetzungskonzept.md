# Umsetzungskonzept

## Projekt „Smart School Service Hub"

**Stand:** 02.09.2026 · **Version:** 0.2 · **Bezug:** [02_Pflichtenheft.md](02_Pflichtenheft.md)
**Stack:** Flutter (Client) · C# / .NET REST-API (Backend) · SQL-Datenbank

> Dieses Dokument konkretisiert die Anforderungen aus dem Pflichtenheft in Richtung
> Umsetzung: Screens, Rechte, Datenmodell und API. Alles, was nicht aus der
> Aufgabenstellung oder einer Team-Festlegung stammt, ist als **Annahme** markiert und
> in Kapitel 9 als offene Frage gelistet.

---

## 1 Begriffe

| Begriff | Bedeutung |
|---------|-----------|
| **Auftrag** | Gemeldetes Problem an einem Gerät/Raum, das bearbeitet werden muss. Entspricht der „Störmeldung" im Pflichtenheft — **es ist dasselbe**; im Code und in der Oberfläche wird durchgängig *Auftrag* verwendet. |
| **Gerät** | Alles, was in einem Raum steht und Probleme haben kann: Display, 3D-Drucker, Netzwerktechnik, Lüftung, smarte Steckdose, Sensor. |
| **Sensor** | Ein Gerät, das zusätzlich **Messwerte liefert** (Temperatur, Luftqualität, Betriebszustand). Technisch dieselbe Entität wie Gerät, nur mit Messwerten. |
| **Knoten** | Ein Element im Baum der Übersichtsseite: Gebäude, Etage, Raum oder Gerät. |

**Designentscheidung:** Gerät und Sensor werden **nicht** als getrennte Tabellen geführt,
sondern als eine Entität `Geraet` mit einem Kennzeichen `LiefertMesswerte`. Grund: beide
hängen am Raum, beide können Aufträge und Notizen haben, beide erscheinen im Baum. Das
spart eine doppelte Verwaltung und erfüllt NFA-10 (neue Gerätetypen ohne Codeänderung).

---

## 2 Rollen und Rechte

| Funktion | Lehrkraft | Hausmeister*in | Schulleitung |
|----------|:---------:|:--------------:|:------------:|
| Eigene Aufträge sehen + Status abfragen | ✅ | ✅ | ✅ |
| Neuen Auftrag anlegen | ✅ | ✅ | ✅ |
| **Alle** Aufträge einsehen | — | ✅ | ✅ |
| Aufträge bearbeiten (Status, Zuweisung) | — | ✅ | ✅ |
| Aufträge löschen | — | ✅ | ✅ |
| Übersichtsbaum ansehen | ✅ | ✅ | ✅ |
| **Aktive** Störungen eines Raums sehen | ✅ | ✅ | ✅ |
| **Fehlerhistorie** eines Raums/Geräts sehen | ❌ | ✅ | ✅ |
| Alle Sensoren + deren Werte einsehen | — | ✅ | ✅ |
| Gebäude / Etagen / Räume anlegen, bearbeiten, löschen | — | ✅ | ✅ |
| Geräte / Sensoren anlegen, bearbeiten, löschen | — | ✅ | ✅ |
| Notizen lesen | ❔ *(offen, U-2)* | ✅ | ✅ |
| Notizen schreiben | — | ✅ | ✅ |
| E-Mail bei Bearbeitung des **eigenen** Auftrags | ✅ | — | — |

Umsetzung: eine Rolle je Konto (`Lehrkraft`, `Hausmeister`, `Schulleitung`). Hausmeister*in
und Schulleitung haben laut Vorgabe **dieselben** Rechte — technisch wird trotzdem zwischen
beiden Rollen unterschieden, damit später unterschieden werden kann, ohne die Datenbank zu
ändern. Prüfung der Rechte erfolgt **im Backend**, nicht nur durch Ausblenden in der App
(NFA-04).

**Zur Trennung „aktive Störung" vs. „Historie":** Eine Lehrkraft sieht zu einem Raum die
**aktuell offenen** Störungen — das ist notwendig, damit nicht dasselbe Problem mehrfach
gemeldet wird. Die **vergangenen** Fehler (Historie) sieht sie **nicht**; die ist
Hausmeister*in und Schulleitung vorbehalten. Ausnahme: die **eigenen** Aufträge sieht eine
Lehrkraft immer, auch erledigte, inklusive Status.

---

## 3 Screens

```
Login
 ├── [Lehrkraft]        Übersicht (Baum) ──► Raumdetail (nur aktive Störungen)
 │                      Meine Aufträge   ──► Auftragsdetail (eigene, inkl. Status)
 │                      Neuer Auftrag
 │
 └── [Hausmeister*in /  Übersicht (Baum) ──► Raum-/Gerätedetail
      Schulleitung]     Alle Aufträge    ──► Auftragsdetail (bearbeiten/löschen)
                        Neuer Auftrag
                        Verwaltung ──► Gebäude / Etagen / Räume / Geräte (CRUD)
```

### 3.1 Übersichtsseite — TreeView

Hierarchie über vier Ebenen:

```
🏢 Gebäude A                                    ❗
   └── 🔺 Etage 2                               ❗
       ├── 🚪 Raum 2.14                         ❗
       │    ├── 📺 Display „Eingang"            ✅
       │    ├── 🖨️ 3D-Drucker Prusa MK4         ❗ Fehler
       │    └── 🌡️ Sensor Temperatur    22,4 °C ✅
       └── 🚪 Raum 2.15                         ✅
            └── 🌀 Lüftung Nord                 ✅
```

**Verhalten:**

- Ebenen sind **auf- und zuklappbar**; Zustand bleibt beim Navigieren erhalten.
- Blattknoten sind Geräte/Sensoren. Bei Sensoren wird der **aktuelle Messwert direkt im
  Baum** angezeigt.
- Tippen auf einen Raum oder ein Gerät öffnet die **Detailansicht** (3.2).
- Beim Start ist der Baum eingeklappt; **Knoten mit Fehler werden automatisch
  aufgeklappt**, damit ein Problem ohne Suchen sichtbar ist. *(Annahme)*

**Fehler-Markierung nach oben (Status-Vererbung):**

Der Status eines Knotens ist immer der **schlimmste Status seiner Kinder**. Ein defektes
Gerät markiert damit automatisch Raum, Etage und Gebäude.

| Status | Farbe | Bedeutung |
|--------|-------|-----------|
| `OK` | grün | keine offenen Auftraege, keine Grenzwertverletzung |
| `Warnung` | gelb | offener Auftrag niedriger/mittlerer Priorität |
| `Fehler` | rot | offener Auftrag hoher Priorität **oder** Sensorgrenzwert überschritten |

Rangfolge: `OK` < `Warnung` < `Fehler`.

> **Annahme:** Ein Gerät gilt als gestört, solange ein Auftrag dazu **nicht** den Status
> *erledigt* hat. Ob zusätzlich Sensorgrenzwerte einfließen, hängt an FA-19 und daran, ob
> echte Sensorik verfügbar ist (offener Punkt OP-1 im Pflichtenheft).

**Wichtig für die Umsetzung:** Der Status wird **nicht in der Datenbank gespeichert**,
sondern bei der Abfrage aus den offenen Aufträgen berechnet. Sonst laufen gespeicherter
und tatsächlicher Zustand auseinander. Das Backend liefert den fertig berechneten Baum in
**einem** Aufruf, damit die App nicht pro Knoten nachladen muss (NFA-07).

### 3.2 Detailansicht (Raum bzw. Gerät)

**Die Detailansicht ist rollenabhängig** — es gibt nicht zwei Screens, sondern einen
Screen, bei dem je nach Rolle Bereiche entfallen:

| Bereich | Inhalt | Lehrkraft | Hausmeister*in / Schulleitung |
|---------|--------|:---------:|:-----------------------------:|
| **Kopf** | Name, Standort (Gebäude / Etage / Raum), Gerätetyp, aktueller Status | ✅ | ✅ |
| **Aktive Störungen** | alle **offenen** Aufträge zu diesem Raum/Gerät: Gerät, Problem, Status, Meldedatum | ✅ | ✅ |
| **Aktuelle Werte** | nur bei Sensoren: letzter Messwert + Zeitpunkt, Verlauf als Diagramm *(Ausbaustufe, FA-11)* | ❌ | ✅ |
| **Historie** | **vergangene** Fehler, absteigend nach Datum: Meldedatum, meldende Person, Problem, Status, Erledigungsdatum (FA-09, FA-13) | ❌ | ✅ |
| **Notizen** | freie Notizen zum Gerät/Raum mit Verfassenden und Zeitstempel | ❔ *(offen, U-2)* | ✅ |

**Warum die aktiven Störungen für Lehrkräfte sichtbar sind:** Wer einen Raum auswählt,
sieht sofort, dass das Problem bereits gemeldet ist, und meldet es nicht ein zweites Mal.
Das ist der eigentliche Zweck dieses Bereichs — er ersetzt für die Lehrkraft **nicht** die
Historie, sondern zeigt nur den Ist-Zustand.

**Umsetzung:** Die Historie wird für Lehrkräfte **nicht an den Client geschickt und dort
ausgeblendet**, sondern das Backend liefert sie gar nicht erst aus (eigener Endpunkt, siehe
Kapitel 5). Ausgeblendete, aber übertragene Daten sind nicht geschützt.

> **Abgrenzung:** Notizen hängen am **Gerät/Raum** (dauerhaftes Wissen, z. B. „Filter sitzt
> hinter der Klappe links"), Kommentare hängen am **Auftrag** (FA-14, Verlauf einer
> Bearbeitung). Das sind zwei verschiedene Dinge.

### 3.3 Auftrag anlegen (Lehrkraft)

Ablauf in einem Formular:

1. **Raum auswählen** — Auswahl über den Baum oder Suchfeld.
2. **Bereits gemeldete Störungen anzeigen** — direkt nach der Raumauswahl blendet das
   Formular die **offenen Aufträge dieses Raums** ein, mit Gerät, Problem und Status.
   So wird sichtbar, dass ein Problem schon gemeldet ist, **bevor** es doppelt erfasst
   wird. Ist bereits ein Auftrag zum gewählten Gerät offen, wird zusätzlich ein Hinweis
   angezeigt; das Anlegen bleibt aber möglich (es kann ein zweites, anderes Problem sein).
3. **Gerät auswählen** — es werden **nur Geräte dieses Raums** angeboten. Zusätzlich
   Option „Raum allgemein / kein bestimmtes Gerät". *(Annahme)*
4. **Problem schildern** — Freitextfeld, Pflichtfeld.
5. **Priorität setzen** — die meldende Person vergibt die Priorität **beim Anlegen**
   (FA-15). Hausmeister*in und Schulleitung können sie später ändern.
6. Absenden → Auftrag erhält Status `neu`, meldende Person und Zeitpunkt werden
   automatisch gesetzt.

### 3.4 Auftragsübersicht

- **Lehrkraft:** sieht ausschließlich die **selbst gestellten** Aufträge mit deren Status.
- **Hausmeister*in / Schulleitung:** sehen **alle** Aufträge, filterbar nach Raum, Gerät,
  Status und Zeitraum (FA-07); können Status ändern, zuweisen (FA-12), bearbeiten und
  löschen.

Status-Ablauf: `neu` → `in Bearbeitung` → `erledigt` (FA-06).
Beim Löschen wird vor der Ausführung eine Rückfrage angezeigt.

Für die Lehrkraft ist der **Status** die zentrale Information: sie sieht zu jedem eigenen
Auftrag, ob er noch offen ist, gerade bearbeitet wird oder erledigt ist — ergänzt durch die
E-Mail-Benachrichtigung aus 3.6.

### 3.5 Verwaltung (Hausmeister*in / Schulleitung)

CRUD-Masken für Gebäude, Etage, Raum und Gerät/Sensor.
Regel: Ein Knoten kann nicht gelöscht werden, solange er **Unterknoten oder offene
Aufträge** hat — stattdessen Hinweis anzeigen. So bleibt der Baum konsistent.

### 3.6 E-Mail-Benachrichtigung an die meldende Person

Sobald ein Auftrag bearbeitet wird, erhält die **meldende Person** automatisch eine E-Mail.

**Auslöser:** jede **Statusänderung** des Auftrags, also `neu` → `in Bearbeitung` und
`in Bearbeitung` → `erledigt`.
*(Annahme — siehe U-9: ob auch bei Kommentar oder Zuweisung eine Mail rausgeht, ist offen.)*

**Inhalt der Mail:** Raum, Gerät, Kurzfassung des gemeldeten Problems, **neuer Status**,
Zeitpunkt der Änderung. Keine personenbezogenen Daten Dritter (NFA-05).

**Umsetzung im Backend:**

- Versand über SMTP aus dem C#-Backend; Zugangsdaten und Absenderadresse gehören in die
  Konfiguration, **nicht in den Quellcode**.
- Der Versand läuft **nachgelagert** und blockiert die API-Antwort nicht — sonst wartet
  die Hausmeisterin in der App auf den Mailserver.
- **Wichtig:** Schlägt der Mailversand fehl, darf die Statusänderung trotzdem gespeichert
  bleiben. Der Fehler wird protokolliert, nicht zurückgerollt. Andernfalls hängt die
  Auftragsbearbeitung an der Verfügbarkeit des Mailservers.
- Zum Testen ohne echten Mailserver: Versand in eine Log-Datei bzw. lokalen Test-SMTP
  umschaltbar machen.

Die E-Mail-Adresse steht bereits in `Nutzer.Email` und wird über `Auftrag.MelderId`
ermittelt. Zusätzlich ist eine Tabelle `Benachrichtigung` sinnvoll, um zu protokollieren,
welche Mail wann verschickt wurde — ohne sie ist ein fehlgeschlagener Versand nicht
nachvollziehbar.

---

## 4 Datenmodell (grob)

```
Gebaeude 1──n Etage 1──n Raum 1──n Geraet 1──n Messwert
                                      │
                                      ├──n Auftrag n──1 Nutzer (melder)
                                      │        └──n Kommentar
                                      └──n Notiz
```

| Tabelle | Wesentliche Felder |
|---------|--------------------|
| `Gebaeude` | Id, Name |
| `Etage` | Id, GebaeudeId, Bezeichnung, Ebene |
| `Raum` | Id, EtageId, Bezeichnung |
| `Geraet` | Id, RaumId, Name, Typ, LiefertMesswerte, Grenzwert_Min, Grenzwert_Max, Aktiv |
| `Messwert` | Id, GeraetId, Wert, Einheit, Zeitpunkt |
| `Auftrag` | Id, RaumId, GeraetId *(optional)*, Beschreibung, Status, Prioritaet, MelderId, ZustaendigId, ErstelltAm, ErledigtAm |
| `Notiz` | Id, GeraetId *oder* RaumId, Text, VerfasserId, ErstelltAm |
| `Kommentar` | Id, AuftragId, Text, VerfasserId, ErstelltAm |
| `Nutzer` | Id, Name, Email, PasswortHash, Rolle |
| `Benachrichtigung` | Id, AuftragId, EmpfaengerId, Anlass, VersendetAm, Erfolgreich |

Hinweise:
- `Auftrag.GeraetId` ist optional → deckt „Raum allgemein" aus 3.3 ab.
- `Messwert` wächst schnell; für den Baum wird nur der **jeweils letzte** Wert je Gerät
  geladen, nicht die gesamte Historie.
- Gelöschte Aufträge: **Soft-Delete** empfohlen, sonst verschwindet Historie (FA-09).
  *(Annahme — noch zu entscheiden)*
- `Nutzer.Email` ist für die Benachrichtigung aus 3.6 ein **Pflichtfeld**.

---

## 5 REST-API (grober Entwurf)

| Methode | Pfad | Zweck | Rolle |
|---------|------|-------|-------|
| `POST` | `/api/auth/login` | Anmeldung, liefert Token | alle |
| `GET` | `/api/tree` | kompletter Baum inkl. berechnetem Status + letztem Messwert | alle |
| `GET` | `/api/raeume/{id}` | Raumdetail inkl. Geräte | alle |
| `GET` | `/api/raeume/{id}/stoerungen` | **aktive** (offene) Aufträge des Raums — für die Doppelmeldungs-Prüfung | alle |
| `GET` | `/api/geraete/{id}` | Gerätedetail | alle |
| `GET` | `/api/geraete/{id}/historie` | **abgeschlossene** Fehler zum Gerät/Raum | Hausmeister*in, Schulleitung |
| `GET` | `/api/geraete/{id}/messwerte` | Messwerte, Zeitraum als Parameter | Hausmeister*in, Schulleitung |
| `GET` | `/api/geraete/{id}/notizen` | Notizen | Hausmeister*in, Schulleitung *(offen, U-2)* |
| `POST` | `/api/geraete/{id}/notizen` | Notiz anlegen | Hausmeister*in, Schulleitung |
| `GET` | `/api/auftraege` | Liste; für Lehrkraft **serverseitig** auf eigene gefiltert | alle |
| `POST` | `/api/auftraege` | Auftrag anlegen | alle |
| `GET` | `/api/auftraege/{id}` | Auftragsdetail | alle *(nur eigene für Lehrkraft)* |
| `PUT` | `/api/auftraege/{id}` | bearbeiten, Status ändern, zuweisen | Hausmeister*in, Schulleitung |
| `DELETE` | `/api/auftraege/{id}` | löschen | Hausmeister*in, Schulleitung |
| `GET/POST/PUT/DELETE` | `/api/gebaeude`, `/api/etagen`, `/api/raeume`, `/api/geraete` | Stammdatenverwaltung | Hausmeister*in, Schulleitung |

**Bewusst getrennte Endpunkte:** `/stoerungen` (aktiv, für alle) und `/historie`
(abgeschlossen, nur Hausmeister*in und Schulleitung) sind zwei Aufrufe statt einem
gefilterten. So kann eine Lehrkraft die Historie auch dann nicht abrufen, wenn sie den
Aufruf von Hand absetzt.

**Sicherheitsregel:** Die Einschränkungen „Lehrkraft sieht nur eigene Aufträge" und
„Lehrkraft sieht keine Historie" werden **im Backend** durchgesetzt. Die App darf sich
nicht darauf verlassen, dass sie die richtigen Daten anfragt.

---

## 6 Aufbau Flutter-Client (grob)

```
lib/
├── main.dart
├── core/          → API-Client, Auth/Token, Fehlerbehandlung, Farben/Theme
├── models/        → Gebaeude, Etage, Raum, Geraet, Auftrag, Notiz, Messwert, Nutzer
├── services/      → TreeService, AuftragService, GeraetService, AuthService
└── features/
    ├── auth/          → Login
    ├── uebersicht/    → TreeView + Statusfarben
    ├── detail/        → Raum-/Gerätedetail, rollenabhängige Bereiche
    ├── auftraege/     → Liste, Detail, Formular „neuer Auftrag"
    └── verwaltung/    → CRUD-Masken
```

Der Baum wird als rekursives Widget umgesetzt (ein `KnotenWidget`, das sich für seine
Kinder selbst aufruft) — damit funktionieren alle vier Ebenen mit demselben Code.

---

## 7 Zuordnung zu den Anforderungen

| Umsetzungspunkt | Anforderung |
|-----------------|-------------|
| TreeView Gebäude → Etage → Raum → Gerät | **neu**, erweitert FA-03 / FA-04 |
| Fehler-Markierung nach oben | **neu** |
| Fehlerhistorie in der Detailansicht (nur Hausmeister*in/Schulleitung) | FA-09, FA-13, NFA-04 |
| Notizen zu Gerät/Raum | **neu**, verwandt mit FA-14 |
| Aktive Störungen je Raum gegen Doppelmeldungen | **neu** |
| Lehrkraft: eigene Aufträge + Status | FA-05, FA-06, NFA-04 |
| Lehrkraft: Auftrag anlegen mit Raum-/Geräteauswahl | FA-02 |
| Priorität beim Anlegen setzbar | FA-15 |
| E-Mail an meldende Person bei Statusänderung | FA-16 |
| Alle Aufträge einsehen/bearbeiten/löschen | FA-05, FA-06, FA-07, FA-12 |
| Alle Sensoren + Werte einsehen | FA-10, FA-11 |
| Geräte/Sensoren CRUD | FA-04 |

> **Fünf Punkte sind im Pflichtenheft noch nicht enthalten** (TreeView, Gebäude-/Etagen-
> Ebene, Fehler-Vererbung, Notizen, Anzeige aktiver Störungen gegen Doppelmeldungen). Die
> Anforderungsliste in [02_Pflichtenheft.md](02_Pflichtenheft.md) sollte um entsprechende
> FA-Einträge ergänzt werden. Außerdem verschiebt sich **FA-16 (Benachrichtigung) von
> Priorität C auf A**, weil die E-Mail an die meldende Person jetzt fest zugesagt ist.

---

## 8 Vorgeschlagene Umsetzungsreihenfolge

| Schritt | Inhalt | Ergebnis |
|---------|--------|----------|
| 1 | Datenbank + Entitäten anlegen, Testdaten einspielen | Datenbasis steht |
| 2 | Backend: Login + Rollen | Zugriffsschutz steht |
| 3 | Backend: Stammdaten-CRUD + `/api/tree` | Baum ist abrufbar |
| 4 | Flutter: Login + TreeView ohne Status | erste sichtbare Oberfläche |
| 5 | Aufträge anlegen (inkl. Priorität) und auflisten | Kernnutzen erreicht |
| 6 | Statusberechnung + Fehler-Markierung im Baum | Hauptmerkmal der Übersicht |
| 7 | Aktive Störungen je Raum im Baum und im Auftragsformular | keine Doppelmeldungen |
| 8 | Detailansicht mit Historie und Notizen, rollenabhängig | Nachvollziehbarkeit |
| 9 | E-Mail-Versand bei Statusänderung | Rückmeldung an die Lehrkraft |
| 10 | Verwaltungsmasken | Pflege ohne Datenbankzugriff |
| 11 | Sensorwerte + Diagramme | Ausbaustufe |

---

## 9 Offene Punkte

### 9.1 Geklärt (Stand 02.09.2026)

| Nr. | Frage | Entscheidung |
|-----|-------|--------------|
| U-1 | Darf eine Lehrkraft den Übersichtsbaum sehen? | **Ja** — Lehrkräfte sehen die Baumstruktur und zu einem Raum die **aktiven** Störungen, **keine** Historie. Eigene Aufträge inkl. Status sehen sie immer. |
| U-4 | Wer setzt die Priorität? | **Die meldende Person beim Anlegen** (FA-15); Hausmeister*in und Schulleitung können sie später ändern. |

### 9.2 Noch offen

| Nr. | Frage |
|-----|-------|
| U-2 | Dürfen Lehrkräfte **Notizen** zu Raum/Gerät lesen? Da die Historie für sie gesperrt ist, liegt „nein" nahe — bitte bestätigen. |
| U-3 | Darf ein Auftrag auf einen Raum ohne konkretes Gerät gestellt werden? |
| U-5 | Ab wann ist ein Knoten „Fehler" statt „Warnung" — nur über Priorität, oder auch über Sensorgrenzwerte? |
| U-6 | Werden gelöschte Aufträge wirklich entfernt, oder nur ausgeblendet (Historie!)? |
| U-7 | Gibt es mehrere Gebäude, oder nur den Standort Beatusstraße mit mehreren Etagen? |
| U-8 | Sollen Sensorwerte simuliert oder aus echter Hardware gelesen werden (= OP-1)? |
| U-9 | E-Mail nur bei **Statusänderung**, oder auch bei Kommentar bzw. Zuweisung? |
| U-10 | Steht ein SMTP-Postfach der Schule für den Mailversand zur Verfügung? |
