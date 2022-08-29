module fsm_ps2data(
   
    input               clk,
    input   [7:0]       in,
    input               reset,    // Synchronous reset
    output  [23:0]      out_bytes,
    output              done
    
    ); //

    // FSM from fsm_ps2
    parameter S0_IDLE 	= 2'd0;
    parameter S1_BYTE1 	= 2'd1;   
    parameter S2_BYTE2 	= 2'd2;
    parameter S3_BYTE3 	= 2'd3;       
        
    reg		[1:0]	    cur_state;
    reg     [1:0]       next_state;   
    reg     [23:0]      data_tmp;
    
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

    // New: Datapath to store incoming bytes.

    always @ (posedge clk) begin
        if (reset) begin
            data_tmp <= 24'd0;
        end else begin
        	case (next_state)
            	S0_IDLE     :   data_tmp            <= 24'd0;
                S1_BYTE1    :   data_tmp[23:16]     <= in;
                S2_BYTE2    :   data_tmp[15:8]      <= in;
                S3_BYTE3    :   data_tmp[7:0]     	<= in;
            	default     :   data_tmp            <= 24'd0;
        	endcase
        end
    end

    assign  out_bytes = {24{cur_state == S3_BYTE3}} & (data_tmp);

endmodule