# Umsetzungskonzept

## Projekt „Smart School Service Hub"

**Stand:** 30.09.2026 · **Version:** 0.4 · **Bezug:** [02_Pflichtenheft.md](02_Pflichtenheft.md)
**Stack:** Vue als PWA (Frontend) · C# / .NET REST-API · MySQL · MQTT

> Dieses Dokument konkretisiert die Anforderungen aus dem Pflichtenheft in Richtung
> Umsetzung: Architektur, Screens, Rechte, Datenmodell, MQTT und API. Alles, was nicht aus
> der Aufgabenstellung oder einer Team-Festlegung stammt, ist als **Annahme** markiert und
> in Kapitel 15 als offene Frage gelistet.

**Änderungen gegenüber Version 0.2:** Frontend von Flutter auf **Vue** gewechselt,
Datenbank auf **MySQL** konkretisiert, **MQTT** als Datenquelle ergänzt sowie Dashboard,
Wartung, Warnungen, JSON-Export, Dummy-Daten und die Schnittstelle zur Daten- und
Prozessanalyse aufgenommen.

**Änderungen gegenüber Version 0.3 (Klärung mit der auftraggebenden Lehrkraft):**
Rollen auf **Lehrkraft, Hausmeister*in, Schulleitung und Admin** festgelegt; Lehrkräfte
stellen nur Aufträge und sehen **keine Sensorwerte**, dafür die bisherigen Aufträge des
Raums. Einzige Geräteart ist die **digitale Tafel**, dazu Sensoren inkl. **Lichtsensor**,
sonst „Sonstiges". Auslieferung als **PWA mit Push** plus E-Mail. Einfache eigene
Anmeldung statt M365. „Auswerten" heißt **Statistiken** (neues Kapitel 5.10). Reale
Sensordaten und KI-erzeugte Mock-Daten sind beide zulässig.

---

## 1 Begriffe

| Begriff | Bedeutung |
|---------|-----------|
| **Auftrag** | Vorgang, der bearbeitet werden muss. Zwei Arten: **Störung** (von einer Person gemeldet) und **Wartung** (geplante Tätigkeit). Entspricht der „Störmeldung" im Pflichtenheft. |
| **Warnung** | **Automatisch** vom System erzeugter Hinweis aus Sensordaten oder Regeln, z. B. „CO₂ zu hoch". Wird von niemandem gemeldet und verschwindet wieder, wenn der Zustand endet. |
| **Gerät** | Alles, was in einem Raum erfasst wird und Probleme haben kann. Es gibt genau zwei Arten: die **digitale Tafel** und **Sensoren**. Jedes Gerät gehört zu genau einem Raum — Sensoren außerhalb von Räumen gibt es nicht. |
| **Sensor** | Ein Gerät, das **Messwerte liefert**: Temperatur, CO₂, Luftfeuchte oder Licht. Licht wird **nur gemessen**, nicht als Gerät geführt oder geschaltet. |
| **Sonstiges** | Problem im Raum, das weder die Tafel noch einen Sensor betrifft (z. B. Fenster klemmt). Wird als Auftrag ohne Gerät mit Beschreibung erfasst. |
| **Knoten** | Element im Baum der Übersichtsseite: Gebäude, Etage, Raum oder Gerät. |

**Designentscheidung 1 — Gerät und Sensor sind eine Entität.** Nicht zwei Tabellen,
sondern `Geraet` mit dem Kennzeichen `LiefertMesswerte`. Beide hängen am Raum, beide können
Aufträge und Notizen haben, beide erscheinen im Baum.

**Designentscheidung 2 — Warnung und Auftrag sind getrennt.** Eine Warnung entsteht
automatisch und löst sich automatisch auf (Fenster geöffnet → CO₂ sinkt → Warnung weg).
Ein Auftrag braucht immer einen Menschen, der ihn abschließt. Beides in eine Tabelle zu
werfen führt dazu, dass entweder Warnungen ewig offen stehen oder echte Störungen
stillschweigend verschwinden. Aus einer Warnung **kann** per Klick ein Auftrag erzeugt
werden.

**Designentscheidung 3 — Störung und Wartung sind eine Tabelle** mit dem Feld `Typ`.
Beide haben Raum, Gerät, Status, Priorität, zuständige Person und denselben Ablauf. Eine
zweite Tabelle würde die halbe Logik verdoppeln.

---

## 2 Technischer Aufbau

```
   Sensoren / Tafeln (real, simuliert oder KI-Mock)
                │  MQTT publish
                ▼
        MQTT-Broker (z. B. Mosquitto)
                │  subscribe
                ▼
 ┌──────────────────────────────────────┐
 │  Backend — C# / .NET                  │
 │   ├─ MQTT-Worker (Hintergrunddienst)  │
 │   ├─ Regelprüfung → Warnungen         │
 │   ├─ REST-API (JSON)                  │
 │   └─ E-Mail- + Web-Push-Versand       │
 └──────────────┬───────────────────────┘
                │  Entity Framework Core
                ▼
          MySQL-Datenbank
                ▲
                │  REST / JSON
 ┌──────────────┴───────────────────────┐        ┌──────────────────────────┐
 │  Frontend — Vue als PWA               │        │ Daten- & Prozessanalyse  │
 └──────────────────────────────────────┘        │ (zweite Fachrichtung)    │
                                                  └───────────▲──────────────┘
                                        JSON-/CSV-Export, Analyse-Endpunkte
```

| Ebene | Technologie |
|-------|-------------|
| Frontend | **Vue** als **PWA** (Service Worker, Web Push, installierbar), Kommunikation ausschließlich über die REST-API |
| Backend | **C# / .NET**, REST-API mit JSON, MQTT-Client als Hintergrunddienst |
| Datenbank | **MySQL**, Zugriff über Entity Framework Core |
| Sensordaten | **MQTT** (Broker z. B. Mosquitto); reale Daten (Ansprechpartner Herr Hahn) und/oder Simulation/KI-Mock |
| Anmeldung | eigene, einfache Anmeldung (E-Mail + Passwort, Token) — **kein** M365 |

**Wichtig:** Das Frontend spricht **nicht** direkt mit dem MQTT-Broker. Sonst müsste jede
Browser-Sitzung eigene Broker-Verbindungen aufbauen, Regeln doppelt auswerten und hätte
Zugangsdaten des Brokers im Auslieferungspaket. Alle Daten laufen über das Backend.

