//========================================================================
// ex-gcd-msgs : GCD Request/Response Messages
//========================================================================

`ifndef EX_GCD_MSGS_V
`define EX_GCD_MSGS_V

`include "vc-trace.v"

//------------------------------------------------------------------------
// GCD Request Message
//------------------------------------------------------------------------
// A GCD request message simply contains two 16b operands.
//
//   31       16 15        0
//  +-----------+-----------+
//  | operand a | operand b |
//  +-----------+-----------+
//

`define EX_GCD_REQ_MSG_A_NBITS 16
`define EX_GCD_REQ_MSG_B_NBITS 16

typedef struct packed {
  logic [`EX_GCD_REQ_MSG_A_NBITS-1:0] a;
  logic [`EX_GCD_REQ_MSG_B_NBITS-1:0] b;
} ex_gcd_req_msg_t;

//------------------------------------------------------------------------
// Trace request message
//------------------------------------------------------------------------
// We use this module to create a line trace for a request message being
// passed over a val/rdy interface, and to also enable us to easily see
// the fields in the message from gtkwave (i.e., we can just view the
// field variables within this module instance).

module ex_gcd_GcdReqMsgTrace
(
  input logic            clk,
  input logic            reset,
  input logic            val,
  input logic            rdy,
  input ex_gcd_req_msg_t msg

);

  // Extract fields

  logic [`EX_GCD_REQ_MSG_A_NBITS-1:0] a;
  logic [`EX_GCD_REQ_MSG_B_NBITS-1:0] b;

  assign a = msg.a;
  assign b = msg.b;

  // Line tracing

  `ifndef SYNTHESIS

  localparam c_msg_nbits = $bits(ex_gcd_req_msg_t);
  logic [(`VC_TRACE_NBITS_TO_NCHARS(c_msg_nbits)+1)*8-1:0] str;

  `VC_TRACE_BEGIN
  begin
    $sformat( str, "%x:%x", msg.a, msg.b );
    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );
  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

//------------------------------------------------------------------------
// GCD Response Message
//------------------------------------------------------------------------
// A GCD response message is just a single 16b bit vector. Using a struct
// is probably overkill here since there is only a single field, but it
// helps maintain the idea that we often use structs to create message
// types.
//
//   15        0
//  +-----------+
//  | result    |
//  +-----------+
//

`define EX_GCD_RESP_MSG_RESULT_NBITS 16

typedef struct packed {
  logic [`EX_GCD_RESP_MSG_RESULT_NBITS-1:0] result;
} ex_gcd_resp_msg_t;

`endif /* EX_GCD_MSGS_V */

