module fsm_ps2(

    input               clk,
    input   [7:0]       in,
    input               reset,    // Synchronous reset
    output              done
    
    ); //


    parameter S0_IDLE 	= 2'd0;
    parameter S1_BYTE1 	= 2'd1;   
    parameter S2_BYTE2 	= 2'd2;
    parameter S3_BYTE3 	= 2'd3;       
        
    reg		[1:0]	cur_state, next_state;   
    
    // State transition logic (combinational)
    always @ (*) begin
        case(cur_state)
            S0_IDLE:    if (in[3])
                		    next_state = S1_BYTE1;
                        else 
                            next_state = S0_IDLE;
            S1_BYTE1:
                		next_state = S2_BYTE2;                        
            S2_BYTE2:
                		next_state = S3_BYTE3;                        
            S3_BYTE3:   if (in[3])
                		    next_state = S1_BYTE1;
                        else 
                            next_state = S0_IDLE;
            default : 
                        next_state = S0_IDLE;
        endcase
    end                                 
    

    // State flip-flops (sequential)
    always @ (posedge clk) begin
        if (reset) begin
            cur_state <= S0_IDLE;
        end else begin
            cur_state <= next_state;
        end
    end

    // Output logic

    assign done = cur_state == S3_BYTE3;

endmodule