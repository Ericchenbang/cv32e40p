
`define ror64(SIG, R) {SIG[R-1:0],SIG[63:R]}

module cv32e40p_slh_alu_core 
  import cv32e40p_slh_pkg::*;
#(
    parameter SLH_ALU_CORE = 0
) (
    input        [ 1:0] operator_i,
    input logic  [63:0] operand_a_i,
    input logic  [63:0] operand_b_i,
    input logic  [63:0] operand_c_i,
    output logic [63:0] result_o
);

logic [63:0] rotated_result;
logic [63:0] xor_post_operand_a;
wire  [ 2:0] r4_imm   = operand_c_i[2:0];
wire  [63:0] xor_a_b  = operand_a_i        ^ operand_b_i;
wire  [63:0] and_a_b  = (~operand_a_i)     & operand_b_i;
wire  [63:0] xor_post = xor_post_operand_a ^ operand_c_i;

always_comb begin : rotation
  rotated_result = xor_a_b;

  case (operator_i)
  SLH_ALU_XORRV: begin
    rotated_result = `ror64(xor_a_b, 63);
  end
  SLH_ALU_RXORV: begin
    if (SLH_ALU_CORE==0) begin
      unique case (r4_imm) 
      3'd0:    rotated_result = xor_a_b;
      3'd1:    rotated_result = `ror64(xor_a_b, 1);
      3'd2:    rotated_result = `ror64(xor_a_b, 62);
      3'd3:    rotated_result = `ror64(xor_a_b, 28);
      default: rotated_result = `ror64(xor_a_b, 27);
      endcase
    end else if (SLH_ALU_CORE==1) begin
      unique case (r4_imm) 
      3'd0:    rotated_result = `ror64(xor_a_b, 36);
      3'd1:    rotated_result = `ror64(xor_a_b, 44);
      3'd2:    rotated_result = `ror64(xor_a_b, 6);
      3'd3:    rotated_result = `ror64(xor_a_b, 55);
      default: rotated_result = `ror64(xor_a_b, 20);
      endcase
    end else if (SLH_ALU_CORE==2) begin
      unique case (r4_imm) 
      3'd0:    rotated_result = `ror64(xor_a_b, 3);
      3'd1:    rotated_result = `ror64(xor_a_b, 10);
      3'd2:    rotated_result = `ror64(xor_a_b, 43);
      3'd3:    rotated_result = `ror64(xor_a_b, 25);
      default: rotated_result = `ror64(xor_a_b, 39);
      endcase
    end else if (SLH_ALU_CORE==3) begin
      unique case (r4_imm) 
      3'd0:    rotated_result = `ror64(xor_a_b, 41);
      3'd1:    rotated_result = `ror64(xor_a_b, 45);
      3'd2:    rotated_result = `ror64(xor_a_b, 15);
      3'd3:    rotated_result = `ror64(xor_a_b, 21);
      default: rotated_result = `ror64(xor_a_b, 8);
      endcase
    end else begin
      unique case (r4_imm) 
      3'd0:    rotated_result = `ror64(xor_a_b, 18);
      3'd1:    rotated_result = `ror64(xor_a_b, 2);
      3'd2:    rotated_result = `ror64(xor_a_b, 61);
      3'd3:    rotated_result = `ror64(xor_a_b, 56);
      default: rotated_result = `ror64(xor_a_b, 14);
      endcase
    end
  end
  endcase
end

always_comb begin
  if (operator_i==SLH_ALU_XORNAV)
    xor_post_operand_a = and_a_b;
  else
    xor_post_operand_a = xor_a_b;
end

always_comb begin
  case (operator_i)
  SLH_ALU_XOR3V:  result_o = xor_post;
  SLH_ALU_XORRV:  result_o = rotated_result;
  SLH_ALU_RXORV:  result_o = rotated_result;
  SLH_ALU_XORNAV: result_o = xor_post;
  default:        result_o = '0;
  endcase
end

endmodule
