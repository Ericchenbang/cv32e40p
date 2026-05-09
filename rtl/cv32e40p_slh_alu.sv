

module cv32e40p_slh_alu
  import cv32e40p_slh_pkg::*;
(
  input        [  1:0] operator_i,
  input logic  [319:0] operand_a_i,
  input logic  [319:0] operand_b_i,
  input logic  [319:0] operand_c_i,
  output logic [319:0] result_o
);

wire [2:0] r4_imm = operand_c_i[2:0];

logic [63:0] core_op_a_0;
logic [63:0] core_op_b_0;
logic [63:0] core_op_c_0;
logic [63:0] core_result_0;
logic [63:0] core_op_a_1;
logic [63:0] core_op_b_1;
logic [63:0] core_op_c_1;
logic [63:0] core_result_1;
logic [63:0] core_op_a_2;
logic [63:0] core_op_b_2;
logic [63:0] core_op_c_2;
logic [63:0] core_result_2;
logic [63:0] core_op_a_3;
logic [63:0] core_op_b_3;
logic [63:0] core_op_c_3;
logic [63:0] core_result_3;
logic [63:0] core_op_a_4;
logic [63:0] core_op_b_4;
logic [63:0] core_op_c_4;
logic [63:0] core_result_4;

always_comb begin : pre_proc
  {core_op_a_4, core_op_a_3, core_op_a_2, core_op_a_1, core_op_a_0} = operand_a_i;
  {core_op_b_4, core_op_b_3, core_op_b_2, core_op_b_1, core_op_b_0} = operand_b_i;
  {core_op_c_4, core_op_c_3, core_op_c_2, core_op_c_1, core_op_c_0} = operand_c_i;

  case (operator_i)
  SLH_ALU_XORRV: begin
    core_op_a_0 = operand_a_i[127: 64];
    core_op_c_0 = operand_a_i[319:256];
    core_op_a_1 = operand_a_i[191:128];
    core_op_c_1 = operand_a_i[ 63:  0];
    core_op_a_2 = operand_a_i[255:192];
    core_op_c_2 = operand_a_i[127: 64];
    core_op_a_3 = operand_a_i[319:256];
    core_op_c_3 = operand_a_i[191:128];
    core_op_a_4 = operand_a_i[ 63:  0];
    core_op_c_4 = operand_a_i[255:192];
    {core_op_b_0, core_op_b_1, core_op_b_2, core_op_b_3, core_op_b_4} = '0;
  end
  SLH_ALU_RXORV: begin
    core_op_c_0[2:0] = r4_imm;
    core_op_c_1[2:0] = r4_imm;
    core_op_c_2[2:0] = r4_imm;
    core_op_c_3[2:0] = r4_imm;
    core_op_c_4[2:0] = r4_imm;
  end
  endcase
end

always_comb begin : post_proc
  result_o = {core_result_4, core_result_3, core_result_2, core_result_1, core_result_0};
  case (operator_i)
  SLH_ALU_RXORV: begin
    unique case (r4_imm) 
      3'd0:    result_o = {core_result_2, core_result_4, core_result_1, core_result_3, core_result_0};
      3'd1:    result_o = {core_result_3, core_result_0, core_result_2, core_result_4, core_result_1};
      3'd2:    result_o = {core_result_4, core_result_1, core_result_3, core_result_0, core_result_2};
      3'd3:    result_o = {core_result_0, core_result_2, core_result_4, core_result_1, core_result_3};
      default: result_o = {core_result_1, core_result_3, core_result_0, core_result_2, core_result_4};
    endcase
  end
  endcase
end

cv32e40p_slh_alu_core #(
  .SLH_ALU_CORE(0)
  ) cv32e40p_slh_alu_core_i_0 (
	.operator_i (operator_i   ),
	.operand_a_i(core_op_a_0  ),
	.operand_b_i(core_op_b_0  ),
	.operand_c_i(core_op_c_0  ),
	.result_o   (core_result_0)
);
cv32e40p_slh_alu_core #(
  .SLH_ALU_CORE(1)
  ) cv32e40p_slh_alu_core_i_1 (
	.operator_i (operator_i   ),
	.operand_a_i(core_op_a_1  ),
	.operand_b_i(core_op_b_1  ),
	.operand_c_i(core_op_c_1  ),
	.result_o   (core_result_1)
);
cv32e40p_slh_alu_core #(
  .SLH_ALU_CORE(2)
  ) cv32e40p_slh_alu_core_i_2 (
	.operator_i (operator_i   ),
	.operand_a_i(core_op_a_2  ),
	.operand_b_i(core_op_b_2  ),
	.operand_c_i(core_op_c_2  ),
	.result_o   (core_result_2)
);
cv32e40p_slh_alu_core #(
  .SLH_ALU_CORE(3)
  ) cv32e40p_slh_alu_core_i_3 (
	.operator_i (operator_i   ),
	.operand_a_i(core_op_a_3  ),
	.operand_b_i(core_op_b_3  ),
	.operand_c_i(core_op_c_3  ),
	.result_o   (core_result_3)
);
cv32e40p_slh_alu_core #(
  .SLH_ALU_CORE(4)
  ) cv32e40p_slh_alu_core_i_4 (
	.operator_i (operator_i   ),
	.operand_a_i(core_op_a_4  ),
	.operand_b_i(core_op_b_4  ),
	.operand_c_i(core_op_c_4  ),
	.result_o   (core_result_4)
);
endmodule
