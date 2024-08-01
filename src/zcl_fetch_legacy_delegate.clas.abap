class ZCL_FETCH_LEGACY_DELEGATE definition
  public
  inheriting from ZCL_FETCH_DELEGATE
  final
  create private

  global friends ZCL_FETCH_legacy_BADI .

public section.

  methods client redefinition.

  protected section.

  private section.

ENDCLASS.



CLASS ZCL_FETCH_LEGACY_DELEGATE IMPLEMENTATION.


  method CLIENT.

    case destination->type.

      when zif_fetch_destination_types=>destination_types-url.

        data(lo_url_dest) = cast zif_fetch_destination_url( destination ).

        cl_http_client=>create_by_url(
          exporting
            url                = lo_url_dest->url    " URL
            "ssl_id = 'ANONYM'
          importing
            client             = data(http_client)    " HTTP Client Abstraction
          exceptions
            argument_not_found = 1
            plugin_not_active  = 2
            internal_error     = 3
            others             = 4
        ).
        if sy-subrc <> 0.
          throw( ).
        endif.

      when zif_fetch_destination_types=>destination_types-rfc.

        data(lo_rfc_dest) = cast zif_fetch_destination_rfc( destination ).

        cl_http_client=>create_by_destination(
          exporting
            destination              = lo_rfc_dest->destination    " Logical destination (specified in function call)
          importing
            client                   = http_client    " HTTP Client Abstraction
          exceptions
            argument_not_found       = 1
            destination_not_found    = 2
            destination_no_authority = 3
            plugin_not_active        = 4
            internal_error           = 5
            others                   = 6
        ).
        if sy-subrc <> 0.
          throw( ).
        endif.

      when others.
        throw( 'Not supported destination type' ).
    endcase.

    result = new zcl_fetch_legacy_client( http_client = http_client ).
  endmethod.
ENDCLASS.
