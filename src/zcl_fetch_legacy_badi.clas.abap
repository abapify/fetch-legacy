class ZCL_FETCH_LEGACY_BADI definition
  public
  inheriting from ZCL_FETCH_BADI_BASE
  final
  create public .

public section.
protected section.

  methods DELEGATE
    redefinition .
  private section.

ENDCLASS.

CLASS ZCL_FETCH_LEGACY_BADI IMPLEMENTATION.

  method DELEGATE.
    result = new zcl_fetch_legacy_delegate( destination = destination ).
  endmethod.
ENDCLASS.
