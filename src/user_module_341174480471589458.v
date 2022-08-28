/*
 * user_module_341174480471589458.v
 */

`default_nettype none

module user_module_341174480471589458 (
	input  wire        latch_in,
	input  wire  [7:0] io_in,
	output wire  [7:0] io_out
);

	// Signals
	// -------

	// IO extension
	wire [31:0] eio_in;
	wire [31:0] eio_out;
	wire  [7:0] eio_latch_n;

	wire        clk_slow;


	// IO extension
	// ------------

	// Input 0 is slow clock, keep as-is
	sky130_fd_sc_hd__dlxtp_1 in_clk_slow_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.D    (io_in[0]),
		.GATE (latch_in),
		.Q    (clk_slow)
	);

	// Input [3:1] is 'address'
		// Group 0
	sky130_fd_sc_hd__or4b_1 in_dec_0_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D_N  (latch_in),
		.X    (eio_latch_n[0])
	);

		// Group 1
	sky130_fd_sc_hd__nand4bb_1 in_dec_1_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B_N  (io_in[2]),
		.C    (io_in[1]),
		.D    (latch_in),
		.Y    (eio_latch_n[1])
	);

		// Group 2
	sky130_fd_sc_hd__nand4bb_1 in_dec_2_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B_N  (io_in[1]),
		.C    (io_in[2]),
		.D    (latch_in),
		.Y    (eio_latch_n[2])
	);

		// Group 3
	sky130_fd_sc_hd__nand4b_1 in_dec_3_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B    (io_in[2]),
		.C    (io_in[1]),
		.D    (latch_in),
		.Y    (eio_latch_n[3])
	);

		// Group 4
	sky130_fd_sc_hd__nand4bb_1 in_dec_4_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[1]),
		.B_N  (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[4])
	);

		// Group 5
	sky130_fd_sc_hd__nand4b_1 in_dec_5_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[2]),
		.B    (io_in[1]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[5])
	);

		// Group 6
	sky130_fd_sc_hd__nand4b_1 in_dec_6_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[6])
	);

		// Group 7
	sky130_fd_sc_hd__nand4_1 in_dec_7_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[7])
	);

	// Input [7:4] is data
	genvar i;
	generate
		for (i=0; i<8; i=i+1) begin
			sky130_fd_sc_hd__dlxtn_1 in_latch_I[3:0] (
`ifdef WITH_POWER
				.VPWR (1'b1),
				.VGND (1'b0),
`endif
				.D      (io_in[7:4]),
				.GATE_N (eio_latch_n[i]),
				.Q      (eio_in[i*4+:4])
			);
		end
	endgenerate

	// Output mux
	sky130_fd_sc_hd__mux4_1 out_mux_I[7:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (eio_out[ 7: 0]),
		.A1   (eio_out[15: 8]),
		.A2   (eio_out[23:16]),
		.A3   (eio_out[31:24]),
		.X    (io_out),
		.S0   (eio_in[0]),
		.S1   (eio_in[1])
	);


	// Ring oscillator
	// ---------------

	// Signals
	wire  [1:0] osc_ctrl;
	wire [17:0] osc_chain;
	wire [16:0] osc_chain_dly;
	wire        osc_mux;
	wire        osc_out;

	// IOs
	assign osc_ctrl = eio_in[5:4];

	// Chain
		// First
	assign osc_chain[0] = osc_out;

		// Delay
	sky130_fd_sc_hd__clkdlybuf4s50_1 osc_dly_I[16:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_chain[16:0]),
		.X    (osc_chain_dly)
	);

		// Inverter
	sky130_fd_sc_hd__clkinv_1 osc_inv_I[16:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_chain_dly),
		.Y    (osc_chain[17:1])
	);

	// Feedback mux
	sky130_fd_sc_hd__mux4_1 osc_mux_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (1'b0),
		.A1   (osc_chain[17]),
		.A2   (osc_chain[9]),
		.A3   (osc_chain[5]),
		.X    (osc_mux),
		.S0   (osc_ctrl[0]),
		.S1   (osc_ctrl[1])
	);

	// Output buffer
	sky130_fd_sc_hd__clkbuf_2 osc_buf_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_mux),
		.X    (osc_out)
	);


	// Dummy
	// -----

	// Just link in/output
	assign eio_out = eio_in;

endmodule // user_module_341174480471589458
