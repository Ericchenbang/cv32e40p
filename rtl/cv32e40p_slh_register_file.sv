module cv32e40p_slh_register_file #(
    parameter ADDR_WIDTH     = 5,
    parameter ELEMENTS_WIDTH = 64,
    parameter VECTORS_WIDTH  = 5
) (
    // Clock and Reset
    input logic clk,
    input logic rst_n,

    //Read port V1
    input  logic [ADDR_WIDTH-1:0]                     vaddr_a_i,
    output logic [(ELEMENTS_WIDTH*VECTORS_WIDTH)-1:0] vdata_a_o,

    //Read port V2
    input  logic [ADDR_WIDTH-1:0]                     vaddr_b_i,
    output logic [(ELEMENTS_WIDTH*VECTORS_WIDTH)-1:0] vdata_b_o,

    //Read port V3
    input  logic [ADDR_WIDTH-1:0]                     vaddr_c_i,
    output logic [(ELEMENTS_WIDTH*VECTORS_WIDTH)-1:0] vdata_c_o,

    // Write port W1
    input logic [ADDR_WIDTH-1:0]                     waddr_a_i,
    input logic [(ELEMENTS_WIDTH*VECTORS_WIDTH)-1:0] wdata_a_i,
    input logic                                      we_a_i,

    // Write port W2
    input logic [ADDR_WIDTH-1:0]                     waddr_b_i,
    input logic [(ELEMENTS_WIDTH*VECTORS_WIDTH)-1:0] wdata_b_i,
    input logic                                      we_b_i
);
  localparam NUM_VECTORS = 2**(ADDR_WIDTH-1);

  // vector register file
  logic [ELEMENTS_WIDTH-1:0] mem [NUM_VECTORS-1:0][VECTORS_WIDTH-1:0];

  // write enable signals for all registers
  logic [VECTORS_WIDTH-1:0]  we_a_dec [NUM_VECTORS-1:0];
  logic [VECTORS_WIDTH-1:0]  we_b_dec [NUM_VECTORS-1:0];

  genvar i, j;
  //-----------------------------------------------------------------------------
  //-- READ : Read address decoder RAD
  //-----------------------------------------------------------------------------
  logic [ELEMENTS_WIDTH-1:0] vdata_a [NUM_VECTORS-1:0];
  logic [ELEMENTS_WIDTH-1:0] vdata_b [NUM_VECTORS-1:0];
  logic [ELEMENTS_WIDTH-1:0] vdata_c [NUM_VECTORS-1:0]; 

  assign vdata_a_o = {vdata_a[4],vdata_a[3],vdata_a[2],vdata_a[1],vdata_a[0]};
  assign vdata_b_o = {vdata_b[4],vdata_b[3],vdata_b[2],vdata_b[1],vdata_b[0]};
  assign vdata_c_o = {vdata_c[4],vdata_c[3],vdata_c[2],vdata_c[1],vdata_c[0]};  
  
  generate
  for (i=0; i<VECTORS_WIDTH; i++) begin: gen_read_bus
    always_comb begin
      vdata_a[i] = vaddr_a_i[ADDR_WIDTH-1] ? '0:mem[vaddr_a_i][i];
      vdata_b[i] = vaddr_b_i[ADDR_WIDTH-1] ? '0:mem[vaddr_b_i][i];
      vdata_c[i] = vaddr_c_i[ADDR_WIDTH-1] ? '0:mem[vaddr_c_i][i];
  end
  end
  endgenerate

  //-----------------------------------------------------------------------------
  //-- WRITE : Write Address Decoder (WAD), combinatorial process
  //-----------------------------------------------------------------------------
  generate
    for (i = 0; i<NUM_VECTORS; i++) begin : gen_we_decoder
      for (j=0; j<VECTORS_WIDTH; j++) begin
        if (i<VECTORS_WIDTH)
          always_comb begin
            we_a_dec[i][j] = ((waddr_a_i == i) || (waddr_a_i == NUM_VECTORS+j)) ? we_a_i : 1'b0;
            we_b_dec[i][j] = ((waddr_b_i == i) || (waddr_b_i == NUM_VECTORS+j)) ? we_b_i : 1'b0;
          end
        else
          always_comb begin
            we_a_dec[i][j] = (waddr_a_i == i) ? we_a_i : 1'b0;
            we_b_dec[i][j] = (waddr_b_i == i) ? we_b_i : 1'b0;
          end
      end
    end
  endgenerate

  //-----------------------------------------------------------------------------
  //-- WRITE : Write operation
  //-----------------------------------------------------------------------------
  generate
    for (i = 0; i < NUM_VECTORS; i++) begin : gen_slh_rf
      for (j = 0; j < VECTORS_WIDTH; j++) begin
        if (i < VECTORS_WIDTH)
          always_ff @(posedge clk, negedge rst_n) begin : transpose_register_write_behavioral
            if (rst_n == 1'b0) begin
              mem[i][j] <= '0;
            end else begin
              if (we_b_dec[i][j])      mem[i][j] <= waddr_b_i[ADDR_WIDTH-1] ? wdata_b_i[((i+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH]:wdata_b_i[((j+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH];
              else if (we_a_dec[i][j]) mem[i][j] <= waddr_a_i[ADDR_WIDTH-1] ? wdata_a_i[((i+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH]:wdata_a_i[((j+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH];
            end
          end
        else
          always_ff @(posedge clk, negedge rst_n) begin : register_write_behavioral
            if (rst_n == 1'b0) begin
              mem[i][j] <= '0;
            end else begin
              if (we_b_dec[i][j])      mem[i][j] <= wdata_b_i[((j+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH];
              else if (we_a_dec[i][j]) mem[i][j] <= wdata_a_i[((j+1)*ELEMENTS_WIDTH)-1 -:ELEMENTS_WIDTH];
            end
          end
      end
    end

  endgenerate

endmodule
