

module cv32e40p_slh_alu
  import cv32e40p_slh_pkg::*;
(
    input        [  1:0] operator_i,
    input logic  [319:0] operand_a_i,
    input logic  [319:0] operand_b_i,
    input logic  [319:0] operand_c_i,
    output logic [319:0] result_o
);

always_comb begin
    unique case (operator_i)
    default: begin
        result_o = operand_a_i ^ operand_b_i ^ operand_c_i;
    end
    endcase
end
endmodule
