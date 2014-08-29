//========================================================================
// vc-preprocessor
//========================================================================
// Verilog preprocessor helper macros

`ifndef VC_PREPROCESSOR_V
`define VC_PREPROCESSOR_V

//------------------------------------------------------------------------
// VC_PREPROCESSOR_TOSTR
//------------------------------------------------------------------------

`define VC_PREPROCESSOR_TOSTR( expr_ ) \
  `"expr_`"

`endif /* VC_PREPROCESSOR_V */

