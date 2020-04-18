*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 18.04.2020 at 08:30:45
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZBOX_DELIVERY...................................*
DATA:  BEGIN OF STATUS_ZBOX_DELIVERY                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBOX_DELIVERY                 .
CONTROLS: TCTRL_ZBOX_DELIVERY
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZBOX_MASTER.....................................*
DATA:  BEGIN OF STATUS_ZBOX_MASTER                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBOX_MASTER                   .
CONTROLS: TCTRL_ZBOX_MASTER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBOX_DELIVERY                 .
TABLES: *ZBOX_MASTER                   .
TABLES: ZBOX_DELIVERY                  .
TABLES: ZBOX_MASTER                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
