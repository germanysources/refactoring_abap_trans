class ZSPOOL_SNAPSHOTS definition
  public
  final
  create public .

public section.

  class-methods CREATE_SNAPSHOT
    importing
      !SPOOL_REQUEST_ID type RSPOID
      !SNAPSHOT_PACKAGE type DEVCLASS
      !SNAPSHOT_NAME type ETOBJ_NAME
      !SNAPSHOT_VERSION type ETOBJ_VER
      transport_request type e070-trkorr
    raising
      ZCX_SPOOL_REQUEST_ACCESS
      CX_ECATT_TDC_ACCESS .
  class-methods COMPARE_SNAPSHOT
    importing
      !SPOOL_REQUEST_ID type RSPOID
      !SNAPSHOT_NAME type ETOBJ_NAME
      !SNAPSHOT_VERSION type ETOBJ_VER
    raising
      ZCX_SPOOL_REQUEST_ACCESS
      CX_ECATT_TDC_ACCESS .
protected section.
private section.

  class-methods get_spool_request
    IMPORTING
      spool_request_id type rspoid
    EXPORTING
      otf_output type tsfotf
    raising
      zcx_spool_request_access.
  class-methods CREATE_OR_GET_TDC
    importing
      !SNAPSHOT_NAME type ETOBJ_NAME
      !SNAPSHOT_VERSION type ETOBJ_VER
      !SNAPSHOT_PACKAGE type DEVCLASS
      transport_request type e070-trkorr
    returning
      value(TDC_ACCESSOR) type ref to CL_APL_ECATT_TDC_API
    RAISING
      cx_ecatt_tdc_access.
ENDCLASS.



CLASS ZSPOOL_SNAPSHOTS IMPLEMENTATION.


  method COMPARE_SNAPSHOT.
    DATA: expected_output TYPE tsfotf.

    DATA(tdc_accessor) = cl_apl_ecatt_tdc_api=>get_instance(
      i_testdatacontainer = snapshot_name
      i_testdatacontainer_version = snapshot_version ).

    get_spool_request( EXPORTING spool_request_id = spool_request_id
      IMPORTING otf_output = DATA(spool_output) ).

    tdc_accessor->get_value( EXPORTING i_param_name = 'OTF_OUTPUT'
      i_variant_name = 'ECATTDEFAULT' CHANGING e_param_value = expected_output ).
    cl_abap_unit_assert=>assert_equals( exp = expected_output
      act = spool_output ).

  endmethod.


  method CREATE_OR_GET_TDC.

    TRY.
        tdc_accessor = cl_apl_ecatt_tdc_api=>get_instance(
          i_testdatacontainer = snapshot_name
          i_testdatacontainer_version = snapshot_version
          i_write_access = abap_true ).

      CATCH cx_ecatt_tdc_access.

        cl_apl_ecatt_tdc_api=>create_tdc( EXPORTING i_name = snapshot_name
          i_version = snapshot_version i_tadir_devclass = snapshot_package
          i_write_access = abap_true
          IMPORTING e_tdc_ref = tdc_accessor ).
        tdc_accessor->create_parameter( EXPORTING i_param_name = 'OTF_OUTPUT'
          i_param_def = 'TSFOTF' ).
        tdc_accessor->commit_changes( i_tr_order = transport_request ).

    ENDTRY.

  endmethod.


  METHOD create_snapshot.

    get_spool_request( EXPORTING spool_request_id = spool_request_id
      IMPORTING otf_output = DATA(spool_output) ).

    DATA(tdc_accessor) = create_or_get_tdc( snapshot_name = snapshot_name
      snapshot_version = snapshot_version snapshot_package = snapshot_package
      transport_request = transport_request ).
    tdc_accessor->set_value( i_param_name = 'OTF_OUTPUT'
      i_variant_name = 'ECATTDEFAULT' i_param_value = spool_output ).
    tdc_accessor->commit_changes( i_tr_order = transport_request ).

  ENDMETHOD.


  METHOD get_spool_request.

    CALL FUNCTION 'RSPO_RETURN_SPOOLJOB'
      EXPORTING
        rqident              = spool_request_id
        desired_type         = 'OTF'
      TABLES
        buffer               = otf_output
      EXCEPTIONS
        no_such_job          = 2
        job_contains_no_data = 4.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_spool_request_access.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
