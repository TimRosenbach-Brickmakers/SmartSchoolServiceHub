# GANTT-Diagramm (Roh-Planung)

## Projekt „Smart School Service Hub"

**Stand:** 02.10.2026 · **Version:** 0.1 · **Bezug:** [02_Pflichtenheft.md](02_Pflichtenheft.md),
[03_Umsetzungskonzept.md](03_Umsetzungskonzept.md) (Kap. 14 Umsetzungsreihenfolge)

> **Roh-GANTT für Meilenstein 1.** Die Aufgabenstellung verlangt: *„Was kommt wann und wer
> kümmert sich?"* Die Termine sind eine **grobe Vorhersage**. Offizielle Meilenstein-Termine
> stehen noch aus (OP-6), ebenso die Ferien. Beides wird nachgetragen, sobald es bekannt
> ist. Alle Daten nach dem 09.10.2026 sind **Annahmen**.

---

## 1 Diagramm

Als Bild für die Abgabe: [04_GANTT.png](04_GANTT.png)

```mermaid
gantt
    title Smart School Service Hub – Projektphasen
    dateFormat YYYY-MM-DD
    axisFormat %d.%m.
    tickInterval 1week
    weekday monday
    todayMarker on

    section 1 Projektmanagement (M1)
    Projektteams bilden (alle)                       :done,   t11, 2026-09-02, 2026-09-04
    Projektauftrag erstellen (PL)                    :done,   t12, 2026-09-03, 2026-09-11
    Anforderungsliste + Vorpriorisierung (alle)      :done,   t13, 2026-09-07, 2026-09-18
    Pflichtenheft Grobform (Doku)                    :done,   t14, 2026-09-09, 2026-09-25
    Umsetzungskonzept (alle)                         :done,   t15, 2026-09-14, 2026-10-01
    Klärung mit Auftraggeber                         :milestone, done, m0, 2026-09-30, 0d
    Roh-GANTT anlegen (PL)                           :active, t16, 2026-10-01, 2026-10-07
    Meilenstein 1 – Abgabe                           :milestone, crit, m1, 2026-10-09, 0d

    section 2 Feinkonzept
    Reale Sensordaten mit Herrn Hahn klären (PL, BE) :t21, 2026-10-05, 2026-10-16
    Datenbedarf mit Datenanalyse abstimmen (PL, DB)  :t22, 2026-10-05, 2026-10-16
    Datenmodell + ER-Diagramm (DB)                   :crit, t23, 2026-10-12, 2026-10-23
    MQTT-Topics + Beispiel-JSON (BE)                 :t24, 2026-10-12, 2026-10-20
    GUI-Entwürfe / Wireframes (FE)                   :t25, 2026-10-12, 2026-10-27
    REST-API-Entwurf (BE)                            :t26, 2026-10-19, 2026-10-27
    Pflichtenheft Feinform (Doku)                    :t27, 2026-10-19, 2026-10-30
    Entwicklungsumgebung + Repo-Struktur (alle)      :t28, 2026-10-26, 2026-10-30
    Meilenstein 2 – Feinkonzept                      :milestone, m2, 2026-10-30, 0d

    section 3 Umsetzung Kern
    MySQL anlegen + Stammdaten (DB)                  :crit, t31, 2026-11-02, 2026-11-06
    Login + vier Rollen (BE)                         :crit, t32, 2026-11-02, 2026-11-10
    Vue-Grundgerüst, Login, Baum (FE)                :t33, 2026-11-04, 2026-11-17
    Stammdaten-CRUD + Baum-API (BE)                  :t34, 2026-11-09, 2026-11-17
    MQTT-Broker + Simulator (BE)                     :t35, 2026-11-09, 2026-11-20
    Aufträge anlegen + auflisten (BE, FE)            :crit, t36, 2026-11-16, 2026-11-27
    KI-Mock-Daten + Import-Skript (DB)               :t37, 2026-11-16, 2026-11-24
    Statusberechnung im Baum (BE)                    :t38, 2026-11-23, 2026-11-27

    section 4 Mindestanforderungen
    Raumdetailansicht, rollenabhängig (FE)           :crit, t41, 2026-11-30, 2026-12-08
    Dashboard (FE, BE)                               :crit, t42, 2026-11-30, 2026-12-11
    Regeln, Warnungen, Offline-Erkennung (BE)        :t43, 2026-12-07, 2026-12-15
    JSON-Export + OpenAPI-Doku (BE)                  :crit, t44, 2026-12-07, 2026-12-11
    E-Mail bei Statusänderung (BE)                   :t45, 2026-12-14, 2026-12-18
    Meilenstein 3 – Zwischenstand                    :milestone, crit, m3, 2026-12-18, 0d

    section 5 Ausbau
    PWA + Web Push (FE, BE)                          :t51, 2027-01-04, 2027-01-12
    Wartung (BE, FE)                                 :t52, 2027-01-04, 2027-01-08
    Verwaltung + Nutzerverwaltung (FE)               :t53, 2027-01-06, 2027-01-14
    Statistiken (BE, FE)                             :t54, 2027-01-11, 2027-01-19
    Feature-Freeze                                   :milestone, m4, 2027-01-19, 0d

    section 6 Test und Doku
    Tests + Testdokumentation (QS)                   :t61, 2027-01-11, 2027-01-22
    Benutzerdokumentation (Doku)                     :t62, 2027-01-13, 2027-01-22
    Bugfixing (alle)                                 :t63, 2027-01-19, 2027-01-26

    section 7 Abschluss
    Abschlusspräsentation vorbereiten (alle)         :t71, 2027-01-20, 2027-01-28
    Reflexion der Projektarbeit (alle)               :t72, 2027-01-25, 2027-01-28
    Abgabe + Präsentation                            :milestone, crit, m5, 2027-01-29, 0d
```

