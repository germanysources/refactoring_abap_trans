# Refactoring ABAP transactional applications
It's a short example how to put a legacy transactional ABAP application
under test and a challenge to refactor it.

## Translation
- [German](README_DE.md)

## Use case
Filled boxes, which should be delivered to the customer, are managed in table `zbox_delivery`.
Every box has a DIN-A5 label.
If the content is moved from one box to another, the report `zbox_rebooking` updates
the table `zbox_delivery` and prints new labels for the boxes.

## Put it under test
To test the report `zbox_rebooking`, it was copied in the report `zbox_rebooking_refactor` and a few messages to interact with the ECATT testscript `ZBOX_REBOOKING` were added. The testscript `ZBOX_REBOOKING` should verify, the labels are correctly printed and the database is updated correctly.
Snapshots from the SAP-spooljobs are created and
compared with a little snapshot utility in class `ZSPOOL_SNAPSHOTS`.

### Test preparation
Deactivate immediately print out
in your user profile. You avoid unnecessary print outs.

## Refactoring contest
The legacy code is quite messy with many anti-pattern.
The following refactoring targets are defined in this challenge:
- tell, don't ask
- not only the contributors should know what is going on
- remove anit-pattern like DATA-declarations, that just seem to be local, in input or output modules
- think of descriptive names (`ls_box1` or something like this isn't very descriptive)
- input modules should contain as less logic as possible
- the logic in report `zbox_rebooking` shouldn't be just accessed from the SAP-GUI. It should also be accessed within Web-Services or within RFC-programs.
- tests shouldn't break (Please note, that the tests in the script `ZBOX_REBOOKING` are incomplete and that you should add some more tests before starting the refactoring activities).

If you want to accept this challenge, please open a pull-request. You should use the report `zbox_rebooking_refactor` as a starting point.

### Don't know how to start?
If you don't know how to start with refactoring, you can find some hints in the book [Qualitätsmanagement in
der ABAP-Entwicklung](https://de.espresso-tutorials.com/programmierung_0393.php)
(german) or you can contact me for some hints on:
- johannes.gerbershagen@kabelmail.de
- [jocder auf dem abapforum](https://www.abapforum.com/forum/memberlist.php?mode=viewprofile&u=20652)
- [SCN](https://people.sap.com/johannes_gerbershagen11)

## Dependencies
- [ABAP DB preperator](https://github.com/bunysae/abap_db_preparator) is needed.

## Installation
Install via [abapGit](https://docs.abapgit.org). SAP NetWeaver 7.40 or above is needed.
