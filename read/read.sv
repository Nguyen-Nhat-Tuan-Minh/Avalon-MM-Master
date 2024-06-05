module read
#(parameter AVALON_DATA_WIDTH = 32,
  parameter FIFO_DEPTH = 16,
  parameter FIFO_DEPTH_LOG2 = 4,
  parameter AVALON_ADDRESS_WIDTH = 32,
  parameter AVALON_BYTE_ENABLE_WIDTH = AVALON_DATA_WIDTH/8
)

(input  logic M_AVALON_CLK,
 input  logic M_AVALON_RSTN,
 
 // control inputs and outputs
 input  logic                             control_fixed_location,
 input  logic [AVALON_ADDRESS_WIDTH-1:0]  control_read_base,		 // for read master
 input  logic [AVALON_ADDRESS_WIDTH-1:0]  control_read_length,		 // for read master
 input  logic                             control_go,
 output logic                             control_done,
	
 // user logic inputs and outputs
 input  logic                             user_read_buffer,
 output logic [AVALON_DATA_WIDTH-1:0]     user_buffer_data,
 output logic                             user_data_available,
	
 // master inputs and outputs
 input  logic                             M_AVALON_WAITREQUEST,
 input  logic                             M_AVALON_READDATAVALID,
 input  logic [AVALON_DATA_WIDTH-1:0]     M_AVALON_READDATA,
 output logic [AVALON_ADDRESS_WIDTH-1:0]  M_AVALON_ADDRESS,
 output logic                             M_AVALON_READ,
 output logic [(AVALON_DATA_WIDTH/8)-1:0] M_AVALON_BYTEENABLE
);
 
 // internal control signals
 logic                                    control_fixed_location_r0;
 logic                                    fifo_empty;
 logic [AVALON_ADDRESS_WIDTH-1:0]         address;  // this increments for each word
 logic [AVALON_ADDRESS_WIDTH-1:0]         length;
 logic [FIFO_DEPTH_LOG2-1:0]               reads_pending;
 logic                                    increment_address;
 logic                                    too_many_pending_reads;
 logic                                    too_many_pending_reads_r0;
 logic [FIFO_DEPTH_LOG2-1:0]              fifo_used;

  // registering the control_fixed_location bit
  always_ff @(posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          control_fixed_location_r0 <= 0;
        end
      else
        begin
		    if (control_go == 1)
            begin
              control_fixed_location_r0 <= control_fixed_location;
            end
        end
    end

  // master address logic 
  assign M_AVALON_ADDRESS = address;
  assign M_AVALON_BYTEENABLE = -1;  // all ones, always performing word size accesses
  
  always_ff @(posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          address <= 0;
        end
      else
        begin
          if(control_go == 1)
            begin
              address <= control_read_base;
            end
          else if((increment_address == 1) & (control_fixed_location_r0 == 0))
            begin
              address <= address + AVALON_BYTE_ENABLE_WIDTH;  // always performing word size accesses
            end
        end
    end
	
  // master length logic
  always_ff @(posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          length <= 0;
        end
      else
        begin
          if(control_go == 1)
            begin
              length <= control_read_length;
            end
          else if(increment_address == 1)
            begin
              length <= length - AVALON_BYTE_ENABLE_WIDTH;  // always performing word size accesses
            end
        end
    end	
	
  // control logic
  assign too_many_pending_reads = (fifo_used + reads_pending) >= (FIFO_DEPTH - 4);
  assign M_AVALON_READ = (length != 0) & (too_many_pending_reads_r0 == 0);
  assign increment_address = (length != 0) & (too_many_pending_reads_r0 == 0) & (M_AVALON_WAITREQUEST == 0);
  assign control_done = (reads_pending == 0) & (length == 0);  // master done posting reads and all reads have returned
  //assign control_early_done = (length == 0);  // if you need all the pending reads to return then use 'control_done' instead of this signal
  
  always_ff @(posedge M_AVALON_CLK)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          too_many_pending_reads_r0 <= 0;
        end
      else
        begin
          too_many_pending_reads_r0 <= too_many_pending_reads;
        end
    end
	 
  always_ff @(posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          reads_pending <= 0;
        end
      else
        begin
          if(increment_address == 1)
            begin
              if(M_AVALON_READDATAVALID == 0)
                begin
                  reads_pending <= reads_pending + 1;
                end
              else
                begin
                  reads_pending <= reads_pending;  // a read was posted, but another returned
                end			
            end
          else
            begin
              if(M_AVALON_READDATAVALID == 0)
                begin
                  reads_pending <= reads_pending;  // read was not posted and no read returned
                end
              else
                begin
                  reads_pending <= reads_pending - 1;  // read was not posted but a read returned
                end				
            end
        end
    end

	
  // read data feeding user logic	
  assign user_data_available = !fifo_empty;
  fifo #(.ADDR_WIDTH(FIFO_DEPTH), .DATA_WIDTH(AVALON_DATA_WIDTH), .FIFO_DEPTH_LOG2(FIFO_DEPTH_LOG2)) 
    the_master_to_user_fifo (
      .rstN (M_AVALON_RSTN),
      .clk (M_AVALON_CLK),
      .w_data (M_AVALON_READDATA),
      .empty (fifo_empty),
      .r_data (user_buffer_data),
      .rd (user_read_buffer),
      .usedw (fifo_used),
      .wr (M_AVALON_READDATAVALID)
	);

endmodule: read

module fifo
#(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16,
  parameter FIFO_DEPTH_LOG2 = 4
)

(input  logic                  clk, 
 input  logic                  rstN,
 input  logic                  wr, rd,
 input  logic [DATA_WIDTH-1:0] w_data,
 output logic                  empty, full, 
 output logic [DATA_WIDTH-1:0] r_data,
 output logic [FIFO_DEPTH_LOG2-1:0] usedw 
);

  // signal declaration
  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
  logic wr_en, fulltemp;
  
  //assert wr_en if FIFO not full
  assign wr_en = wr & ~fulltemp;
  assign full = fulltemp;

  // write data feed by user logic
  fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH), .FIFO_DEPTH_LOG2(FIFO_DEPTH_LOG2))
    fifo_ctrl_read (
		.*,
		.full(fulltemp)
    );
	 
  register_file #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) 
    reg_file (.*);
	 
endmodule: fifo
	 
module fifo_ctrl
#(
  parameter ADDR_WIDTH = 16,
  parameter FIFO_DEPTH_LOG2 = 4
)

