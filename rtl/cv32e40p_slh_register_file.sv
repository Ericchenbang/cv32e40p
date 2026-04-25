module cv32e40p_slh_register_file #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 320
) (
    // Clock and Reset
    input logic clk,
    input logic rst_n,

    //Read port V1
    input  logic [ADDR_WIDTH-1:0] vaddr_a_i,
    output logic [DATA_WIDTH-1:0] vdata_a_o,

    //Read port V2
    input  logic [ADDR_WIDTH-1:0] vaddr_b_i,
    output logic [DATA_WIDTH-1:0] vdata_b_o,

    //Read port V3
    input  logic [ADDR_WIDTH-1:0] vaddr_c_i,
    output logic [DATA_WIDTH-1:0] vdata_c_o,

    // Write port W1
    input logic [ADDR_WIDTH-1:0] waddr_a_i,
    input logic [DATA_WIDTH-1:0] wdata_a_i,
    input logic                  we_a_i,

    // Write port W2
    input logic [ADDR_WIDTH-1:0] waddr_b_i,
    input logic [DATA_WIDTH-1:0] wdata_b_i,
    input logic                  we_b_i
);

  // number of vector registers
  localparam NUM_VECTORS = 16;

  // vector register file
  logic [NUM_VECTORS-1:0][DATA_WIDTH-1:0] mem;

  // write enable signals for all registers
  logic [NUM_VECTORS-1:0]                 we_a_dec;
  logic [NUM_VECTORS-1:0]                 we_b_dec;


  //-----------------------------------------------------------------------------
  //-- READ : Read address decoder RAD
  //-----------------------------------------------------------------------------
  assign vdata_a_o = mem[vaddr_a_i];
  assign vdata_b_o = mem[vaddr_b_i];
  assign vdata_c_o = mem[vaddr_c_i];

  //-----------------------------------------------------------------------------
  //-- WRITE : Write Address Decoder (WAD), combinatorial process
  //-----------------------------------------------------------------------------


  genvar gidx;
  generate
    for (gidx = 0; gidx < NUM_VECTORS; gidx++) begin : gen_we_decoder
      assign we_a_dec[gidx] = (waddr_a_i == gidx) ? we_a_i : 1'b0;
      assign we_b_dec[gidx] = (waddr_b_i == gidx) ? we_b_i : 1'b0;
    end
  endgenerate

  genvar i, l;
  generate

    //-----------------------------------------------------------------------------
    //-- WRITE : Write operation
    //-----------------------------------------------------------------------------
    // loop from 0 to NUM_VECTORS-1
    for (i = 0; i < NUM_VECTORS; i++) begin : gen_slh_rf

      always_ff @(posedge clk, negedge rst_n) begin : register_write_behavioral
        if (rst_n == 1'b0) begin
          mem[i] <= 32'b0;
        end else begin
          if (we_b_dec[i] == 1'b1) mem[i] <= wdata_b_i;
          else if (we_a_dec[i] == 1'b1) mem[i] <= wdata_a_i;
        end
      end

    end

  endgenerate

endmodule