---

## 3 Rollen und Rechte

Die Rollen sind mit der auftraggebenden Lehrkraft geklärt: **nur Lehrkraft,
Hausmeister*in, Schulleitung und Admin**. Schüler*innen melden nichts, eine IT-Rolle gibt
es nicht.

| Rolle | Vorgabe | Kurz |
|-------|---------|------|
| Lehrkraft | „nur stellen" | legt Aufträge an, sieht eigene Aufträge und die bisherigen Aufträge des Raums |
| Hausmeister*in | „lesen und schreiben" | bearbeitet Aufträge, Wartung, Warnungen, Notizen, Stammdaten |
| Admin | „alles" | wie Hausmeister*in, zusätzlich Nutzerverwaltung und Löschen |
| Schulleitung | „freiwillig" — legt das Team fest | **Vorschlag:** nur lesen (Dashboard, Statistiken, alle Aufträge) |

| Funktion | Lehrkraft | Hausmeister*in | Admin | Schulleitung *(Vorschlag)* |
|----------|:---------:|:--------------:|:-----:|:------------:|
| Neuen Auftrag anlegen | ✅ | ✅ | ✅ | — |
| Eigene Aufträge sehen + Status abfragen | ✅ | ✅ | ✅ | — |
| Aufträge des gewählten Raums sehen (offen **und** erledigt) | ✅ | ✅ | ✅ | ✅ |
| **Alle** Aufträge einsehen | — | ✅ | ✅ | ✅ |
| Aufträge bearbeiten (Status, Zuweisung, Priorität) | — | ✅ | ✅ | — |
| Aufträge löschen | — | — | ✅ | — |
| Übersichtsbaum ansehen | ✅ *(ohne Messwerte)* | ✅ | ✅ | ✅ |
| Dashboard ansehen | — | ✅ | ✅ | ✅ |
| Statistiken ansehen | — | ✅ | ✅ | ✅ |
| Sensorwerte + Verläufe einsehen | ❌ | ✅ | ✅ | ✅ |
| Warnungen einsehen | ❌ | ✅ | ✅ | ✅ |
| Warnungen quittieren | — | ✅ | ✅ | — |
| Wartungsaufgaben anlegen und bearbeiten | — | ✅ | ✅ | — |
| Gebäude / Etagen / Räume / Geräte anlegen, bearbeiten | — | ✅ | ✅ | — |
| Gebäude / Etagen / Räume / Geräte löschen | — | — | ✅ | — |
| Notizen lesen | ❌ | ✅ | ✅ | ✅ |
| Notizen schreiben | — | ✅ | ✅ | — |
| Nutzende anlegen, sperren, Rolle zuweisen | — | — | ✅ | — |
| JSON-Export | — | ✅ | ✅ | ✅ |
| E-Mail bei Bearbeitung des **eigenen** Auftrags | ✅ | ✅ | ✅ | — |
| Push bei neuer Störung / Warnung | — | ✅ | ✅ *(optional)* | — |

Umsetzung: eine Rolle je Konto (`Lehrkraft`, `Hausmeister`, `Admin`, `Schulleitung`). Die
Schulleitung wird technisch als eigene Rolle geführt, auch wenn sie anfangs nur lesen darf
— so lässt sich ihr Recht später ändern, ohne die Datenbank anzufassen. Prüfung der Rechte
erfolgt **im Backend**, nicht nur durch Ausblenden im Frontend (NFA-04).

**Löschen nur für Admin:** „Hausmeister*in lesen und schreiben" wird als *anlegen und
bearbeiten* verstanden. Endgültiges Löschen bleibt beim Admin, damit keine Historie für
Statistik und Datenanalyse verloren geht. *(Annahme — siehe U-18.)*

**Was die Lehrkraft sieht:** Laut Vorgabe sieht eine Lehrkraft **nur die bisherigen
Aufträge des Raums** — offene und erledigte — und ihre eigenen Aufträge mit Status. Das
verhindert Doppelmeldungen und zeigt, ob ein Problem schon öfter aufgetreten ist.
**Nicht** sichtbar sind Sensorwerte (z. B. Temperatur), Warnungen, Notizen und Wartungen.

---

## 4 Screens — Überblick

```
Login
 ├── [Lehrkraft]        Meine Aufträge   ──► Auftragsdetail (eigene, inkl. Status)
 │                      Neuer Auftrag    (Startseite)
 │                      Übersicht (Baum, ohne Messwerte) ──► Raum: Aufträge des Raums
 │
 ├── [Hausmeister*in]   Dashboard
 │                      Übersicht (Baum) ──► Raum-/Gerätedetail
 │                      Alle Aufträge    ──► Auftragsdetail (bearbeiten)
 │                      Wartung
 │                      Warnungen
 │                      Statistiken
 │                      Verwaltung ──► Gebäude / Etagen / Räume / Geräte
 │                      Export
 │
 ├── [Admin]            wie Hausmeister*in + Nutzerverwaltung + Löschen
 │
 └── [Schulleitung]     Dashboard, Übersicht, Alle Aufträge, Statistiken (nur lesen)
```

Da die Anwendung als **PWA** läuft, sind alle Screens auch auf dem Smartphone nutzbar —
wichtig für die Hausmeister*in, die unterwegs im Gebäude Aufträge abarbeitet.

---

## 5 Screens im Detail

### 5.1 Dashboard

Das Dashboard ist laut Mindestanforderungen Pflicht (FA-28). Es zeigt den Zustand der
Schule auf einen Blick, **ohne dass man erst navigieren muss**.

**Aufbau — Kennzahlenzeile oben:**

| Kachel | Inhalt | Quelle |
|--------|--------|--------|
| Offene Störungen | Anzahl Aufträge mit Status ≠ erledigt | `Auftrag` |
| Kritische Räume | Räume mit Status `Fehler` | berechnet (6.2) |
| Geräte online | z. B. „114 / 128" + Prozent | Online-Erkennung (7.3) |
| CO₂ Ø alle Räume | Mittelwert der letzten Messwerte | `Messwert` |
| Licht an nach Unterrichtsende | Räume mit Lichtwert über Schwelle außerhalb der Unterrichtszeit | `Messwert` |
| Erledigte Störungen heute | Anzahl heute abgeschlossen | `Auftrag` |

