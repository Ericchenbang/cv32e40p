// RVSLH Project
// SIMD Register File for SLH-DSA / Keccak acceleration
//
// Architecture (from RVSLH paper, Section III-A):
//   - 5 independent SIMD register file banks
//   - Each bank: 16 rows x 64 bits  =>  5 x 16 x 64 = 4800 bits total
//   - Collectively present 10 x 32-bit lanes for 320-bit SIMD operations
//   - 5 read ports  (one per bank, reads full 64-bit row)
//   - 2 write ports (shared across banks, bank selected by address)
//
// Addressing:
//   - addr[6:4]  = bank select  (0..4)
//   - addr[3:0]  = row  select  (0..15)
//
// Integration:
//   - Instantiated inside cv32e40p_id_stage during the ID pipeline stage
//   - Read data is forwarded to the SIMD ALU in the EX stage
//   - Written by SIMD store instructions (WB path) and SIMD ALU results

module cv32e40p_simd_rf (
    input  logic        clk,
    input  logic        rst_n,

    // ----------------------------------------------------------------
    // Read ports (5 ports, one per bank, 64-bit each)
    // ----------------------------------------------------------------
    input  logic [6:0]  raddr_0_i,   // {bank[2:0], row[3:0]}
    output logic [63:0] rdata_0_o,

    input  logic [6:0]  raddr_1_i,
    output logic [63:0] rdata_1_o,

    input  logic [6:0]  raddr_2_i,
    output logic [63:0] rdata_2_o,

    input  logic [6:0]  raddr_3_i,
    output logic [63:0] rdata_3_o,

    input  logic [6:0]  raddr_4_i,
    output logic [63:0] rdata_4_o,

    // ----------------------------------------------------------------
    // Write port A  (higher priority, e.g. WB writeback path)
    // ----------------------------------------------------------------
    input  logic [6:0]  waddr_a_i,
    input  logic [63:0] wdata_a_i,
    input  logic        we_a_i,

    // ----------------------------------------------------------------
    // Write port B  (lower priority, e.g. ALU result forwarding path)
    // ----------------------------------------------------------------
    input  logic [6:0]  waddr_b_i,
    input  logic [63:0] wdata_b_i,
    input  logic        we_b_i
);

  // ----------------------------------------------------------------
  // Parameters
  // ----------------------------------------------------------------
  localparam int unsigned N_BANKS = 5;
  localparam int unsigned N_ROWS  = 16;

  // ----------------------------------------------------------------
  // Storage: 5 banks x 16 rows x 64 bits
  // ----------------------------------------------------------------
  logic [63:0] mem [N_BANKS-1:0][N_ROWS-1:0];

  // ----------------------------------------------------------------
  // Address decode helpers
  //   addr[6:4] => bank (0-4, values 5-7 unused/ignored)
  //   addr[3:0] => row  (0-15)
  // ----------------------------------------------------------------
  function automatic logic [2:0] get_bank(input logic [6:0] addr);
    return addr[6:4];
  endfunction

  function automatic logic [3:0] get_row(input logic [6:0] addr);
    return addr[3:0];
  endfunction

  // ----------------------------------------------------------------
  // READ (combinatorial, async)
  // ----------------------------------------------------------------
  assign rdata_0_o = (get_bank(raddr_0_i) < N_BANKS) ?
                      mem[get_bank(raddr_0_i)][get_row(raddr_0_i)] : '0;

  assign rdata_1_o = (get_bank(raddr_1_i) < N_BANKS) ?
                      mem[get_bank(raddr_1_i)][get_row(raddr_1_i)] : '0;

  assign rdata_2_o = (get_bank(raddr_2_i) < N_BANKS) ?
                      mem[get_bank(raddr_2_i)][get_row(raddr_2_i)] : '0;

  assign rdata_3_o = (get_bank(raddr_3_i) < N_BANKS) ?
                      mem[get_bank(raddr_3_i)][get_row(raddr_3_i)] : '0;

  assign rdata_4_o = (get_bank(raddr_4_i) < N_BANKS) ?
                      mem[get_bank(raddr_4_i)][get_row(raddr_4_i)] : '0;

  // ----------------------------------------------------------------
  // WRITE (synchronous, port A wins over port B on same address)
  // ----------------------------------------------------------------
  genvar b, r;
  generate
    for (b = 0; b < N_BANKS; b++) begin : gen_bank
      for (r = 0; r < N_ROWS; r++) begin : gen_row

        always_ff @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
            mem[b][r] <= '0;
          end else begin
            // Port A wins when both ports target same cell
            if (we_a_i &&
                (get_bank(waddr_a_i) == b) &&
                (get_row (waddr_a_i) == r)) begin
              mem[b][r] <= wdata_a_i;
            end else if (we_b_i &&
                (get_bank(waddr_b_i) == b) &&
                (get_row (waddr_b_i) == r)) begin
              mem[b][r] <= wdata_b_i;
            end
          end
        end

      end : gen_row
    end : gen_bank
  endgenerate

endmodule : cv32e40p_simd_rf