(input  logic                  clk, rstN,
 input  logic                  wr, rd,
 output logic                  empty, full, 
 output logic [ADDR_WIDTH-1:0] w_addr,
 output logic [ADDR_WIDTH-1:0] r_addr,
 output logic [FIFO_DEPTH_LOG2-1:0] usedw
);

  logic [ADDR_WIDTH-1:0] w_ptr_logic, w_ptr_next, w_ptr_succ;
  logic [ADDR_WIDTH-1:0] r_ptr_logic, r_ptr_next, r_ptr_succ;
  logic fifo_full, fifo_empty, full_next, empty_next;
  
  // fifo control logic
  
  always_ff @(posedge clk or negedge rstN)
    if (rstN == 0) begin
	   w_ptr_logic <= 0;
		r_ptr_logic <= 0;
		fifo_full <= 1'b0;
		fifo_empty <= 1'b1;
	 end
    else begin
	   w_ptr_logic <= w_ptr_next;
		r_ptr_logic <= r_ptr_next;
		fifo_full <= full_next;
		fifo_empty <= empty_next;
	 end
	
  //next-state logic for read and write pointers
  always_comb begin
    // successive pointer values
	 w_ptr_succ = w_ptr_logic + FIFO_DEPTH_LOG2;
	 r_ptr_succ = r_ptr_logic + FIFO_DEPTH_LOG2; 
    // default old values
	 w_ptr_next = w_ptr_logic;
	 r_ptr_next = r_ptr_logic;
	 full_next = fifo_full;
	 empty_next = fifo_empty;
	 unique case ({wr, rd})
	   2'b01: //read
		  if (fifo_empty == 0) begin
		    r_ptr_next = r_ptr_succ;
		    full_next = 1'b0;
			 if (r_ptr_succ == w_ptr_logic)
			   empty_next = 1'b1;
		  end
		2'b10: //write
		  if (fifo_full == 0) begin
		    w_ptr_next = w_ptr_succ;
			 empty_next = 1'b0;
			 if (w_ptr_succ == r_ptr_logic)
			   full_next = 1'b1;
		  end
		2'b11: 
		  begin
		    r_ptr_next = r_ptr_succ;
		    w_ptr_next = w_ptr_succ;	
		  end
		default: ; //empty case
	 endcase
  end
  
  always_ff @(posedge clk or negedge rstN)
    begin
	   if (rstN == 0)
        begin
          usedw <= 0;
        end
      else
        begin
          usedw <= w_ptr_logic - r_ptr_logic;
        end
	 end 	  

  assign w_addr = w_ptr_logic;
  assign r_addr = r_ptr_logic;
  assign full = fifo_full;
  assign empty = fifo_empty;
endmodule: fifo_ctrl

module register_file
#(parameter DATA_WIDTH = 32,
            ADDR_WIDTH = 16
)

(input  logic                  clk,
 input  logic                  wr_en,
 input  logic [ADDR_WIDTH-1:0] w_addr, r_addr,
 input  logic [DATA_WIDTH-1:0] w_data,
 output logic [DATA_WIDTH-1:0] r_data
);
				 
  logic [DATA_WIDTH-1:0] array_reg [0:2**ADDR_WIDTH-1];
  
  always_ff @(posedge clk)
    if (wr_en)
	   array_reg[w_addr] <= w_data;
	 // read data
	 assign r_data = array_reg[r_addr]; 

endmodule: register_file