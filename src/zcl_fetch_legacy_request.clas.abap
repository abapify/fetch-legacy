class ZCL_FETCH_LEGACY_REQUEST definition
  public
  final
  create private

  global friends ZCL_FETCH_legacy_CLIENT .

public section.

  interfaces ZIF_FETCH_ENTITY .
  interfaces ZIF_FETCH_REQUEST .
  interfaces ZIF_FETCH_REQUEST_SETTER .

  types http_request_type type ref to IF_HTTP_REQUEST.
  methods CONSTRUCTOR
    importing
      !HTTP_REQUEST type http_request_type.
  protected section.
  private section.
    data http_request type http_request_type.
ENDCLASS.



CLASS ZCL_FETCH_LEGACY_REQUEST IMPLEMENTATION.


  method CONSTRUCTOR.
    assert http_request is bound.
    super->constructor( ).
    me->http_request = http_request.
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~BODY.
    check body is not initial.
    me->http_request->set_data( body ).
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~DESTINATION.
    " do nothing here
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~HEADERS.

    loop at headers into data(ls_header).

      me->http_request->set_header_field(
        exporting
          name  = ls_header-name    " Name of the header field
          value = ls_header-value    " HTTP header field value
      ).

    endloop.

  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~METHOD.
    me->zif_fetch_request~method = method.
    me->http_request->set_method( method ).
  endmethod.


  method ZIF_FETCH_REQUEST_SETTER~PATH.
    " set path
    if path is not initial.
      data(current_path) = http_request->get_header_field( '~request_uri' ).
      data(resolved_path) = path=>resolve(
              value #(
                  ( current_path )
                  ( path ) ) ).
      http_request->set_header_field(
        exporting
          name  = '~request_uri'    " Name of the header field
          value = resolved_path    " HTTP header field value
      ).

    endif.
  endmethod.
ENDCLASS.
