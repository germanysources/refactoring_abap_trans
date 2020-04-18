# Transaktionale ABAP-Applikationen refaktorisieren
Dies ist ein kleines Beispiel, wie transaktionale ABAP Applikationen
automatisiert getestet werden können und eine Herausforderung, die
Applikation zu refaktorisieren.

## Anwendungsfall
Gefüllte Behälter (Schüttgut), die an Kunden ausgeliefert werden sollen, werden in der
Tabelle `zbox_delivery` verwaltet. Jeder Behälter bekommt ein DIN-A5-Etikett mit Inhalt.
Wenn das Schüttgut in andere Behälter umgeleert wird, ändert der Report `zbox_rebooking` die Tabelle `zbox_delivery` entsprechend ab und druckt neue Etiketten.

## Automatisierte Tests
Um den Report `zbox_rebooking` automatisert zu testen, wurde dieser in den Report `zbox_rebooking_refactor` kopiert und um Meldungen, die die Kommunikation mit dem ECATT-Testskript `ZBOX_REBOOKING` ermöglichen, erweitert. Dieses Testskript
soll sowohl die ausgedruckten Etiketten als auch die Datenbankupdates prüfen.
Die Hilfsklasse `ZSPOOL_SNAPSHOTS` verifiziert den Etikettendruck mit Snapshots
der erstellen SAP-Spoolaufträge.

## Refaktisierungsherausforderung
Der Legacy Code ist unordentlich und enthält viele "Anti-Pattern".
Die Refaktorisierungsmaßnahmen haben folgende Zielsetzung:
- tell, don't ask
- nicht nur die Autoren sollen den Code verstehen
- Anti-Pattern wie Datendeklaration in Eingabemodulen, die nur augenscheinlich lokal definiert sind, sollen beseitigt werden
- Vergabe aussagekräftiger Namen (`ls_box1` oder ähnliches ist nicht sehr aussagekräftig)
- Eingabemodule sollen nur so wenig Anwendungslogik wie möglich enthalten
- Die Logik im Report `zbox_rebooking` soll nicht nur in der SAP-GUI Verwendung finden, sondern auch für Web-Services oder RFC-Applikationen.
- Tests sollen auch nach den Refaktorisierungsmaßnahmen erfolgreich durchlaufen (Die Tests im Skript `ZBOX_REBOOKING` sind noch unvollständig und sollten vor den Refaktorisierungsmaßnahmen erweitert werden).

Wenn du die Herausforderung annehmen willst, erstelle einen Pull-Request. Der Report `zbox_rebooking_refactor` soll als Ausgangspunkt dienen.

### Wie soll ich starten?
Wenn du dich nicht mit Refaktorisierungsmaßnahmen auskennst, kannst du einige Hinweise im Buch [Qualitätsmanagement in
der ABAP-Entwicklung](https://de.espresso-tutorials.com/programmierung_0393.php) finden oder mich kontaktieren:
- johannes.gerbershagen@kabelmail.de
- [jocder auf dem abapforum](https://www.abapforum.com/forum/memberlist.php?mode=viewprofile&u=20652)
- [SCN](https://people.sap.com/johannes_gerbershagen11)

## Abhängigkeiten
- [ABAP DB preperator](https://github.com/bunysae/abap_db_preparator) wird benötigt

## Installation
Für die Installation wird [abapGit](https://docs.abapgit.org) und mindestens SAP NetWeaver 7.40 benötigt.
