// mwrite.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module mwrite ();

	reg        clk_clk = 1'b0;                                    //                 clk.clk
	reg [31:0] dma_write_0_control_control_write_base;    // dma_write_0_control.control_write_base
	reg [31:0] dma_write_0_control_control_write_length;   //                    .control_write_length
	wire        dma_write_0_control_control_done;           //                    .control_done
	reg        dma_write_0_control_control_fixed_location; //                    .control_fixed_location
	reg        dma_write_0_control_control_go;             //                    .control_go
	reg        dma_write_0_user_user_write_buffer;         //    dma_write_0_user.user_write_buffer
	reg [31:0] dma_write_0_user_user_buffer_data;          //                    .user_buffer_data
	wire        dma_write_0_user_user_buffer_full;          //                    .user_buffer_full
	reg        reset_reset_n = 1'b1;

	wire         dma_write_0_avalon_master_waitrequest;            // mm_interconnect_0:dma_write_0_avalon_master_waitrequest -> dma_write_0:M_AVALON_WAITREQUEST
	wire  [31:0] dma_write_0_avalon_master_address;                // dma_write_0:M_AVALON_ADDRESS -> mm_interconnect_0:dma_write_0_avalon_master_address
	wire   [3:0] dma_write_0_avalon_master_byteenable;             // dma_write_0:M_AVALON_BYTEENABLE -> mm_interconnect_0:dma_write_0_avalon_master_byteenable
	wire         dma_write_0_avalon_master_write;                  // dma_write_0:M_AVALON_WRITE -> mm_interconnect_0:dma_write_0_avalon_master_write
	wire  [31:0] dma_write_0_avalon_master_writedata;              // dma_write_0:M_AVALON_WRITEDATA -> mm_interconnect_0:dma_write_0_avalon_master_writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect; // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;   // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire   [7:0] mm_interconnect_0_onchip_memory2_0_s1_address;    // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable; // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;      // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;  // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;      // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire         rst_controller_reset_out_reset;                   // rst_controller:reset_out -> [dma_write_0:M_AVALON_RSTN, mm_interconnect_0:dma_write_0_reset_sink_reset_bridge_in_reset_reset, onchip_memory2_0:reset]

	localparam  CLOCK_PERIOD            = 10; // Clock period in ps
        localparam  INITIAL_RESET_CYCLES    = 1000;  // Number of cycles to reset when simulation starts

	write #(
		.AVALON_DATA_WIDTH    (32),
		.FIFO_DEPTH           (16),
		.FIFO_DEPTH_LOG2      (4),
		.AVALON_ADDRESS_WIDTH (32)
	) dma_write_0 (
		.control_write_base     (dma_write_0_control_control_write_base),     //       control.control_write_base
		.control_write_length   (dma_write_0_control_control_write_length),   //              .control_write_length
		.control_done           (dma_write_0_control_control_done),           //              .control_done
		.control_fixed_location (dma_write_0_control_control_fixed_location), //              .control_fixed_location
		.control_go             (dma_write_0_control_control_go),             //              .control_go
		.user_write_buffer      (dma_write_0_user_user_write_buffer),         //          user.user_write_buffer
		.user_buffer_data       (dma_write_0_user_user_buffer_data),          //              .user_buffer_data
		.user_buffer_full       (dma_write_0_user_user_buffer_full),          //              .user_buffer_full
		.M_AVALON_RSTN          (~rst_controller_reset_out_reset),            //    reset_sink.reset_n
		.M_AVALON_CLK           (clk_clk),                                    //    clock_sink.clk
		.M_AVALON_WAITREQUEST   (dma_write_0_avalon_master_waitrequest),      // avalon_master.waitrequest
		.M_AVALON_ADDRESS       (dma_write_0_avalon_master_address),          //              .address
		.M_AVALON_WRITE         (dma_write_0_avalon_master_write),            //              .write
		.M_AVALON_BYTEENABLE    (dma_write_0_avalon_master_byteenable),       //              .byteenable
		.M_AVALON_WRITEDATA     (dma_write_0_avalon_master_writedata)         //              .writedata
	);

	mwrite_onchip_memory2_0 onchip_memory2_0 (
		.clk        (clk_clk),                                          //   clk1.clk
		.address    (mm_interconnect_0_onchip_memory2_0_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_onchip_memory2_0_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_onchip_memory2_0_s1_write),      //       .write
		.readdata   (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),                   // reset1.reset
		.reset_req  (1'b0),                                             // (terminated)
		.freeze     (1'b0)                                              // (terminated)
	);

	mwrite_mm_interconnect_0 mm_interconnect_0 (
		.clk_0_clk_clk                                      (clk_clk),                                          //                                    clk_0_clk.clk
		.dma_write_0_reset_sink_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                   // dma_write_0_reset_sink_reset_bridge_in_reset.reset
		.dma_write_0_avalon_master_address                  (dma_write_0_avalon_master_address),                //                    dma_write_0_avalon_master.address
		.dma_write_0_avalon_master_waitrequest              (dma_write_0_avalon_master_waitrequest),            //                                             .waitrequest
		.dma_write_0_avalon_master_byteenable               (dma_write_0_avalon_master_byteenable),             //                                             .byteenable
		.dma_write_0_avalon_master_write                    (dma_write_0_avalon_master_write),                  //                                             .write
		.dma_write_0_avalon_master_writedata                (dma_write_0_avalon_master_writedata),              //                                             .writedata
		.onchip_memory2_0_s1_address                        (mm_interconnect_0_onchip_memory2_0_s1_address),    //                          onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                          (mm_interconnect_0_onchip_memory2_0_s1_write),      //                                             .write
		.onchip_memory2_0_s1_readdata                       (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //                                             .readdata
		.onchip_memory2_0_s1_writedata                      (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //                                             .writedata
		.onchip_memory2_0_s1_byteenable                     (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //                                             .byteenable
		.onchip_memory2_0_s1_chipselect                     (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //                                             .chipselect
		.onchip_memory2_0_s1_clken                          (mm_interconnect_0_onchip_memory2_0_s1_clken)       //                                             .clken
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                 // reset_in0.reset
		.clk            (clk_clk),                        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

	// Clock signal generator
   always begin
      #(CLOCK_PERIOD / 2);
      clk_clk = ~clk_clk;
   end
   
   // Initial reset
   initial begin
      //repeat(INITIAL_RESET_CYCLES) @(posedge clk_clk);
      #0 
      reset_reset_n = 1'b0;
      #20; reset_reset_n = 1'b1; 
   end

	// Stimulus for the testbench
    initial begin
        // Wait for the reset de-assertion

        // Initialize inputs
        dma_write_0_control_control_write_base = 32'h00000000;
        dma_write_0_control_control_write_length = 32'h00000020;
        dma_write_0_control_control_go = 1'b0;
	dma_write_0_control_control_fixed_location = 1'b0;
        dma_write_0_user_user_buffer_data = 32'h00000000;
        dma_write_0_user_user_write_buffer = 1'b0;

        // Wait for a few clock cycles
        repeat(2) @(posedge clk_clk);
	end

        // Trigger the input signals
	initial begin
        #0
        dma_write_0_user_user_write_buffer = 1'b1;
        wait (dma_write_0_user_user_buffer_full)
	dma_write_0_user_user_write_buffer = 1'b0;
        end

	initial begin
	#195
    // Infinite loop
    forever begin
        // Set control signal to 1
	wait (dma_write_0_control_control_done);
        dma_write_0_control_control_go = 1;
        
        // Wait for 5 time units
        #5;
        
        // Set control signal to 0
        dma_write_0_control_control_go = 0;
        
        // Wait for 5 time units
        //#20;
    end
end

	initial begin
	#195
    // Infinite loop
    forever begin
        // Set control signal to 1
	wait (clk_clk);
        dma_write_0_user_user_buffer_data++;
        #10;
    end
end
    
	initial begin
	// Trigger the input signals
        #1000
	dma_write_0_control_control_fixed_location = 1'b1;
        #400
        $finish;
    end	

endmodule
