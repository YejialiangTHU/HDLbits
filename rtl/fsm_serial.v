module fsm_serial(

    input       clk,
    input       in,
    input       reset,    // Synchronous reset
    output      done

    ); 

    parameter S0_IDLE   =   2'd0;
    parameter S1_START  =   2'd1;
    parameter S2_DATA   =   2'd2;
    parameter S3_STOP   =   2'd3;

    reg     [1:0]       cur_state;
    reg     [1:0]       next_state;

    reg     [9:0]       data_cnt;


    always @ (*) begin
        case (cur_state)
            S0_IDLE :   if (~in)
                            next_state = S1_START;
                        else
                            next_state = S0_IDLE;
            S1_START:
                        next_state = S2_DATA;
        
            S2_DATA :   if (data_cnt >= 10'd7 && in)
                            next_state = S3_STOP;
                        else
                            next_state = S2_DATA;
            S3_STOP :	if (~in)
                			next_state = S1_START;
            			else
                        	next_state = S0_IDLE;
            
            default :   next_state = S0_IDLE;
        endcase
    end

    always @ (posedge clk) begin
        if (reset)
            cur_state <= S0_IDLE;
        else
            cur_state <= next_state;
    end

    //data cnt
    always @ (posedge clk) begin
        if (reset)
            data_cnt <= 10'd0;
        else if (cur_state == S1_START)
            data_cnt <= 10'd0;
        else if (cur_state == S2_DATA)
            data_cnt <= data_cnt + 1'b1;
    end

    //output logic
    assign done = (cur_state == S3_STOP) && (data_cnt == 10'd8);

endmodule