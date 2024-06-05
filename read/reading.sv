module reading
(input  logic clk,
 input  logic rstn,
 input  logic control_fixed_location,
 input  logic control_read_base,		 // for read master
 input  logic control_read_length,		 // for read master
 input  logic control_go,
 output logic control_done,
 input  logic user_read_buffer,
 output logic user_buffer_data,
 output logic user_data_available
);


    read_m 
	 u0 (
        .clk_clk                                      (clk),                                      //                   clk.clk
        .readm_0_control_control_read_base      (control_read_base),      // read_master_0_control.control_read_base
        .readm_0_control_control_read_length    (control_read_length),    //                      .control_read_length
        .readm_0_control_control_done           (control_done),           //                      .control_done
        .readm_0_control_control_fixed_location (control_fixed_location), //                      .control_fixed_location
        .readm_0_control_control_go             (control_go),             //                      .control_go
        .readm_0_user_user_read_buffer          (user_read_buffer),          //    read_master_0_user.user_read_buffer
        .readm_0_user_user_buffer_data          (user_buffer_data),          //                      .user_buffer_data
        .readm_0_user_user_data_available       (user_data_available),       //                      .user_data_available
        .reset_reset_n                                (rstn));

endmodule: reading