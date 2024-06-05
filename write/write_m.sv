module write_m
(input  logic clk,
 input  logic rst_n,
 input  logic user_buffer_data,
 output logic user_buffer_full,
 input  logic user_write_buffer,
 input  logic control_fixed_location,
 input  logic control_write_base,
 input  logic control_write_length,
 input  logic control_go,
 output logic control_done
);
 

	mwrite u0 (
		.clk_clk                                   (clk),                                   //                  clk.clk
		.reset_reset_n                             (rst_n),                             //                reset.reset_n
		.dma_write_0_control_control_fixed_location   (control_fixed_location),
		.dma_write_0_control_control_write_base   (control_write_base),   // dma_write_0_control.control_write_base
		.dma_write_0_control_control_write_length (control_write_length), //                     .control_write_length
		.dma_write_0_control_control_done         (control_done),         //                     .control_done
		.dma_write_0_control_control_go           (control_go),           //                     .control_go
		.dma_write_0_user_user_buffer_data        (user_buffer_data),        //    dma_write_0_user.user_buffer_data
		.dma_write_0_user_user_buffer_full        (user_buffer_full),        //                     .user_buffer_full
		.dma_write_0_user_user_write_buffer       (user_write_buffer)        //                     .user_write_buffer
	);
	
endmodule: write_m

