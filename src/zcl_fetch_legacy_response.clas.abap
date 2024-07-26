class ZCL_FETCH_LEGACY_RESPONSE definition
  public
  final
  create private

  global friends ZCL_FETCH_legacy_CLIENT .

public section.

  interfaces ZIF_FETCH_ENTITY .
  interfaces ZIF_FETCH_RESPONSE .

  types rest_response_type type ref to if_rest_entity.
  types http_response_type type ref to if_http_response.

  methods CONSTRUCTOR
    importing
      !rest_response type rest_response_type
      !http_response type http_response_type.

protected section.
  private section.

    data cached_response type ref to if_rest_entity.
    data status type i.
    data reason type string.

ENDCLASS.



CLASS ZCL_FETCH_LEGACY_RESPONSE IMPLEMENTATION.


  method CONSTRUCTOR.

    assert rest_response is bound.
    assert http_response is bound.

    super->constructor( ).

    me->cached_response = new cl_rest_entity(
        it_header_fields = rest_response->get_header_fields( )
        iv_message_body  = rest_response->get_binary_data( )
    ).

    http_response->get_status(
      importing
        code   = me->status     " HTTP status code
        reason = me->reason    " HTTP status description
    ).

  endmethod.


  method ZIF_FETCH_RESPONSE~BODY.
    result = me->cached_response->get_binary_data( ).
  endmethod.


  method ZIF_FETCH_RESPONSE~HEADER.
    value = me->cached_response->get_header_field( iv_name = name ).
  endmethod.


  method ZIF_FETCH_RESPONSE~HEADERS.
    headers = corresponding #( me->cached_response->get_header_fields( ) ).
  endmethod.


  method ZIF_FETCH_RESPONSE~STATUS.
    result = me->status.
  endmethod.


  method ZIF_FETCH_RESPONSE~STATUS_TEXT.
    result = me->reason.
  endmethod.


  method ZIF_FETCH_RESPONSE~TEXT.
    result = me->cached_response->get_string_data( ).
  endmethod.
ENDCLASS.