**Darunter:**

- **Aktuelle Warnungen** — Liste der offenen Warnungen mit Raum, Gerät, Auslöser und
  „seit X Minuten"
- **Letzte Störungen** — die zuletzt gemeldeten Aufträge mit Uhrzeit und Priorität
- **Gerätestatus** — Verteilung online / offline / Wartung als Ring- oder Balkendiagramm
- **Störungen nach Priorität** — Verteilung der offenen Aufträge
- **Raumklima** — Tabelle der Räume mit Temperatur, CO₂, Luftfeuchte, Licht und Ampelstatus
- **CO₂-Verlauf** — Liniendiagramm der letzten Stunde für ausgewählte Räume
- **Fußzeile** — Status des MQTT-Brokers und Zeitpunkt der letzten Datenaktualisierung

**Lehrkräfte sehen kein Dashboard** — es enthält Sensorwerte und Warnungen, die laut
Vorgabe nicht für Lehrkräfte gedacht sind. Ihre Startseite ist „Neuer Auftrag" bzw.
„Meine Aufträge".

**Aktualisierung:** Das Dashboard lädt seine Daten alle 30 Sekunden neu (einfaches Polling
über die REST-API) und zeigt den Zeitpunkt der letzten Aktualisierung an. Server-Sent
Events oder WebSockets wären eleganter, sind aber **Ausbaustufe** — Polling ist mit
Bordmitteln in einer Stunde erledigt und für einen Schul-Dashboard-Takt völlig
ausreichend.

> **Hinweis zum Aufwand:** Ein Dashboard mit vielen Diagrammen sieht beeindruckend aus,
> kostet aber viel Zeit. Empfehlung: zuerst die **Kennzahlenzeile, Warnungen und letzte
> Störungen** bauen — die sind billig und sofort nützlich. Diagramme und Verläufe danach.
> Die Aufgabenstellung sagt ausdrücklich, dass nicht die Optik zählt, sondern ob die
> Information für die Benutzergruppe **verständlich und nützlich** ist (NFA-13).

### 5.2 Übersichtsseite — TreeView

Hierarchie über vier Ebenen:

```
🏢 Gebäude A                                    ❗
   └── 🔺 Etage 2                               ❗
       ├── 🚪 Raum 2.14                         ❗
       │    ├── 📺 Digitale Tafel               ❗ Fehler
       │    ├── 🌡️ Sensor Temperatur    22,4 °C ✅
       │    ├── 🫧 Sensor CO₂          980 ppm ✅
       │    └── 💡 Sensor Licht         420 lx  ✅
       └── 🚪 Raum 2.15                         ✅
            └── 📺 Digitale Tafel               ✅
```

**Verhalten:**

- Ebenen sind auf- und zuklappbar; der Zustand bleibt beim Navigieren erhalten.
- Blattknoten sind Tafel und Sensoren. Bei Sensoren wird der **aktuelle Messwert direkt im
  Baum** angezeigt — **nicht für Lehrkräfte**: Das Backend liefert ihnen den Baum ohne
  Messwerte aus.
- Klick auf Raum oder Gerät öffnet die **Detailansicht** (5.3).
- Beim Start ist der Baum eingeklappt; **Knoten mit Fehler werden automatisch
  aufgeklappt**. *(Annahme)*

**Status-Vererbung nach oben:** Der Status eines Knotens ist der **schlimmste Status seiner
Kinder**. Ein defektes Gerät markiert damit automatisch Raum, Etage und Gebäude.

| Status | Farbe | Bedeutung |
|--------|-------|-----------|
| `OK` | grün | keine offenen Aufträge, keine aktive Warnung |
| `Warnung` | gelb | offener Auftrag niedriger/mittlerer Priorität **oder** aktive Warnung |
| `Fehler` | rot | offener Auftrag hoher Priorität **oder** Gerät offline |

Rangfolge: `OK` < `Warnung` < `Fehler`.

**Der Status wird nicht in der Datenbank gespeichert**, sondern bei der Abfrage aus
offenen Aufträgen und aktiven Warnungen berechnet. Sonst laufen gespeicherter und
tatsächlicher Zustand auseinander. Das Backend liefert den fertig berechneten Baum in
**einem** Aufruf, damit das Frontend nicht pro Knoten nachladen muss (NFA-07).

### 5.3 Detailansicht (Raum bzw. Gerät)

**Rollenabhängig** — ein Screen, bei dem je nach Rolle Bereiche entfallen:

| Bereich | Inhalt | Lehrkraft | Hausmeister*in / Admin | Schulleitung |
|---------|--------|:---------:|:----------------------:|:------------:|
| **Kopf** | Name, Standort, Gerätetyp, aktueller Status | ✅ *(ohne online/offline)* | ✅ | ✅ |
| **Aufträge des Raums** | offene **und** erledigte Aufträge: Gerät, Problem, Status, Meldedatum | ✅ | ✅ | ✅ |
| **Aktuelle Werte** | nur bei Sensoren: letzter Messwert + Zeitpunkt, Verlauf als Diagramm | ❌ | ✅ | ✅ |
| **Warnungen** | aktive Warnungen zu diesem Raum/Gerät | ❌ | ✅ | ✅ |
| **Wartung** | erledigte und geplante Wartungen an der Tafel | ❌ | ✅ | ✅ |
| **Notizen** | freie Notizen mit Verfassenden und Zeitstempel | ❌ | ✅ | ✅ |

Die **Raumdetailansicht** ist ausdrückliche Mindestanforderung der Aufgabenstellung.

**Umsetzung:** Sensorwerte, Warnungen und Notizen werden für Lehrkräfte **nicht
mitgeschickt und im Frontend ausgeblendet**, sondern vom Backend gar nicht erst
ausgeliefert (eigene Endpunkte, siehe Kapitel 9). Ausgeblendete, aber übertragene Daten
sind nicht geschützt.

> **Abgrenzung:** Notizen hängen am **Gerät/Raum** (dauerhaftes Wissen, z. B. „Tafel-Stift
> liegt im Lehrerpult"), Kommentare hängen am **Auftrag** (FA-14, Verlauf einer
> Bearbeitung). Zwei verschiedene Dinge.

