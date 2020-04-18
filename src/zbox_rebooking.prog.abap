*&---------------------------------------------------------------------*
*& Report ZBOX_REBOOKING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbox_rebooking.

TABLES: zbox_master, zbox_delivery.

PARAMETERS: p_plant TYPE werks_d.
SELECT-OPTIONS: s_matnr FOR zbox_delivery-matnr,
  s_charg FOR zbox_delivery-charg.

TYPES: BEGIN OF lty_box,
  idx TYPE i,
  box_no TYPE zbox_no,
END OF lty_box.
DATA: boxes TYPE STANDARD TABLE OF zbox_delivery,
      lt_boxes  TYPE STANDARD TABLE OF lty_box.
CONTROLS: box_table_control TYPE TABLEVIEW USING SCREEN '0100'.

START-OF-SELECTION.

  SELECT * FROM zbox_delivery INTO TABLE boxes
    WHERE plant = p_plant AND matnr IN s_matnr AND charg IN s_charg.

  CALL SCREEN '0100'.

MODULE status_0100 OUTPUT.

  SET PF-STATUS 'MAIN'.

ENDMODULE.

MODULE on_box_no_changed INPUT.
  DATA: ls_box   TYPE zbox_delivery,
        ls_box1  TYPE lty_box,
        netw(10) TYPE p DECIMALS 2.

  READ TABLE boxes INTO ls_box INDEX box_table_control-current_line.
  ls_box1-box_no = ls_box-box_no.
  IF ls_box-box_no <> zbox_delivery-box_no.
    SELECT SINGLE * FROM zbox_master
      WHERE plant = ls_box-plant AND box_no = ls_box-box_no.
    netw = ls_box-gross_weight - zbox_master-tare.

    ls_box-box_no = zbox_delivery-box_no.
    SELECT SINGLE * FROM zbox_master
      WHERE plant = ls_box-plant AND box_no = ls_box-box_no.
    IF sy-subrc <> 0.
      MESSAGE e001(00) WITH 'Box no. not found'.
    ENDIF.

    ls_box-gross_weight = netw + zbox_master-tare.
    MODIFY boxes FROM ls_box INDEX box_table_control-current_line.

    READ TABLE lt_boxes TRANSPORTING NO FIELDS WITH KEY idx =  box_table_control-current_line.
    IF sy-subrc <> 0.
      ls_box1-idx = box_table_control-current_line.
      APPEND ls_box1 TO lt_boxes.
    ENDIF.

  ENDIF.

ENDMODULE.

MODULE user_command_0100 INPUT.
  DATA: lt_ubox TYPE STANDARD TABLE OF zbox_delivery,
        l_fm_name TYPE rs38l_fnam.

  CASE sy-ucomm.
    WHEN 'SAVE'.

      LOOP AT boxes INTO ls_box.

        READ TABLE lt_boxes INTO ls_box1 WITH KEY idx = sy-tabix.
        IF sy-subrc = 0.
          SELECT SINGLE * FROM zbox_delivery WHERE plant = ls_box-plant AND box_no = ls_box-box_no
            AND delivery_note_no <> ''.
          IF sy-subrc <> 0.

            UPDATE zbox_delivery SET box_no = ls_box-box_no gross_weight = ls_box-gross_weight
              WHERE plant = ls_box-plant
              AND box_no = ls_box1-box_no.
            APPEND ls_box TO lt_ubox.

          ELSE.
            MESSAGE e001(00) WITH |Box { ls_box-box_no } exists already|.
          ENDIF.
        ENDIF.

      ENDLOOP.

      IF lt_ubox IS NOT INITIAL.
        CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
          EXPORTING
            formname = 'ZBOX_LABEL'
          IMPORTING
            fm_name = l_fm_name.
        CALL FUNCTION l_fm_name
          TABLES
            boxes = lt_ubox.
      ENDIF.

    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'CANCEL'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.

ENDMODULE.
