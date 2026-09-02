# Pflichtenheft (Grobform)

## Projekt „Smart School Service Hub"

**Auftraggebende Stelle:** BBS Technik Koblenz, Standort Beatusstraße
**Projektteam:** _(siehe Kapitel 1)_
**Klasse / Projektgruppe:** _[24a / 24b – bitte ergänzen]_
**Dokumentstand:** Grobform, Meilenstein 1
**Datum:** 02.09.2026
**Version:** 0.1

> **Hinweis zum Reifegrad:** Dieses Dokument ist bewusst die in Meilenstein 1 geforderte
> **Grobform**. Es enthält die Teambeschreibung, den Projektauftrag und die vorpriorisierte
> Anforderungsliste. Feinspezifikation (Datenmodell, Schnittstellen, GUI-Entwürfe,
> Testfälle) folgt in den späteren Meilensteinen.

---

## 1 Teambeschreibung

> _Dieses Kapitel wird vom Team selbst ausgefüllt._

<!--
Vorschlag für die Struktur (kann gelöscht werden):
- Teamname
- Mitglieder mit Rolle (Projektleitung, Frontend, Backend, Datenbank, Doku/QS)
- Vorkenntnisse und Stärken je Mitglied
- Verfügbarkeit (Verkürzende / Nicht-Verkürzende)
- Zusammenarbeit: Kommunikationswege, Meeting-Rhythmus, Werkzeuge
-->

---

## 2 Projektauftrag

### 2.1 Ausgangssituation

Am Standort Beatusstraße der BBS Technik Koblenz werden zahlreiche technische Geräte,
Räume und digitale Systeme täglich genutzt. Dazu gehören digitale Displays, 3D-Drucker,
Netzwerktechnik, Raumlüftung, smarte Steckdosen, Sensoren und weitere schulische
Infrastruktur.

Störungen, Raumprobleme oder Wartungsbedarfe werden aktuell **mündlich, per E-Mail oder
über einzelne Notizen** gemeldet. Dadurch fehlt eine zentrale Übersicht. Der/die
Hausmeister*in, die IT-Verantwortlichen und die Lehrkräfte erkennen oft erst spät,

- welche Räume betroffen sind,
- welche Geräte nicht funktionieren,
- ob sich bestimmte Probleme wiederholen.

### 2.2 Projektziel

Es wird eine digitale Anwendung „Smart School Service Hub" entwickelt, die
**Sensordaten, Gerätedaten und Störmeldungen zentral erfasst, speichert, auswertet und
übersichtlich darstellt.**

Konkrete Teilziele:

| Nr. | Ziel |
|-----|------|
| Z1 | Störmeldungen werden digital, strukturiert und nachvollziehbar erfasst statt mündlich/per Mail. |
| Z2 | Alle Beteiligten haben eine gemeinsame, aktuelle Übersicht über Räume und Geräte. |
| Z3 | Der Bearbeitungsstand einer Meldung ist jederzeit einsehbar. |
| Z4 | Sensor- und Gerätedaten werden zentral gespeichert und dargestellt. |
| Z5 | Wiederkehrende Probleme werden durch Historie und Auswertung erkennbar. |

### 2.3 Projektumfeld und Beteiligte

| Beteiligte | Interesse am Projekt |
|------------|----------------------|
| Hausmeister*in | schnelle, vollständige Störmeldungen; klare Arbeitsliste |
| IT-Verantwortliche | Überblick über Geräte- und Netzwerkstatus |
| Lehrkräfte | einfaches Melden von Problemen; Rückmeldung zum Stand |
| Schulleitung | Transparenz, Auswertung, Planungsgrundlage |
| Schüler*innen (Projektteam) | Umsetzung des Projekts, Lernziel |
| Lehrkraft als Auftraggeber*in | Bewertung der Meilensteine |

> **Offen:** Die ausführliche Beschreibung des Projektumfelds wird laut Aufgabenstellung
> noch auf moodle bereitgestellt und ist hier nachzutragen.