**Legende:** grau = erledigt · hervorgehoben = in Arbeit · rot = kritischer Pfad bzw.
Mindestanforderung der Aufgabenstellung · Raute = Meilenstein

---

## 2 Wer kümmert sich?

Im Diagramm stehen **Rollen** statt Namen, weil die Teambeschreibung (Pflichtenheft
Kap. 1) noch aussteht. Sobald sie steht, hier die Namen eintragen:

| Kürzel | Rolle | Verantwortlich für | Name |
|--------|-------|--------------------|------|
| PL | Projektleitung | Planung, Termine, Abstimmung mit Auftraggeber, Herrn Hahn und der Datenanalyse | _[eintragen]_ |
| FE | Frontend | Vue, PWA, Screens, Diagramme | _[eintragen]_ |
| BE | Backend | C#-API, MQTT-Worker, Regeln, E-Mail/Push | _[eintragen]_ |
| DB | Datenbank | MySQL-Datenmodell, ER-Diagramm, Mock-Daten, Export | _[eintragen]_ |
| QS / Doku | Qualitätssicherung + Dokumentation | Pflichtenheft, Tests, Benutzerdokumentation | _[eintragen]_ |

---

## 3 Phasen und Bezug zum Pflichtenheft

| Phase | Zeitraum *(Annahme)* | Ergebnis | Anforderungen |
|-------|----------------------|----------|---------------|
| 1 Projektmanagement | 02.09. – 09.10.2026 | Projektauftrag, Anforderungsliste, Pflichtenheft (Grobform), Roh-GANTT | Meilenstein 1 |
| 2 Feinkonzept | 05.10. – 30.10.2026 | ER-Diagramm, MQTT-Topics, API-Entwurf, Wireframes, Pflichtenheft (Feinform) | NFA-02, NFA-11, NFA-12, FA-33 |
| 3 Umsetzung Kern | 02.11. – 27.11.2026 | Login, Baum, Aufträge, Sensordaten fließen | FA-01 – FA-08, FA-22 – FA-27, FA-36 |
| 4 Mindestanforderungen | 30.11. – 18.12.2026 | **alle Mindestanforderungen** lauffähig | FA-11, FA-16, FA-28, FA-29, FA-32, FA-35 |
| 5 Ausbau | 04.01. – 19.01.2027 | PWA/Push, Wartung, Verwaltung, Statistiken | FA-13, FA-30, FA-34, NFA-08 |
| 6 Test und Doku | 11.01. – 26.01.2027 | Testdokumentation, Benutzerdokumentation | Projektergebnisse |
| 7 Abschluss | 20.01. – 29.01.2027 | Abschlusspräsentation, Reflexion | Projektergebnisse |

**Planungslogik:**

- **Kritischer Pfad:** Datenmodell → Datenbank → Login/Rollen → Aufträge →
  Raumdetail/Dashboard. Verzögert sich einer dieser Schritte, verschiebt sich der
  Zwischenstand.
- **Meilenstein 3 vor den Weihnachtsferien:** Bis dahin sollen alle Mindestanforderungen
  der Aufgabenstellung erfüllt sein (Umsetzungskonzept Kap. 13). Alles danach ist Ausbau
  und Puffer.
- **Frühe Abstimmungen:** Mit Herrn Hahn (reale Sensordaten) und mit der Daten- und
  Prozessanalyse (Datenbedarf) wird **vor** dem Datenmodell gesprochen. Nachträgliche
  Felder bedeuten Migration und neue Mock-Daten.
- **Parallel arbeiten:** Frontend und Backend laufen ab Phase 3 parallel. Das Frontend
  kann mit Beispiel-JSON arbeiten, bis die API steht.

## 4 Offen

- Offizielle Meilenstein-Termine des Auftraggebers (OP-6). Die Termine für M2, M3 und die
  Abgabe sind geschätzt.
- Herbst- und Weihnachtsferien eintragen. Bisher ist nur angenommen, dass zwischen dem
  18.12.2026 und dem 04.01.2027 nicht gearbeitet wird.
- Namen in Kapitel 2 eintragen, sobald die Teambeschreibung steht.
