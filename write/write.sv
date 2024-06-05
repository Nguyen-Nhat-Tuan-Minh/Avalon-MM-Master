module write
#(parameter AVALON_DATA_WIDTH = 32,
  parameter FIFO_DEPTH = 16,
  parameter FIFO_DEPTH_LOG2 = 4,
  parameter AVALON_ADDRESS_WIDTH = 32,
  parameter AVALON_BYTE_ENABLE_WIDTH = AVALON_DATA_WIDTH/8
)

(input  logic                             M_AVALON_CLK,
 input  logic                             M_AVALON_RSTN,
 
 // control inputs and outputs
 input  logic                             control_fixed_location,
 input  logic [AVALON_ADDRESS_WIDTH-1:0]  control_write_base,			// for write master
 input  logic [AVALON_ADDRESS_WIDTH-1:0]  control_write_length,		// for write master
 input  logic                             control_go,
 output logic                             control_done,
 
 // user logic inputs and outputs
 input  logic                             user_write_buffer,			// for write master
 input  logic [AVALON_DATA_WIDTH-1:0]     user_buffer_data,		      // for write master
 output logic                             user_buffer_full,
 
 // master inputs and outputs
 input  logic                             M_AVALON_WAITREQUEST,
 output logic [AVALON_ADDRESS_WIDTH-1:0]  M_AVALON_ADDRESS,
 output logic                             M_AVALON_WRITE,				// for write master
 output logic [(AVALON_DATA_WIDTH/8)-1:0] M_AVALON_BYTEENABLE,
 output logic [AVALON_DATA_WIDTH-1:0]     M_AVALON_WRITEDATA			// for write master
);

  // internal control signals
  logic                            control_fixed_location_r0;
  logic [AVALON_ADDRESS_WIDTH-1:0] address;  // this increments for each word
  logic [AVALON_ADDRESS_WIDTH-1:0] length;
  logic                            increment_address;  // this increments the 'address' register when write is asserted and waitrequest is de-asserted
  logic                            read_fifo;
  logic                            user_buffer_empty;	   
  
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
	
  // master word increment counter
  always_ff @(posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
			 address <= 0;
		  end
		else
		  begin
			 if (control_go == 1)
			   begin
				  address <= control_write_base;
			   end
			 else if ((increment_address == 1) & (control_fixed_location_r0 == 0))
			   begin
				  address <= address + AVALON_BYTE_ENABLE_WIDTH;  // always performing word size accesses
			   end
        end
    end
	
  // master length logic
  always @ (posedge M_AVALON_CLK or negedge M_AVALON_RSTN)
    begin
      if (M_AVALON_RSTN == 0)
        begin
          length <= 0;
        end
      else 
		  begin
          if (control_go == 1)
            begin
              length <= control_write_length;
            end
          else if (increment_address == 1)
            begin
              length <= length - AVALON_BYTE_ENABLE_WIDTH;  // always performing word size accesses
            end
        end
    end
	
  // controlled signals going to the master/control ports
  assign M_AVALON_ADDRESS = address;
  assign M_AVALON_BYTEENABLE = -1;  // all ones, always performing word size accesses
  assign control_done = (length == 0);
  assign M_AVALON_WRITE = (user_buffer_empty == 0) & (control_done == 0);
  
  assign increment_address = (user_buffer_empty == 0) & (M_AVALON_WAITREQUEST == 0) & (control_done == 0);
  assign read_fifo = increment_address;
	
  	
  // write data feed by user logic
	fifo #(.DATA_WIDTH(AVALON_DATA_WIDTH), .ADDR_WIDTH(FIFO_DEPTH), .FIFO_DEPTH_LOG2(FIFO_DEPTH_LOG2)) 
	  the_user_to_master_fifo( 
       .rstN (M_AVALON_RSTN),
       .clk (M_AVALON_CLK),
	    .r_data (M_AVALON_WRITEDATA),
	    .full (user_buffer_full),
	    .empty (user_buffer_empty),
	    .w_data (user_buffer_data),
	    .rd (read_fifo),
	    .wr (user_write_buffer)
	  );
   // THIS SECTION IS OBSOLETE, READ AND WRITE WILL SHARE A COMMON FIFO BUFFER	  
	
endmodule: write

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
 output logic [DATA_WIDTH-1:0] r_data 

);

  // signal declaration
  logic [ADDR_WIDTH-1:0] w_addr, r_addr;
  logic wr_en, fulltemp;
  
  //assert wr_en if FIFO not full
  assign wr_en = wr & ~fulltemp;
  assign full = fulltemp;

  // write data feed by user logic
  fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH), .FIFO_DEPTH_LOG2(FIFO_DEPTH_LOG2))
    fifo_ctrl0 (
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
 output logic [ADDR_WIDTH-1:0] r_addr
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