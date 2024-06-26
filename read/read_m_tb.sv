// read_m.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module read_m ();

	reg        clk_clk = 1'b0;                                //             clk.clk
	reg [31:0] readm_0_control_control_read_base;      // readm_0_control.control_read_base
	reg [31:0] readm_0_control_control_read_length;    //                .control_read_length
	reg        readm_0_control_control_fixed_location; //                .control_fixed_location
	reg        readm_0_control_control_go;             //                .control_go
	reg        readm_0_user_user_read_buffer;          //    readm_0_user.user_read_buffer
	reg        reset_reset_n = 1'b1;                          //             reset.reset_n
	wire        readm_0_control_control_done;           //                .control_done
	wire [31:0] readm_0_user_user_buffer_data;          //                .user_buffer_data
	wire        readm_0_user_user_data_available;       //                .user_data_available

	localparam  CLOCK_PERIOD            = 10; // Clock period in ps
        localparam  INITIAL_RESET_CYCLES    = 1000;  // Number of cycles to reset when simulation starts

	wire         readm_0_avalon_master_waitrequest;                // mm_interconnect_0:readm_0_avalon_master_waitrequest -> readm_0:M_AVALON_WAITREQUEST
	wire  [31:0] readm_0_avalon_master_readdata;                   // mm_interconnect_0:readm_0_avalon_master_readdata -> readm_0:M_AVALON_READDATA
	wire  [31:0] readm_0_avalon_master_address;                    // readm_0:M_AVALON_ADDRESS -> mm_interconnect_0:readm_0_avalon_master_address
	wire         readm_0_avalon_master_read;                       // readm_0:M_AVALON_READ -> mm_interconnect_0:readm_0_avalon_master_read
	wire   [3:0] readm_0_avalon_master_byteenable;                 // readm_0:M_AVALON_BYTEENABLE -> mm_interconnect_0:readm_0_avalon_master_byteenable
	wire         readm_0_avalon_master_readdatavalid;              // mm_interconnect_0:readm_0_avalon_master_readdatavalid -> readm_0:M_AVALON_READDATAVALID
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect; // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;   // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire   [7:0] mm_interconnect_0_onchip_memory2_0_s1_address;    // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable; // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;      // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;  // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;      // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire         rst_controller_reset_out_reset;                   // rst_controller:reset_out -> [mm_interconnect_0:readm_0_reset_sink_reset_bridge_in_reset_reset, onchip_memory2_0:reset, readm_0:M_AVALON_RSTN]

	read_m_onchip_memory2_0 onchip_memory2_0 (
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

	read #(
		.AVALON_DATA_WIDTH    (32),
		.FIFO_DEPTH           (16),
		.FIFO_DEPTH_LOG2      (4),
		.AVALON_ADDRESS_WIDTH (32)
	) readm_0 (
		.control_read_base      (readm_0_control_control_read_base),      //       control.control_read_base
		.control_read_length    (readm_0_control_control_read_length),    //              .control_read_length
		.control_done           (readm_0_control_control_done),           //              .control_done
		.control_fixed_location (readm_0_control_control_fixed_location), //              .control_fixed_location
		.control_go             (readm_0_control_control_go),             //              .control_go
		.user_read_buffer       (readm_0_user_user_read_buffer),          //          user.user_read_buffer
		.user_buffer_data       (readm_0_user_user_buffer_data),          //              .user_buffer_data
		.user_data_available    (readm_0_user_user_data_available),       //              .user_data_available
		.M_AVALON_WAITREQUEST   (readm_0_avalon_master_waitrequest),      // avalon_master.waitrequest
		.M_AVALON_READDATAVALID (readm_0_avalon_master_readdatavalid),    //              .readdatavalid
		.M_AVALON_READDATA      (readm_0_avalon_master_readdata),         //              .readdata
		.M_AVALON_ADDRESS       (readm_0_avalon_master_address),          //              .address
		.M_AVALON_READ          (readm_0_avalon_master_read),             //              .read
		.M_AVALON_BYTEENABLE    (readm_0_avalon_master_byteenable),       //              .byteenable
		.M_AVALON_CLK           (clk_clk),                                //    clock_sink.clk
		.M_AVALON_RSTN          (~rst_controller_reset_out_reset)         //    reset_sink.reset_n
	);

	read_m_mm_interconnect_0 mm_interconnect_0 (
		.clk_0_clk_clk                                  (clk_clk),                                          //                                clk_0_clk.clk
		.readm_0_reset_sink_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                   // readm_0_reset_sink_reset_bridge_in_reset.reset
		.readm_0_avalon_master_address                  (readm_0_avalon_master_address),                    //                    readm_0_avalon_master.address
		.readm_0_avalon_master_waitrequest              (readm_0_avalon_master_waitrequest),                //                                         .waitrequest
		.readm_0_avalon_master_byteenable               (readm_0_avalon_master_byteenable),                 //                                         .byteenable
		.readm_0_avalon_master_read                     (readm_0_avalon_master_read),                       //                                         .read
		.readm_0_avalon_master_readdata                 (readm_0_avalon_master_readdata),                   //                                         .readdata
		.readm_0_avalon_master_readdatavalid            (readm_0_avalon_master_readdatavalid),              //                                         .readdatavalid
		.onchip_memory2_0_s1_address                    (mm_interconnect_0_onchip_memory2_0_s1_address),    //                      onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                      (mm_interconnect_0_onchip_memory2_0_s1_write),      //                                         .write
		.onchip_memory2_0_s1_readdata                   (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //                                         .readdata
		.onchip_memory2_0_s1_writedata                  (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //                                         .writedata
		.onchip_memory2_0_s1_byteenable                 (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //                                         .byteenable
		.onchip_memory2_0_s1_chipselect                 (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //                                         .chipselect
		.onchip_memory2_0_s1_clken                      (mm_interconnect_0_onchip_memory2_0_s1_clken)       //                                         .clken
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
      #100; reset_reset_n = 1'b1; 
   end

	// Stimulus for the testbench
    initial begin
        // Wait for the reset de-assertion

        // Initialize inputs
        readm_0_control_control_read_base = 32'h00000000;
        readm_0_control_control_read_length = 32'h00000080;
        readm_0_control_control_go = 1'b0;
	readm_0_control_control_fixed_location = 1'b0;
        readm_0_user_user_read_buffer = 1'b0;

        // Wait for a few clock cycles
        repeat(2) @(posedge clk_clk);
	end

	initial begin
	#195
    // Infinite loop
    //forever begin
        // Set control signal to 1
	wait (readm_0_control_control_done);
        readm_0_control_control_go = 1;
        
        // Wait for 5 time units
        #5;
        
        // Set control signal to 0
        readm_0_control_control_go = 0;
        
        // Wait for 5 time units
        //#20;
    //end
end

	initial begin
        #1000
        readm_0_user_user_read_buffer = 1'b1;
	#150
	readm_0_control_control_fixed_location = 1'b1;
        #600
	
        

        // Wait for the done signal
        //wait (readm_0_control_control_done);
    
        $finish;
    end

endmodule
