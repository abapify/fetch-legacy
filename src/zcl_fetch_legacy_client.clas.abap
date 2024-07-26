class ZCL_FETCH_LEGACY_CLIENT definition
  public
  final
  create private

  global friends ZCL_FETCH_LEGACY_DELEGATE .

public section.

  interfaces ZIF_FETCH_CLIENT .
  interfaces ZIF_THROW .

  types HTTP_CLIENT_TYPE type ref to IF_HTTP_CLIENT .

  methods CONSTRUCTOR
    importing
      !HTTP_CLIENT type HTTP_CLIENT_TYPE .
protected section.
private section.

  aliases THROW
    for ZIF_THROW~THROW .

  data HTTP_CLIENT type HTTP_CLIENT_TYPE .
  data rest_client type ref to if_rest_client.
ENDCLASS.



CLASS ZCL_FETCH_LEGACY_CLIENT IMPLEMENTATION.


  method CONSTRUCTOR.
    assert http_client is bound.
    super->constructor( ).
    me->http_client = http_client.
    me->rest_client = new cl_rest_http_client( io_http_client = http_client ).

  endmethod.


  method ZIF_FETCH_CLIENT~FETCH.

    data(method) = me->http_client->request->get_method( ).

    " trigger HTTP method
    call method me->rest_client->(method).

    response = new zcl_fetch_legacy_response(
        rest_response = me->rest_client->get_response_entity( )
        http_response = me->http_client->response
    ).

    me->rest_client->close( ).

  endmethod.


  method ZIF_FETCH_CLIENT~REQUEST.
    result = new zcl_fetch_legacy_request( me->http_client->request ).
  endmethod.


  method ZIF_THROW~THROW.

     new zcl_throw( )->throw( message ).

  endmethod.
ENDCLASS.
