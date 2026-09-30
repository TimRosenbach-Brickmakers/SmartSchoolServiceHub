# Pflichtenheft (Grobform)

## Projekt „Smart School Service Hub"

**Auftraggebende Stelle:** BBS Technik Koblenz, Standort Beatusstraße
**Projektteam:** _(siehe Kapitel 1)_
**Klasse / Projektgruppe:** _[24a / 24b – bitte ergänzen]_
**Dokumentstand:** Grobform, Meilenstein 1
**Datum:** 30.09.2026
**Version:** 0.3

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
Netzwerktechnik, Raumklima-Sensoren, smarte Steckdosen und weitere technische
Infrastruktur.

Störungen und Wartungsbedarfe werden bisher teilweise **mündlich, per E-Mail, über ein
Störungsbuch aus dem Jahr 1973 oder über einzelne Aufzeichnungen** gemeldet. Dadurch fehlt
eine zentrale Übersicht darüber,

- welche Geräte betroffen sind,
- welche Störungen aktuell bestehen,
- welche Probleme wiederholt auftreten.

Der/die Hausmeister*in, die IT-Verantwortlichen und die Lehrkräfte erkennen Probleme
dadurch oft erst spät.

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
| Lehrkräfte | einfaches Melden von Problemen; Rückmeldung zum Stand |
| Schulleitung | Transparenz, Statistiken, Planungsgrundlage |
| Administrator*in | Pflege von Nutzenden, Stammdaten und System |
| Schüler*innen (Projektteam) | Umsetzung des Projekts, Lernziel |
| Lehrkraft als Auftraggeber*in | Bewertung der Meilensteine |

**Zweite Fachrichtung im selben Projekt:** Der Service Hub wird von zwei Fachrichtungen
gemeinsam bearbeitet.

| Fachrichtung | Schwerpunkt |
|--------------|-------------|
| Fachinformatik **Anwendungsentwicklung** (LF 10a, 11a, 12a) — *dieses Team* | Entwicklung des Service Hub: Oberfläche, Backend, Datenbank, Schnittstellen, Datenverarbeitung |
| Fachinformatik **Daten- und Prozessanalyse** (LF 10c, 11c, 12c) | Auswertung der entstehenden Daten: Kennzahlen, Visualisierungen, Prozessoptimierung, Machine Learning |

Daraus ergibt sich eine feste Schnittstelle: Die Daten- und Prozessanalyse formuliert
Anforderungen an benötigte Daten, dieses Team muss deren Speicherung und Bereitstellung
über die API sicherstellen.

**Benutzergruppen (geklärt mit der auftraggebenden Lehrkraft):** Die Anwendung nutzen
ausschließlich **Lehrkräfte, Hausmeister*in, Schulleitung und Administration**.
Schüler*innen erstellen keine Meldungen; eine eigene IT-Rolle gibt es nicht.

**Erfasste Ausstattung je Raum (geklärt):** Jeder Raum hat **Sensoren** (Temperatur, CO₂,
Luftfeuchte, Licht) und als einziges technisches Gerät die **digitale Tafel**. Licht wird
nur über einen **Lichtsensor** erfasst, nicht als steuerbares Gerät. Andere Probleme im
Raum werden als **„Sonstiges"** mit Beschreibung gemeldet. Sensoren außerhalb von Räumen
gibt es nicht.

> **Offen:** Die ausführliche Beschreibung des Projektumfelds wird laut Aufgabenstellung
> noch auf moodle bereitgestellt und ist hier nachzutragen.

### 2.4 Liefergegenstände

**Mindestanforderungen an das Software-System** (Vorgabe der Aufgabenstellung):

- funktionierendes Backend mit REST-API
- Datenbank mit sinnvollem und **dokumentiertem** Datenmodell
- MQTT-Datenempfang **oder** eine realistische Simulation
- Dummy-Daten für mehrere Räume und Geräte
- Dashboard mit Übersichtsdaten
- mindestens eine Raumdetailansicht
- ein einfaches Störmeldesystem
- ein JSON-Export
- Dokumentation der Schnittstellen
- nachvollziehbare Projekt- und Meilensteinplanung

**Projektergebnisse zum Abschluss:**

- lauffähige Anwendung und vollständiger Quellcode
- Datenmodell und API-Dokumentation
- Beschreibung der MQTT-Struktur und Beispiel-JSON-Daten
- Testdokumentation und kurze Benutzerdokumentation
- Abschlusspräsentation und Reflexion der Projektarbeit
- Pflichtenheft (Grobform → Feinform), GANTT-Diagramm zur Phasenplanung