### 5.4 Auftrag anlegen

1. **Raum auswählen** — über den Baum oder ein Suchfeld.
2. **Bereits gemeldete Störungen anzeigen** — direkt nach der Raumauswahl blendet das
   Formular die **offenen Aufträge dieses Raums** ein (Gerät, Problem, Status). Ist zum
   gewählten Gerät bereits etwas offen, erscheint zusätzlich ein Hinweis; das Anlegen
   bleibt möglich, es könnte ein zweites Problem sein (FA-24).
3. **Gerät auswählen** — die Tafel oder ein Sensor dieses Raums, oder **„Sonstiges"**
   (kein Gerät, z. B. Fenster, Möbel). Bei „Sonstiges" ist die Beschreibung besonders
   wichtig, weil sie das Einzige ist, was das Problem einordnet.
4. **Problem schildern** — Freitext, Pflichtfeld.
5. **Priorität setzen** — die meldende Person vergibt die Priorität beim Anlegen (FA-15);
   Hausmeister*in und Admin können sie später ändern.
6. Absenden → Status `neu`, meldende Person und Zeitpunkt werden automatisch gesetzt.

### 5.5 Auftragsübersicht

- **Lehrkraft:** sieht in „Meine Aufträge" die **selbst gestellten** Aufträge mit Status;
  über den Raum zusätzlich alle Aufträge dieses Raums (nur lesen).
- **Hausmeister*in / Admin:** sehen **alle** Aufträge, filterbar nach Raum, Gerät,
  Status, Typ und Zeitraum (FA-07); können Status ändern, zuweisen (FA-12) und bearbeiten.
  Löschen nur Admin.
- **Schulleitung:** sieht alle Aufträge, nur lesend *(Vorschlag)*.

Status-Ablauf: `neu` → `in Bearbeitung` → `erledigt` (FA-06).
Ergänzend vorgeschlagen: `zurückgestellt` (z. B. Ersatzteil fehlt) und `abgelehnt` (kein
Fehler feststellbar). *(Annahme — siehe U-12.)*
Beim Löschen wird vor der Ausführung eine Rückfrage angezeigt.

### 5.6 Wartung

Wartungsaufgaben sind Aufträge vom Typ `Wartung` (FA-30):

- werden **geplant** angelegt (nicht gemeldet), mit Fälligkeitsdatum
- durchlaufen denselben Status-Ablauf wie Störungen
- werden am Gerät dokumentiert und erscheinen in dessen Historie
- eine Liste „fällige Wartungen" zeigt, was in den nächsten Tagen ansteht

