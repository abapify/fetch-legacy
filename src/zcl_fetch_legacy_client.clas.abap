class zcl_fetch_legacy_client definition
  public
  final
  create private

  global friends zcl_fetch_legacy_delegate .

  public section.

    interfaces zif_fetch_client .
    interfaces zif_throw .

    types http_client_type type ref to if_http_client .

    methods constructor
      importing
        !http_client type http_client_type .
  protected section.
  private section.

    aliases throw
      for zif_throw~throw .

    data http_client type http_client_type .
    data rest_client type ref to if_rest_client.
endclass.



class zcl_fetch_legacy_client implementation.


  method constructor.
    assert http_client is bound.
    super->constructor( ).
    me->http_client = http_client.
    me->rest_client = new cl_rest_http_client( io_http_client = http_client ).

  endmethod.


  method zif_fetch_client~fetch.

    data(method) = me->http_client->request->get_method( ).

    data(app) = me->rest_client.

    " trigger HTTP method
    case request->method( ).
      when 'HEAD'.
        app->head( ).
      when 'GET'.
        app->get( ).
      when 'DELETE'.
        app->delete( ).
      when 'OPTIONS'.
        app->options( ).
      when 'POST'.
        app->post( io_entity = cast zif_fetch_rest_entity(  request )->rest_entity ).
      when 'PUT'.
        app->put( io_entity = cast zif_fetch_rest_entity(  request )->rest_entity ).
    endcase.

    response = new zcl_fetch_legacy_response(
        rest_response = me->rest_client->get_response_entity( )
        http_response = me->http_client->response
    ).

    me->rest_client->close( ).

  endmethod.


  method zif_fetch_client~request.

    data(lo_rest_request) = me->rest_client->create_request_entity( ).

    result = new zcl_fetch_legacy_request( lo_rest_request ).

    raise event zif_fetch_client~request_created
      exporting
        request =  result
    .
  endmethod.


  method zif_throw~throw.

    new zcl_throw( )->throw( message ).

  endmethod.
endclass.
