# Notizen – Smart School Service Hub

## Technologie-Entscheidung (Team-Beschluss)

- **Frontend:** **Vue** – Weboberfläche, ausgeliefert als **PWA** (installierbar, Push)
- **Backend:** C# (.NET) – REST-API mit JSON
- **Datenbank:** **MySQL**
- **Sensordaten:** MQTT (Broker, z. B. Mosquitto) – Vorgabe der Aufgabenstellung
- **Austauschformat:** JSON – Vorgabe der Aufgabenstellung

> **Geändert:** Ursprünglich war **Flutter** als Frontend zugesagt. Das Team hat auf
> **Vue** gewechselt (Weboberfläche passt besser zum schulischen Einsatz). Die Datenbank
> ist von „SQL allgemein" auf **MySQL** konkretisiert. Backend (C#) bleibt unverändert.
> Die verbindliche Plattformzusage im Pflichtenheft (Kap. 2.5) ist entsprechend angepasst.

## Klärung mit dem Auftraggeber (Herr Richter, 30.09.2026)

| Frage | Antwort |
|-------|---------|
| Reale Sensorik oder simuliert? | **Reale Daten + mit KI erzeugte Mock-Daten**; reine Mock-Daten sind ebenfalls erlaubt |
| Schnittstelle / Protokoll der realen Sensordaten? | Ansprechpartner: **Herr Hahn** (noch zu klären) |
| Welche Rollen? | **Nur Lehrkraft, Hausmeister*in, Schulleitung + Admin** – keine Schüler*innen, keine eigene IT-Rolle |
| Rechte | Hausmeister*in: lesen + schreiben · Lehrkraft: nur Aufträge **stellen** · Admin: alles · Schulleitung: **freiwillig**, legt das Team fest |
| Darf eine Lehrkraft Sensorwerte (z. B. Temperatur) sehen? | **Nein** – Lehrkraft sieht nur die **bisherigen Aufträge des Raums** |
| Login über M365 / Schulmail? | **Nein, Login frei wählbar**, „kein großes Drumherum" → eigene einfache Anmeldung |
| Web oder App? Benachrichtigung? | **PWA + zusätzlich E-Mail** |
| Sensoren außerhalb von Räumen? | **Nein**, jeder Sensor gehört zu einem Raum |
| Was heißt „Daten auswerten"? | **Statistiken** |
| Was wird pro Raum gespeichert? | **Sensoren + digitale Tafel** – die Tafel ist das einzige Gerät; Licht ist nur ein **Lichtsensor**. Alles andere als „Sonstiges" mit Beschreibung |
| Reale Raumdaten oder Beispielräume? | _keine Antwort notiert – offen_ |

## Projektstruktur

Zwei Fachrichtungen arbeiten am selben Produkt:

- **Anwendungsentwicklung** (LF 10a/11a/12a) – *unser Team*: Oberfläche, Backend,
  Datenbank, Schnittstellen
- **Daten- und Prozessanalyse** (LF 10c/11c/12c): Kennzahlen, Visualisierung,
  Prozessoptimierung, Machine Learning

→ Wir liefern die **Daten**, sie machen die **Auswertung**. Die Analyse formuliert
Anforderungen an benötigte Daten; wir müssen Speicherung und Bereitstellung sicherstellen.

## Dokumente

- [02_Pflichtenheft.md](02_Pflichtenheft.md) – Projektauftrag + Anforderungsliste (v0.3)
- [03_Umsetzungskonzept.md](03_Umsetzungskonzept.md) – Architektur, Screens, Datenmodell,
  MQTT, API (v0.4)
- [04_GANTT.md](04_GANTT.md) – Roh-GANTT der Projektphasen (v0.1)

## Offene Punkte

- Klasse / Gruppenanzahl: 24a (8 Gruppen) oder 24b (6 Gruppen)?
- Termine / Meilenstein-Deadlines noch offen
- Roh-GANTT angelegt ([04_GANTT.md](04_GANTT.md)); Termine nach M1 sind geschätzt, Ferien und Namen fehlen noch
- Reale Sensordaten: Schnittstelle, Format, Zugang → **mit Herrn Hahn klären**
- Reale Raumdaten der Schule verwenden oder Beispielräume anlegen?
- Rechte der Schulleitung festlegen (Team-Entscheidung, Vorschlag: nur lesen)
- MQTT-Broker: selbst aufsetzen oder von der Schule gestellt?
- SMTP-Postfach für E-Mail-Versand vorhanden?

Detaillierte offene Fragen: Kapitel 15 im Umsetzungskonzept, Kapitel 3.3 im Pflichtenheft.