Wiederkehrende Wartungen (z. B. „Filter alle 90 Tage") bleiben Ausbaustufe (FA-21).

### 5.7 Warnungen

Übersicht aller automatisch erzeugten Warnungen mit Raum, Gerät, Auslöser, Beginn und
Dauer. Möglich sind: **quittieren** (Warnung als gesehen markieren) und **in einen Auftrag
überführen**, wenn ein Mensch tätig werden muss.

### 5.8 Verwaltung

CRUD-Masken für Gebäude, Etage, Raum und Gerät (Tafel/Sensor). Beim Gerät zusätzlich:
MQTT-Topic, Gerätetyp, Grenzwerte. Nur für Admin zusätzlich: **Nutzerverwaltung**
(anlegen, sperren, Rolle zuweisen, Passwort zurücksetzen; FA-36).

Regel: Ein Knoten kann nicht gelöscht werden, solange er **Unterknoten oder offene
Aufträge** hat — stattdessen Hinweis anzeigen. So bleibt der Baum konsistent.

### 5.9 Benachrichtigungen: E-Mail und Push

Vorgabe der auftraggebenden Lehrkraft: **PWA mit Push, zusätzlich E-Mail.**

| Anlass | Empfänger | Kanal |
|--------|-----------|-------|
| Status des eigenen Auftrags ändert sich | meldende Person | **E-Mail** (FA-16) + Push, falls abonniert |
| Neue Störung gemeldet | Hausmeister*in | **Push** (FA-34) + E-Mail |
| Neue Warnung (z. B. CO₂, Tafel offline) | Hausmeister*in | **Push** (FA-34) |

**Web Push (PWA):** Beim ersten Start fragt die App, ob Benachrichtigungen erlaubt sind.
Das Abo (Endpoint + Schlüssel) wird im Backend gespeichert (`PushAbo`). Der Versand läuft
über das Web-Push-Protokoll mit VAPID-Schlüsseln (in .NET z. B. über die Bibliothek
`WebPush`) — kostenlos, ohne Drittanbieter-Konto.

> **Einschränkung iOS:** Auf iPhones funktioniert Web Push nur, wenn die PWA zum
> Home-Bildschirm hinzugefügt wurde (ab iOS 16.4). Deshalb bleibt **E-Mail der
> verlässliche Kanal**, Push ist die schnelle Ergänzung.

**E-Mail an die meldende Person:**

**Auslöser:** jede **Statusänderung**, also `neu` → `in Bearbeitung` und
`in Bearbeitung` → `erledigt`. *(Annahme — siehe U-9.)*

**Inhalt:** Raum, Gerät, Kurzfassung des Problems, neuer Status, Zeitpunkt. Keine
personenbezogenen Daten Dritter (NFA-05).

**Umsetzung im Backend:**

- Versand über SMTP; Zugangsdaten und Absenderadresse in die Konfiguration, **nicht in den
  Quellcode**.
- Der Versand läuft **nachgelagert** und blockiert die API-Antwort nicht — sonst wartet die
  Hausmeisterin in der Oberfläche auf den Mailserver.
- **Schlägt der Versand fehl, bleibt die Statusänderung trotzdem gespeichert.** Der Fehler
  wird protokolliert, nicht zurückgerollt. Sonst hängt die Auftragsbearbeitung an der
  Verfügbarkeit des Mailservers.
- Zum Testen ohne echten Mailserver: Versand in eine Log-Datei bzw. lokalen Test-SMTP
  umschaltbar machen. Die Aufgabenstellung lässt eine **simulierte** E-Mail ausdrücklich zu.

### 5.10 Statistiken

„Daten auswerten" heißt laut auftraggebender Lehrkraft **Statistiken** (FA-13). Sichtbar
für Hausmeister*in, Admin und Schulleitung.

| Statistik | Darstellung |
|-----------|-------------|
| Störungen je Raum (Top 10) | Balkendiagramm |
| Störungen je Geräteart (Tafel / Sensor / Sonstiges) | Balken- oder Ringdiagramm |
| Störungen im Zeitverlauf (pro Woche) | Liniendiagramm |
| Ø Bearbeitungsdauer (gemeldet → erledigt) | Kennzahl + Verlauf |
| Offene vs. erledigte Aufträge | Kennzahl |
| Räume mit häufigster CO₂-Überschreitung | Tabelle |
| Offline-Zeiten der Tafeln | Tabelle |

Filter: Zeitraum, Gebäude/Etage. Die Berechnung erfolgt im Backend
(`GET /api/statistiken`), das Frontend zeichnet nur. Tiefere Analysen und Machine Learning
bleiben Aufgabe der Daten- und Prozessanalyse (Kapitel 12).

---

## 6 MQTT-Konzept

### 6.1 Topic-Struktur

```
schule/{gebaeude}/{etage}/{raum}/{geraet}/{groesse}
```

Beispiele:

```
schule/a/2/214/sensor-12/co2          → {"wert":980,"einheit":"ppm","zeitpunkt":"2026-06-22T11:03:00Z"}
schule/a/2/214/sensor-12/temperatur   → {"wert":23.1,"einheit":"C","zeitpunkt":"..."}
schule/a/2/214/sensor-13/licht        → {"wert":420,"einheit":"lx","zeitpunkt":"..."}
schule/a/2/214/tafel-1/status         → {"status":"online","eingeschaltet":true}
```

Nutzdaten immer als **JSON** (Vorgabe der Aufgabenstellung). Die Topic-Struktur und die
Nutzdaten werden dokumentiert (NFA-11) — das ist zugleich Projektergebnis.

### 6.2 Verarbeitung im Backend

Ein **Hintergrunddienst** (`BackgroundService` in .NET) abonniert die Topics, und für jede
eingehende Nachricht gilt:

1. Nachricht dem Gerät zuordnen (über das Topic bzw. eine hinterlegte Gerätezuordnung)
2. Messwert in die Datenbank schreiben
3. **Regeln prüfen** (Kapitel 7) und ggf. eine Warnung erzeugen oder auflösen

Unbekannte Topics werden protokolliert, aber nicht verworfen — so fällt auf, wenn ein Gerät
falsch konfiguriert ist.

### 6.3 Offline-Erkennung

Zwei Wege, die sich ergänzen:

- **Last Will and Testament (LWT):** Das Gerät hinterlegt beim Verbinden eine Nachricht,
  die der Broker automatisch sendet, wenn die Verbindung abreißt. Damit wird ein Ausfall
  sofort gemeldet, statt auf einen Timeout zu warten.
- **Timeout:** Kam von einem Gerät seit X Minuten kein Wert, gilt es als offline.

Der Online-Status wird **nicht als Feld gepflegt**, sondern aus dem Zeitpunkt der letzten
Nachricht abgeleitet. Ein gespeichertes Flag wäre nach einem Backend-Neustart falsch.

---

## 7 Regeln und Warnungen

Die Regelprüfung läuft im Backend — teils bei jeder eingehenden MQTT-Nachricht, teils
zeitgesteuert.

| Regel | Auslöser | Prüfung |
|-------|----------|---------|
| CO₂ zu hoch | Messwert > Grenzwert des Raums | bei jeder Nachricht |
| Temperatur außerhalb des Bereichs | Messwert außerhalb Min/Max | bei jeder Nachricht |
| Gerät offline | keine Nachricht seit X Minuten | zeitgesteuert, z. B. minütlich |
| Tafel nach Unterrichtsende noch an | Status „eingeschaltet" nach definierter Uhrzeit | zeitgesteuert |
| Licht nach Unterrichtsende noch an | Lichtsensor über Schwellwert nach definierter Uhrzeit | zeitgesteuert |
| Störung zu lange offen | Auftrag seit mehr als X Tagen nicht erledigt | zeitgesteuert, täglich |

**Warnungen lösen sich selbst auf:** Sinkt der CO₂-Wert wieder unter den Grenzwert, wird
die Warnung automatisch beendet (`BeendetAm` gesetzt) statt gelöscht. So bleibt für die
Daten- und Prozessanalyse auswertbar, wie oft und wie lange ein Raum kritisch war.

**Entprellung:** Eine Regel darf nicht bei jedem Messwert eine neue Warnung erzeugen —
sonst entstehen bei 10-Sekunden-Takt hunderte Einträge pro Stunde. Solange eine Warnung
desselben Typs für dasselbe Gerät aktiv ist, wird **keine zweite** angelegt.

---

## 8 Datenmodell (grob)

```
Gebaeude 1──n Etage 1──n Raum 1──n Geraet 1──n Messwert   (Geraet.Typ: Tafel | Sensor)
                           │          │
                           │          ├──n Warnung
                           │          ├──n Notiz
                           │          └──n Auftrag ──n Kommentar
                           └──────────────────┘        │
                                                  n──1 Nutzer
```

| Tabelle | Wesentliche Felder |
|---------|--------------------|
| `Gebaeude` | Id, Name |
| `Etage` | Id, GebaeudeId, Bezeichnung, Ebene |
| `Raum` | Id, EtageId, Bezeichnung |
| `Geraet` | Id, RaumId *(Pflicht)*, Name, Typ (`Tafel`/`Sensor`), Messgroesse (`Temperatur`/`CO2`/`Luftfeuchte`/`Licht`, nur bei Sensor), MqttTopic, Grenzwert_Min, Grenzwert_Max, Aktiv |
| `Messwert` | Id, GeraetId, Groesse, Wert, Einheit, Zeitpunkt |
| `Auftrag` | Id, **Typ** (Störung/Wartung), RaumId, GeraetId *(optional)*, Beschreibung, Status, Prioritaet, MelderId, ZustaendigId, ErstelltAm, FaelligAm, ErledigtAm |
| `Warnung` | Id, GeraetId, RaumId, Regel, Meldung, BegonnenAm, BeendetAm, QuittiertVon |
| `Notiz` | Id, GeraetId *oder* RaumId, Text, VerfasserId, ErstelltAm |
| `Kommentar` | Id, AuftragId, Text, VerfasserId, ErstelltAm |
| `Nutzer` | Id, Name, Email, PasswortHash, Rolle (`Lehrkraft`/`Hausmeister`/`Admin`/`Schulleitung`), Aktiv |
| `PushAbo` | Id, NutzerId, Endpoint, P256dh, Auth, ErstelltAm |
| `Benachrichtigung` | Id, AuftragId, EmpfaengerId, Kanal (`Email`/`Push`), Anlass, VersendetAm, Erfolgreich |

Hinweise zur Umsetzung:

- `Auftrag.GeraetId` ist optional → leer bedeutet **„Sonstiges"** (Problem im Raum ohne Gerät).
- `Nutzer.Email` ist für Anmeldung und Benachrichtigung Pflichtfeld.
- `Geraet.RaumId` ist **Pflicht** — Sensoren außerhalb von Räumen gibt es nicht.
- Durch die Beschränkung auf Tafel und Sensoren entfällt `LiefertMesswerte`: Sensoren
  liefern Messwerte, die Tafel liefert nur ihren Status.
- **`Messwert` ist die einzige Tabelle, die stark wächst.** Bei 20 Sensoren im
  30-Sekunden-Takt sind das rund 1,7 Mio. Zeilen pro Monat. Nötig ist deshalb ein
  **Index auf `(GeraetId, Zeitpunkt)`** — ohne ihn wird jede Verlaufsabfrage langsam.
- Für den Baum wird nur der **jeweils letzte** Messwert je Gerät geladen, nie die Historie.
- Gelöschte Aufträge: **Soft-Delete** empfohlen, sonst verschwindet Historie (FA-09).
  *(Annahme — siehe U-6.)*
- Das Datenmodell ist als ER-Diagramm zu dokumentieren (NFA-12, Projektergebnis).

---

## 9 REST-API (grober Entwurf)

Abkürzungen: **L** = Lehrkraft, **H** = Hausmeister*in, **A** = Admin, **S** = Schulleitung.

| Methode | Pfad | Zweck | Rolle |
|---------|------|-------|-------|
| `POST` | `/api/auth/login` | Anmeldung (E-Mail + Passwort), liefert Token | alle |
| `GET` | `/api/dashboard` | alle Kennzahlen des Dashboards in einem Aufruf | H, A, S |
| `GET` | `/api/statistiken?von=&bis=` | Statistiken (Kapitel 5.10) | H, A, S |
| `GET` | `/api/tree` | kompletter Baum inkl. berechnetem Status; **letzter Messwert nur für H, A, S** | alle |
| `GET` | `/api/raeume/{id}` | Raumdetail inkl. Geräte | alle |
| `GET` | `/api/raeume/{id}/auftraege?status=` | Aufträge des Raums, offen **und** erledigt (Doppelmeldungs-Prüfung, Historie) | alle |
| `GET` | `/api/geraete/{id}` | Gerätedetail | alle |
| `GET` | `/api/geraete/{id}/messwerte?von=&bis=` | Messwerte im Zeitraum | H, A, S |
| `GET` | `/api/geraete/{id}/notizen` | Notizen | H, A, S |
| `POST` | `/api/geraete/{id}/notizen` | Notiz anlegen | H, A |
| `GET` | `/api/auftraege` | Liste; für Lehrkraft **serverseitig** auf eigene gefiltert | alle |
| `POST` | `/api/auftraege` | Auftrag anlegen (Störung oder Wartung; Wartung nur H, A) | L, H, A |
| `GET` | `/api/auftraege/{id}` | Auftragsdetail | alle |
| `PUT` | `/api/auftraege/{id}` | bearbeiten, Status ändern, zuweisen | H, A |
| `DELETE` | `/api/auftraege/{id}` | löschen (Soft-Delete) | A |
| `GET` | `/api/warnungen` | aktive und vergangene Warnungen | H, A, S |
| `POST` | `/api/warnungen/{id}/quittieren` | Warnung quittieren | H, A |
| `POST` / `DELETE` | `/api/push/abo` | Push-Abo des Geräts speichern / entfernen | alle |
| `GET` | `/api/export/...` | JSON-Export (Kapitel 11) | H, A, S |
| `GET/POST/PUT` | `/api/gebaeude`, `/api/etagen`, `/api/raeume`, `/api/geraete` | Stammdatenverwaltung | H, A |
| `DELETE` | `/api/gebaeude`, `/api/etagen`, `/api/raeume`, `/api/geraete` | Stammdaten löschen | A |
| `GET/POST/PUT` | `/api/nutzer` | Nutzerverwaltung | A |

**Bewusst getrennte Endpunkte:** Aufträge (`/raeume/{id}/auftraege`, für alle) und
Messwerte/Notizen/Warnungen (eigene Endpunkte, nicht für Lehrkräfte) sind getrennt. So kann
eine Lehrkraft Sensorwerte auch dann nicht abrufen, wenn sie den Aufruf von Hand absetzt.

**Sicherheitsregel:** Die Einschränkungen „Lehrkraft sieht in der Auftragsliste nur
eigene Aufträge" und „Lehrkraft sieht keine Sensorwerte" werden **im Backend**
durchgesetzt. Das Frontend darf sich
nicht darauf verlassen, dass es die richtigen Daten anfragt.

**Dokumentation:** Die API wird mit **OpenAPI/Swagger** dokumentiert — in .NET weitgehend
automatisch. Das erfüllt gleichzeitig die geforderte „Dokumentation der Schnittstellen"
(NFA-02) und liefert der Daten- und Prozessanalyse eine belastbare Beschreibung.

---

## 10 Aufbau Frontend (Vue)

```
src/
├── main.js
├── sw.js         → Service Worker: Offline-Cache, Empfang von Push-Nachrichten
├── api/          → axios-Client, Token, zentrale Fehlerbehandlung
├── stores/       → Zustand (z. B. Pinia): Anmeldung, Baum, Aufträge
├── components/   → Baumknoten, Statusampel, Kennzahlkachel, Diagramme
├── views/
│   ├── LoginView.vue
│   ├── DashboardView.vue
│   ├── UebersichtView.vue      → TreeView
│   ├── DetailView.vue          → Raum/Gerät, rollenabhängige Bereiche
│   ├── AuftraegeView.vue
│   ├── AuftragFormView.vue
│   ├── WartungView.vue
│   ├── WarnungenView.vue
│   ├── StatistikView.vue
│   ├── VerwaltungView.vue
│   └── NutzerView.vue          → nur Admin
└── router/       → Routen inkl. Rollenprüfung
```

Der Baum wird als **rekursive Komponente** umgesetzt (eine `KnotenNode.vue`, die sich für
ihre Kinder selbst aufruft) — damit funktionieren alle vier Ebenen mit demselben Code.

Für Diagramme reicht eine schlanke Bibliothek (z. B. Chart.js); eine eigene
Diagramm-Implementierung lohnt sich nicht.

**PWA:** Mit `vite-plugin-pwa` entstehen Manifest (Name, Icon, Startseite) und Service
Worker weitgehend automatisch. Der Service Worker cached die Oberfläche, damit die App
schnell startet; Daten kommen weiterhin live über die API. Push-Nachrichten empfängt der
Service Worker und zeigt sie als Systembenachrichtigung an; Klick öffnet den Auftrag bzw.
die Warnung.

---

## 11 JSON-Export und Dummy-Daten

### 11.1 JSON-Export (FA-29)

Mindestanforderung der Aufgabenstellung. Exportierbar sind:

- Räume und Geräte (Stammdaten)
- Aufträge in einem Zeitraum
- Messwerte eines Geräts oder Raums in einem Zeitraum
- Warnungen in einem Zeitraum

Der Export ist derselbe JSON-Aufbau wie in der API — kein zweites Format pflegen.
Zusätzlich **CSV** anbieten, falls die Daten- und Prozessanalyse mit Tabellenwerkzeugen
arbeitet. *(Annahme — siehe U-13.)*

### 11.2 Dummy-Daten (FA-27)

Laut auftraggebender Lehrkraft sind **reale Daten und mit KI erzeugte Mock-Daten**
vorgesehen; **reine Mock-Daten sind ebenfalls erlaubt**. Für die realen Sensordaten ist
**Herr Hahn** Ansprechpartner (Schnittstelle und Format noch offen, U-19).

Die Simulation läuft als kleines Programm, das per MQTT publiziert — **derselbe Weg wie
echte Hardware**, dadurch muss am Backend nichts umgeschaltet werden. Reale Daten werden,
falls sie nicht per MQTT kommen, über einen Adapter in dieselbe Topic-Struktur übersetzt.

**KI-erzeugte Mock-Daten:** Historische Daten (Messwerte über Wochen, Aufträge mit
realistischen Beschreibungen) können mit einer KI als JSON erzeugt und per Import-Skript
eingespielt werden. Wichtig: Die KI liefert nur die **Datei**, geprüft und eingespielt wird
über unser eigenes Skript — so bleibt nachvollziehbar, woher die Daten stammen.

Zu simulieren sind mindestens:

- mehrere Räume mit Temperatur, CO₂ und Luftfeuchte im Tagesverlauf
- ein Raum, dessen CO₂-Wert im Unterricht ansteigt und beim Lüften wieder fällt
- ein Gerät, das ausfällt (keine Nachrichten mehr → offline)
- eine Tafel, die nach Unterrichtsende eingeschaltet bleibt
- ein Raum, in dem nach Unterrichtsende das Licht an bleibt (Lichtsensor)
- ein Gerätefehler, der zu einer Störmeldung führt

Zusätzlich werden **historische Daten** für mehrere Wochen erzeugt — sonst hat die Daten-
und Prozessanalyse nichts auszuwerten und das Dashboard zeigt leere Diagramme.

---

## 12 Schnittstelle zur Daten- und Prozessanalyse

Die zweite Fachrichtung wertet die Daten aus, die dieses System erzeugt. Daraus folgt für
uns konkret:

| Bedarf der Analyse | Was wir liefern müssen |
|--------------------|------------------------|
| „Welche Räume verursachen die meisten Störungen?" | Aufträge mit Raum-, Gerät- und Zeitbezug, auch erledigte |
| „Welche Geräte fallen besonders häufig aus?" | Warnungen/Offline-Zeiten mit Beginn und Ende |
| „Wie lange dauert die Bearbeitung?" | `ErstelltAm` **und** `ErledigtAm` je Auftrag, plus Statuswechsel |
| Verläufe und Muster | Messwerte über längere Zeiträume, nicht nur den letzten Wert |

**Abgrenzung zu unseren Statistiken:** Die einfachen Statistiken in der Anwendung
(Kapitel 5.10) bauen wir selbst. Alles darüber hinaus — Prognosen, Muster, Machine
Learning — macht die Daten- und Prozessanalyse auf Basis unserer Daten.

**Drei Punkte, die dafür jetzt schon entschieden werden müssen:**

1. **Nichts hart löschen.** Erledigte Aufträge, beendete Warnungen und alte Messwerte
   bleiben erhalten — sonst fehlt der Analyse die Datenbasis (siehe U-6).
2. **Zeitstempel überall.** Jeder Statuswechsel braucht einen Zeitpunkt, sonst lässt sich
   Bearbeitungsdauer nicht berechnen. Ein `Statusverlauf`-Eintrag je Wechsel ist dafür der
   sauberste Weg. *(Vorschlag — siehe U-14.)*
3. **Früh abstimmen.** Welche Felder die Analyse braucht, sollte **vor** dem Datenmodell
   feststehen — nachträglich Felder ergänzen bedeutet Migration plus erneute
   Datenerzeugung.

---

## 13 Abdeckung der Mindestanforderungen

| Mindestanforderung | Abgedeckt durch |
|--------------------|-----------------|
| Funktionierendes Backend mit REST-API | Kapitel 2, 9 |
| Datenbank mit dokumentiertem Datenmodell | Kapitel 8 |
| MQTT-Datenempfang oder realistische Simulation | Kapitel 6, 11.2 |
| Dummy-Daten für mehrere Räume und Geräte | Kapitel 11.2 |
| Dashboard mit Übersichtsdaten | Kapitel 5.1 |
| Mindestens eine Raumdetailansicht | Kapitel 5.3 |
| Einfaches Störmeldesystem | Kapitel 5.4, 5.5 |
| JSON-Export | Kapitel 11.1 |
| Dokumentation der Schnittstellen | Kapitel 9 (OpenAPI), 6.1 (MQTT) |
| Projekt- und Meilensteinplanung | GANTT — **fehlt noch** |

---

## 14 Umsetzungsreihenfolge

| Schritt | Inhalt | Ergebnis |
|---------|--------|----------|
| 1 | MySQL-Datenmodell anlegen, Stammdaten-Testdaten einspielen | Datenbasis steht |
| 2 | Backend: einfacher Login + vier Rollen | Zugriffsschutz steht |
| 3 | Backend: Stammdaten-CRUD + `/api/tree` | Baum ist abrufbar |
| 4 | Vue: Login + TreeView ohne Status | erste sichtbare Oberfläche |
| 5 | Aufträge anlegen (inkl. Priorität) und auflisten | Kernnutzen erreicht |
| 6 | MQTT-Broker aufsetzen + Simulator, Messwerte speichern | Sensordaten fließen |
| 7 | Statusberechnung + Fehler-Markierung im Baum | Hauptmerkmal der Übersicht |
| 8 | Aktive Störungen im Baum und im Auftragsformular | keine Doppelmeldungen |
| 9 | Detailansicht mit Werten, Historie und Notizen, rollenabhängig | Nachvollziehbarkeit |
| 10 | Dashboard: Kennzahlen, Warnungen, letzte Störungen | Mindestanforderung erfüllt |
| 11 | Regeln + Warnungen, Offline-Erkennung | automatische Überwachung |
| 12 | E-Mail-Versand bei Statusänderung | Rückmeldung an die Lehrkraft |
| 12a | PWA (Manifest, Service Worker) + Web Push für Hausmeister*in | schnelle Benachrichtigung |
| 13 | Wartung | Wartungsdokumentation |
| 14 | JSON-Export + OpenAPI-Dokumentation | Schnittstelle für die Analyse |
| 15 | Verwaltungsmasken + Nutzerverwaltung (Admin) | Pflege ohne Datenbankzugriff |
| 16 | Statistiken (Kapitel 5.10) | „Daten auswerten" erfüllt |
| 17 | Diagramme und Verläufe im Dashboard | Ausbaustufe |

Nach Schritt 10 sind alle Mindestanforderungen bis auf Export und Doku erfüllt — das ist
ein sinnvoller Punkt, um den Projektstand vorzuführen.

---

## 15 Offene Punkte

### 15.1 Geklärt

| Nr. | Frage | Entscheidung |
|-----|-------|--------------|
| U-1 | Was darf eine Lehrkraft sehen? | **Nur Aufträge:** eigene Aufträge inkl. Status und die bisherigen (offenen und erledigten) Aufträge des Raums. Den Baum zur Raumwahl ja, aber **ohne Messwerte**. |
| U-2 | Dürfen Lehrkräfte Notizen lesen? | **Nein** — Lehrkraft sieht „nur" Aufträge. |
| U-3 | Auftrag auf einen Raum ohne konkretes Gerät? | **Ja**, als **„Sonstiges"** mit Beschreibung. |
| U-4 | Wer setzt die Priorität? | **Die meldende Person beim Anlegen**; Hausmeister*in und Admin können sie ändern. |
| U-5 | Wann „Fehler" statt „Warnung"? | Priorität **und** Sensor-/Offline-Zustand fließen ein, siehe Tabelle in 5.2. |
| U-8 | Reale Sensorik oder Simulation? | **Reale Daten + KI-erzeugte Mock-Daten**, reine Mock-Daten auch erlaubt. |
| U-11 | Was sieht eine Lehrkraft auf dem Dashboard? | **Kein Dashboard** für Lehrkräfte (enthält Sensorwerte). |
| U-15 | Welche Benutzergruppen? | **Lehrkraft, Hausmeister*in, Schulleitung, Admin.** Keine Schüler*innen, keine IT-Rolle. |
| U-20 | Anmeldung über M365 / Schulmail? | **Nein** — einfache eigene Anmeldung, „kein großes Drumherum". |
| U-21 | Web oder App, wie benachrichtigen? | **PWA** mit Push, **zusätzlich E-Mail**. |
| U-22 | Gibt es Sensoren außerhalb von Räumen? | **Nein.** |
| U-23 | Was heißt „Daten auswerten"? | **Statistiken** (Kapitel 5.10). |
| U-24 | Welche Geräte gibt es pro Raum? | **Nur die digitale Tafel**; dazu Sensoren. Licht nur als Lichtsensor. |

### 15.2 Noch offen

| Nr. | Frage |
|-----|-------|
| U-6 | Gelöschte Aufträge wirklich entfernen oder nur ausblenden? (Wichtig für Historie **und** für die Datenanalyse.) |
| U-7 | Gibt es mehrere Gebäude, oder nur den Standort Beatusstraße mit mehreren Etagen? |
| U-9 | E-Mail nur bei **Statusänderung**, oder auch bei Kommentar bzw. Zuweisung? |
| U-10 | Steht ein SMTP-Postfach der Schule zur Verfügung, oder wird der Versand simuliert? |
| U-12 | Welche Statuswerte soll ein Auftrag haben — reichen `neu`/`in Bearbeitung`/`erledigt`? |
| U-13 | Braucht die Daten- und Prozessanalyse zusätzlich CSV, oder reicht JSON? |
| U-14 | Soll jeder Statuswechsel einzeln protokolliert werden (für Bearbeitungsdauer-Analysen)? |
| U-16 | Steht ein MQTT-Broker bereit, oder setzt das Team selbst einen auf (z. B. Mosquitto lokal)? |
| U-17 | Welche realen Geräte/Sensoren werden konkret angebunden, und ab wann? |
| U-18 | Darf die Hausmeister*in auch **löschen**, oder bleibt das beim Admin? (Vorschlag: nur Admin) |
| U-19 | Schnittstelle, Format und Zugang der **realen** Sensordaten — MQTT oder etwas anderes? → **Herr Hahn** |
| U-25 | Reale Raumdaten der Schule (Raumnummern, Etagen) verwenden oder Beispielräume anlegen? |
| U-26 | Rechte der Schulleitung (Team-Entscheidung): Vorschlag **nur lesen**. |
