*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class path definition.
  public section.
    types paths_tt type table of string with empty key.
    class-methods resolve
      importing
                paths         type paths_tt
                sep           type c default '/'
      returning value(result) type string.
    class-methods normalize
      importing path          type string
                sep           type c default '/'
      returning value(result) type string.
  private section.
    class-methods is_absolute
      importing
        i_path          type any
      returning
        value(r_result) type abap_bool.
endclass.

class path implementation.
  method resolve.

    data path type string.

    loop at paths into data(lv_path).
      if is_absolute( lv_path ).
        path = lv_path.
      else.
        path = |{ path }{ sep }{ lv_path }|.
      endif.
    endloop.

    result = normalize( path = path sep = sep ).

  endmethod.
  method normalize.

    data(is_absolute) = is_absolute( i_path = path ).

    split path at sep into table data(lt_parts).
    data lt_resolved_parts like lt_parts.

    " Resolve '.' and '..'
    loop at lt_parts into data(lv_part)
      where table_line is not initial and table_line ne '.'.
      if lv_part = '..'.
        delete lt_resolved_parts index sy-tabix - 1.
        delete lt_resolved_parts index sy-tabix.
        continue.
      else.
        append lv_part to lt_resolved_parts.
      endif.
    endloop.

    result = concat_lines_of( table = lt_resolved_parts sep = sep ).

    if is_absolute( i_path = path ).
      result = sep && result.
    endif.

  endmethod.

  method is_absolute.
    r_result = xsdbool( i_path cp '/*' ).
  endmethod.

endclass.
