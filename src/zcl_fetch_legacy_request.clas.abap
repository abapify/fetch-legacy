class ZCL_FETCH_LEGACY_REQUEST definition
  public
  final
  create private

  global friends ZCL_FETCH_legacy_CLIENT .

public section.

  interfaces ZIF_FETCH_REQUEST_SETTER .
  interfaces ZIF_FETCH_REST_ENTITY.

    methods CONSTRUCTOR
    importing
      rest_entity like ZIF_FETCH_REST_ENTITY~rest_entity.
  protected section.
  private section.
    "data request type request_type.
    data method type string.
    aliases request for zif_fetch_rest_entity~rest_entity.
ENDCLASS.



CLASS ZCL_FETCH_LEGACY_REQUEST IMPLEMENTATION.


  method CONSTRUCTOR.
    assert rest_entity is bound.
    super->constructor( ).
    me->zif_fetch_rest_entity~rest_entity = rest_entity.
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~BODY.
    check body is not initial.
    me->request->set_binary_data( iv_data = body ).
  endmethod.

  method ZIF_FETCH_REQUEST_SETTER~HEADERS.

    loop at headers into data(ls_header).

        me->request->set_header_field(
          exporting
            iv_name  = ls_header-name    " Header Name
            iv_value = ls_header-value     " Header Value
        ).

    endloop.

  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~METHOD.
    me->method = method.
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~PATH.
    " set path
    if path is not initial.
      data(current_path) = request->get_header_field( '~request_uri' ).
      data(resolved_path) = path=>resolve(
              value #(
                  ( current_path )
                  ( path ) ) ).
      me->zif_fetch_request_setter~header(
        exporting
          name  = '~request_uri'
          value = path
      ).

    endif.
  endmethod.
  METHOD zif_fetch_request~path.

    result = me->zif_fetch_entity_readable~header(  '~request_uri' ).

  ENDMETHOD.

  METHOD zif_fetch_request~method.
    result = me->method.
  ENDMETHOD.

  METHOD zif_fetch_entity_readable~body.
    result = me->request->get_binary_data( ).
  ENDMETHOD.

  METHOD zif_fetch_entity_readable~text.
    result = me->request->get_string_data( ).
  ENDMETHOD.

  METHOD zif_fetch_entity_readable~headers.
    headers = corresponding #(  me->request->get_header_fields( ) ).
  ENDMETHOD.

  METHOD zif_fetch_entity_readable~header.
    value = me->request->get_header_field( name ).
  ENDMETHOD.

  METHOD zif_fetch_entity_writeable~text.
    me->request->set_string_data( iv_data = text ).
  ENDMETHOD.

  METHOD zif_fetch_entity_writeable~header.

    me->request->set_header_field(
      exporting
        iv_name  = name    " Name of the header field
        iv_value = value    " HTTP header field value
    ).

  ENDMETHOD.

ENDCLASS.