### 2.4 Liefergegenstände

- Lauffähige Anwendung (App/Client) inkl. Backend und Datenbank
- Quellcode im Repository
- Pflichtenheft (Grobform → Feinform)
- Projektdokumentation und Präsentation
- Grobes GANTT-Diagramm zur Phasenplanung

### 2.5 Technische Festlegung (verbindliche Plattformzusage)

| Ebene | Technologie | Begründung |
|-------|-------------|------------|
| Frontend / App | **Flutter (Dart)** | eine Codebasis für mehrere Plattformen, schnelle UI-Entwicklung |
| Backend | **C# (.NET), REST-API** | klare Trennung von Client und Logik, im Unterricht abgedeckt |
| Datenbank | **SQL-Datenbank (relational)** | strukturierte Stammdaten (Räume, Geräte, Meldungen), Auswertbarkeit |

Diese Festlegung erfüllt die in Meilenstein 1 geforderte verbindliche Zusage zur
genutzten Plattform.

### 2.6 Abgrenzung (Nicht-Ziele)

Nicht Bestandteil dieses Projekts sind:

- Beschaffung, Installation oder Verkabelung realer Sensorik-Hardware
- Eingriff in bestehende Schulsysteme (Schulverwaltung, Netzwerk, moodle)
- produktiver Dauerbetrieb inkl. Wartungsvertrag
- Steuerung von Geräten (das System **meldet und zeigt an**, es **schaltet nicht**)

### 2.7 Rahmenbedingungen

- Bearbeitung im Rahmen des Unterrichts, Team laut Kapitel 1
- Termine und Meilenstein-Deadlines: _[noch einzutragen]_
- Kein Budget für kostenpflichtige Dienste/Hardware
- Personenbezogene Daten sind auf das Minimum zu beschränken (DSGVO)

### 2.8 Grobe Risiken

| Risiko | Auswirkung | Gegenmaßnahme |
|--------|-----------|---------------|
| Keine reale Sensorik verfügbar | Sensordaten nicht testbar | Simulation/Testdaten-Generator |
| Technologie neu für Teile des Teams | Verzögerung | frühe Einarbeitung, Rollen nach Stärken |
| Zu großer Funktionsumfang | Meilenstein nicht erreicht | strikte Priorisierung (Kap. 3) |
| Ausfall von Teammitgliedern | Wissensinseln | Doku im Repository, Pair-Arbeit |

---

## 3 Anforderungsliste

**Priorisierung:**
**A = Muss** (ohne diese Funktion ist das Projektziel verfehlt) ·
**B = Soll** (deutlicher Mehrwert, nach A umzusetzen) ·
**C = Kann** (Ausbaustufe, wenn Zeit bleibt)

### 3.1 Funktionale Anforderungen