### 2.5 Technische Festlegung (verbindliche Plattformzusage)

| Ebene | Technologie | Begründung |
|-------|-------------|------------|
| Frontend | **Vue** als **Progressive Web App (PWA)** | im Browser ohne Installation nutzbar, auf dem Smartphone installierbar, Push-Benachrichtigungen möglich (Vorgabe der auftraggebenden Lehrkraft) |
| Backend | **C# / .NET, REST-API mit JSON** | klare Trennung von Oberfläche und Logik, im Unterricht abgedeckt |
| Datenbank | **MySQL** (relational) | strukturierte Stammdaten (Räume, Geräte, Aufträge), gute Auswertbarkeit für die Daten- und Prozessanalyse |
| Datenübertragung Sensorik | **MQTT** | in der Projektbeschreibung vorgegeben; Standard für Sensor- und Gerätedaten |
| Austauschformat | **JSON** | in der Projektbeschreibung vorgegeben |

Diese Festlegung erfüllt die in Meilenstein 1 geforderte verbindliche Zusage zur
genutzten Plattform.

> **Änderung gegenüber Version 0.1:** Ursprünglich war **Flutter** als Frontend zugesagt.
> Das Team hat auf **Vue** gewechselt, da eine Weboberfläche für den schulischen Einsatz
> besser passt. Backend (C#) bleibt, die Datenbank ist von „SQL allgemein" auf **MySQL**
> konkretisiert. In Version 0.3 ist die Auslieferung als **PWA** mit Push-Benachrichtigung
> ergänzt (Klärung mit der auftraggebenden Lehrkraft).

### 2.6 Abgrenzung (Nicht-Ziele)

Nicht Bestandteil dieses Projekts sind:

- Beschaffung, Installation oder Verkabelung realer Sensorik-Hardware
- Eingriff in bestehende Schulsysteme (Schulverwaltung, Netzwerk, moodle)
- produktiver Dauerbetrieb inkl. Wartungsvertrag
- Steuerung von Geräten: das System **meldet und zeigt an**, es **schaltet nicht**
  (Beispiel: „Tafel nach Unterrichtsende noch an" erzeugt eine Warnung, schaltet die
  Tafel aber nicht ab)
- Tiefergehende Analysen und Machine-Learning-Modelle — diese sind Aufgabe der
  Fachrichtung Daten- und Prozessanalyse; dieses Team **liefert die Daten** dafür (FA-33).
  **Einfache Statistiken** in der Anwendung (FA-13) gehören dagegen zum Umfang, denn
  „Daten auswerten" meint laut auftraggebender Lehrkraft genau diese Statistiken.
- Anbindung an Microsoft 365 / Schul-Mailkonten für die Anmeldung — die Anmeldung wird
  bewusst einfach und eigenständig umgesetzt

### 2.7 Rahmenbedingungen

- Bearbeitung im Rahmen des Unterrichts, Team laut Kapitel 1
- Termine und Meilenstein-Deadlines: _[noch einzutragen]_
- Kein Budget für kostenpflichtige Dienste/Hardware
- Personenbezogene Daten sind auf das Minimum zu beschränken (DSGVO)

### 2.8 Grobe Risiken

| Risiko | Auswirkung | Gegenmaßnahme |
|--------|-----------|---------------|
| Reale Sensordaten nicht rechtzeitig verfügbar | Sensordaten nicht testbar | KI-erzeugte Mock-Daten und Simulator (ausdrücklich erlaubt) |
| Push-Benachrichtigungen auf iOS nur eingeschränkt (PWA muss zum Home-Bildschirm hinzugefügt sein) | Hausmeister*in erhält keine Push-Meldung | E-Mail-Benachrichtigung zusätzlich (FA-16) |
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
| FA-01 | Nutzende können sich mit einer einfachen, eigenen Anmeldung (Benutzername/E-Mail + Passwort) anmelden; es gibt die Rollen Lehrkraft, Hausmeister*in, Schulleitung und Administration. | A |
| FA-02 | Eine Störmeldung kann erfasst werden mit: Raum, betroffenes Gerät (Tafel, Sensor oder „Sonstiges“), Beschreibung, Meldezeitpunkt, meldende Person. | A |
| FA-03 | Räume werden zentral verwaltet (anlegen, bearbeiten, ansehen). | A |
| FA-04 | Geräte werden zentral verwaltet und genau einem Raum zugeordnet: digitale Tafel sowie Sensoren (Temperatur, CO₂, Luftfeuchte, Licht). | A |
| FA-05 | Alle Meldungen sind in einer zentralen Übersicht sichtbar (Liste). | A |
| FA-06 | Jede Meldung hat einen Bearbeitungsstatus (z. B. neu → in Bearbeitung → erledigt), der geändert werden kann. | A |
| FA-07 | Meldungen können nach Raum, Gerät, Status und Zeitraum gefiltert/durchsucht werden. | A |
| FA-08 | Alle Daten werden dauerhaft in der SQL-Datenbank gespeichert. | A |
| FA-09 | Zu jedem Raum und jedem Gerät ist die Meldungshistorie einsehbar — auch für Lehrkräfte (bisherige Aufträge des Raums). | B |
| FA-10 | Sensordaten (Temperatur, CO₂, Luftfeuchte, Licht, Betriebszustand der Tafel) werden erfasst und gespeichert. | A |
| FA-11 | Sensor- und Gerätedaten werden übersichtlich dargestellt (Diagramme, Verläufe). | A |
| FA-12 | Eine Meldung kann einer zuständigen Person zugewiesen werden. | B |
| FA-13 | Statistiken: häufige bzw. wiederkehrende Probleme je Raum/Gerät, Bearbeitungsdauer und Störungen im Zeitverlauf werden als Statistik dargestellt. | B |
| FA-14 | Zu einer Meldung können Kommentare/Rückmeldungen erfasst werden. | B |
| FA-15 | Priorität/Dringlichkeit einer Meldung ist setzbar. | B |
| FA-16 | Die meldende Person wird per E-Mail benachrichtigt, sobald sich der Status ihres Auftrags ändert. | A |
| FA-17 | Fotos können an eine Meldung angehängt werden. | C |
| FA-18 | Schnellmeldung per QR-Code am Raum bzw. Gerät. | C |
| FA-19 | Grenzwerte für Sensoren definierbar; bei Überschreitung wird automatisch eine Warnung erzeugt. | B |
| FA-20 | Export von Auswertungen (z. B. CSV/PDF). | C |
| FA-21 | Wartungsplanung: wiederkehrende Wartungstermine je Gerät. | C |
| FA-22 | Die Übersicht stellt die Schule als Baumstruktur dar: Gebäude → Etage → Raum → Gerät/Sensor. | A |
| FA-23 | Eine Störung an einem Gerät markiert im Baum automatisch auch Raum, Etage und Gebäude. | A |
| FA-24 | Beim Anlegen eines Auftrags werden die bereits offenen Störungen des gewählten Raums angezeigt, um Doppelmeldungen zu vermeiden. | A |
| FA-25 | Zu Räumen und Geräten können dauerhafte Notizen erfasst und eingesehen werden. | B |
| FA-26 | Sensor- und Gerätedaten werden über einen MQTT-Broker empfangen und gespeichert. | A |
| FA-27 | Für mehrere Räume und Geräte stehen realistische Dummy-/Simulationsdaten zur Verfügung (KI-erzeugte Mock-Daten erlaubt), ergänzt um reale Sensordaten, sobald verfügbar. | A |
| FA-28 | Ein Dashboard zeigt die wichtigsten Kennzahlen auf einen Blick (offene Störungen, kritische Räume, Geräte online, aktuelle Warnungen). | A |
| FA-29 | Daten können als JSON exportiert werden. | A |
| FA-30 | Wartungsaufgaben können erfasst, zugewiesen und dokumentiert werden. | A |
| FA-31 | Für jedes Gerät ist erkennbar, ob es online, offline oder in Wartung ist. | B |
| FA-32 | Regelbasierte Warnungen werden automatisch erzeugt (z. B. CO₂ zu hoch, Gerät offline, Tafel bzw. Licht nach Unterrichtsende noch an, Störung mehrere Tage offen). | B |
| FA-33 | Historische Daten werden so bereitgestellt, dass die Fachrichtung Daten- und Prozessanalyse damit arbeiten kann. | A |
| FA-34 | Hausmeister*in erhält eine Push-Benachrichtigung (PWA) bei neuen Störungen und Warnungen; zusätzlich per E-Mail. | A |
| FA-35 | Lehrkräfte sehen keine Sensorwerte, Warnungen oder Notizen, sondern nur die Aufträge des Raums und ihre eigenen Aufträge. | A |
| FA-36 | Die Administration kann Nutzende anlegen, sperren und ihnen eine Rolle zuweisen. | A |

### 3.2 Nichtfunktionale Anforderungen

| ID | Anforderung | Prio |
|----|-------------|------|
| NFA-01 | Frontend als Vue-Weboberfläche (PWA), Backend in C# (.NET), Datenhaltung in MySQL. | A |
| NFA-02 | Die Kommunikation zwischen Frontend und Backend erfolgt über eine **dokumentierte** REST-API mit JSON als Austauschformat. | A |
| NFA-03 | Bedienung ohne Schulung verständlich; eine Störmeldung ist in wenigen Schritten erfasst. | A |
| NFA-04 | Zugriff nur nach Anmeldung; Rechte richten sich nach der Rolle. | A |
| NFA-05 | Es werden nur die notwendigen personenbezogenen Daten gespeichert (DSGVO). | A |
| NFA-06 | Quellcode versioniert im Git-Repository, nachvollziehbare Commits. | A |
| NFA-07 | Übersichten laden im Normalbetrieb in unter 2 Sekunden. | B |
| NFA-08 | Nutzbar auf Desktop und Smartphone (responsive Weboberfläche), als PWA auf dem Smartphone installierbar. | A |
| NFA-09 | Der Code ist kommentiert und dokumentiert, damit er weiterentwickelt werden kann. | B |
| NFA-10 | Neue Gerätetypen sind ohne Codeänderung anlegbar (Erweiterbarkeit). | C |
| NFA-11 | Die MQTT-Themenstruktur (Topics) und die Nutzdaten sind dokumentiert. | A |
| NFA-12 | Das Datenmodell ist dokumentiert (ER-Diagramm und Tabellenbeschreibung). | A |
| NFA-13 | Die dargestellten Informationen sind für die jeweilige Benutzergruppe verständlich und nützlich — nicht nur optisch ansprechend. | A |

### 3.3 Offene Punkte / zu klären

| Nr. | Frage | zu klären mit |
|-----|-------|---------------|
| OP-1 | ~~Steht reale Sensorik zur Verfügung, oder werden Sensordaten simuliert?~~ **Geklärt:** Simulation ist ausdrücklich zugelassen; Dummy-Daten sind sogar gefordert (FA-27). | erledigt |
| OP-2 | ~~Über welche Schnittstelle werden Sensordaten geliefert?~~ **Geklärt: MQTT** (FA-26). | erledigt |
| OP-3 | ~~Welche Rollen und Rechte sind tatsächlich gewünscht?~~ **Geklärt:** Lehrkraft (nur Aufträge stellen), Hausmeister*in (lesen + schreiben), Administration (alles), Schulleitung (Rechte legt das Team fest). Keine Schüler*innen. | erledigt |
| OP-4 | ~~Web-Anwendung oder App?~~ **Geklärt: Vue-Weboberfläche als PWA**, Benachrichtigung per Push und zusätzlich per E-Mail. | erledigt |
| OP-5 | ~~Ausführliche Projektbeschreibung von moodle nachtragen.~~ **Erledigt**, in Version 0.2 eingearbeitet. | erledigt |
| OP-6 | Konkrete Meilenstein-Termine. | Auftraggeber*in |
| OP-7 | Schnittstelle, Format und Zugang der **realen** Sensordaten. | Herr Hahn |
| OP-8 | Reale Raumdaten der Schule verwenden oder Beispielräume anlegen? | Auftraggeber*in |
| OP-9 | ~~Anmeldung über M365 / Schulmail?~~ **Geklärt:** Anmeldung frei wählbar, einfache eigene Anmeldung. | erledigt |
| OP-10 | ~~Was bedeutet „Daten auswerten"?~~ **Geklärt:** Statistiken (FA-13). | erledigt |

---

## 4 Weiteres Vorgehen (Ausblick Meilenstein 1)

- [ ] Teambeschreibung (Kapitel 1) ausfüllen
- [ ] Roh-GANTT-Diagramm der Projektphasen anlegen: *Was kommt wann und wer kümmert sich?*
- [ ] Offene Punkte aus 3.3 klären und Anforderungsliste nachschärfen
- [ ] Pflichtenheft von Grobform in Richtung Feinform ausbauen