| ID | Anforderung | Prio |
|----|-------------|------|
| FA-01 | Nutzende können sich anmelden; es gibt unterschiedliche Rollen (Lehrkraft, Hausmeister*in, IT, Administration). | A |
| FA-02 | Eine Störmeldung kann erfasst werden mit: Raum, betroffenes Gerät, Beschreibung, Meldezeitpunkt, meldende Person. | A |
| FA-03 | Räume werden zentral verwaltet (anlegen, bearbeiten, ansehen). | A |
| FA-04 | Geräte werden zentral verwaltet und einem Raum zugeordnet (Displays, 3D-Drucker, Netzwerktechnik, Lüftung, smarte Steckdosen, Sensoren). | A |
| FA-05 | Alle Meldungen sind in einer zentralen Übersicht sichtbar (Liste). | A |
| FA-06 | Jede Meldung hat einen Bearbeitungsstatus (z. B. neu → in Bearbeitung → erledigt), der geändert werden kann. | A |
| FA-07 | Meldungen können nach Raum, Gerät, Status und Zeitraum gefiltert/durchsucht werden. | A |
| FA-08 | Alle Daten werden dauerhaft in der SQL-Datenbank gespeichert. | A |
| FA-09 | Zu jedem Raum und jedem Gerät ist die Meldungshistorie einsehbar. | B |
| FA-10 | Sensordaten (z. B. Temperatur, Luftqualität, Betriebszustand) werden erfasst und gespeichert. | B |
| FA-11 | Sensor- und Gerätedaten werden übersichtlich dargestellt (Dashboard mit Kennzahlen/Diagrammen). | B |
| FA-12 | Eine Meldung kann einer zuständigen Person zugewiesen werden. | B |
| FA-13 | Auswertung: häufige bzw. wiederkehrende Probleme je Raum/Gerät werden erkennbar. | B |
| FA-14 | Zu einer Meldung können Kommentare/Rückmeldungen erfasst werden. | B |
| FA-15 | Priorität/Dringlichkeit einer Meldung ist setzbar. | B |
| FA-16 | Benachrichtigung der zuständigen Person bei neuer oder geänderter Meldung. | C |
| FA-17 | Fotos können an eine Meldung angehängt werden. | C |
| FA-18 | Schnellmeldung per QR-Code am Raum bzw. Gerät. | C |
| FA-19 | Grenzwerte für Sensoren definierbar; bei Überschreitung automatische Meldung/Warnung. | C |
| FA-20 | Export von Auswertungen (z. B. CSV/PDF). | C |
| FA-21 | Wartungsplanung: wiederkehrende Wartungstermine je Gerät. | C |

### 3.2 Nichtfunktionale Anforderungen

| ID | Anforderung | Prio |
|----|-------------|------|
| NFA-01 | Client als Flutter-Anwendung, Backend in C# (.NET), Datenhaltung in einer SQL-Datenbank. | A |
| NFA-02 | Die Kommunikation zwischen App und Backend erfolgt über eine dokumentierte REST-API. | A |
| NFA-03 | Bedienung ohne Schulung verständlich; eine Störmeldung ist in wenigen Schritten erfasst. | A |
| NFA-04 | Zugriff nur nach Anmeldung; Rechte richten sich nach der Rolle. | A |
| NFA-05 | Es werden nur die notwendigen personenbezogenen Daten gespeichert (DSGVO). | A |
| NFA-06 | Quellcode versioniert im Git-Repository, nachvollziehbare Commits. | A |
| NFA-07 | Übersichten laden im Normalbetrieb in unter 2 Sekunden. | B |
| NFA-08 | Nutzbar auf Smartphone und Desktop (responsive Darstellung). | B |
| NFA-09 | Der Code ist kommentiert und dokumentiert, damit er weiterentwickelt werden kann. | B |
| NFA-10 | Neue Gerätetypen sind ohne Codeänderung anlegbar (Erweiterbarkeit). | C |

### 3.3 Offene Punkte / zu klären

| Nr. | Frage | zu klären mit |
|-----|-------|---------------|
| OP-1 | Steht reale Sensorik zur Verfügung, oder werden Sensordaten simuliert? | Auftraggeber*in |
| OP-2 | Über welche Schnittstelle/welches Protokoll werden Sensordaten geliefert? | IT-Verantwortliche |
| OP-3 | Welche Rollen und Rechte sind tatsächlich gewünscht? | Auftraggeber*in |
| OP-4 | Soll die Anwendung auch als Web-Anwendung laufen oder nur als App? | Team / Auftraggeber*in |
| OP-5 | Ausführliche Projektbeschreibung von moodle nachtragen. | moodle |
| OP-6 | Konkrete Meilenstein-Termine. | Auftraggeber*in |

---

## 4 Weiteres Vorgehen (Ausblick Meilenstein 1)

- [ ] Teambeschreibung (Kapitel 1) ausfüllen
- [ ] Roh-GANTT-Diagramm der Projektphasen anlegen: *Was kommt wann und wer kümmert sich?*
- [ ] Offene Punkte aus 3.3 klären und Anforderungsliste nachschärfen
- [ ] Pflichtenheft von Grobform in Richtung Feinform ausbauen
