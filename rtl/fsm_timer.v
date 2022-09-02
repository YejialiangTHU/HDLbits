module fsm_timer (
//module top_module (
    input           clk,
    input           reset, // Synchronous reset

    input           data,
    input           done_counting,
    input           ack,

    output          shift_ena,
    output          counting,
    output          done

    );

    reg     [2:0]   cur_state;
    reg     [2:0]   next_state;
    
    reg             rst_d1;
    reg             rst_d2;
    reg             rst_d3;
//    reg             rst_d4;
    reg     [1:0]   shift_ena_cnt;
    reg             start_shifting;
    wire            s4_tri;
    reg             s4_tri_d1;
    wire            s4_tri_pos;

    parameter 
            S0_IDLE = 3'd0,
            S1_1    = 3'd1,
            S2_11   = 3'd2,
            S3_110  = 3'd3,
            S4_1101 = 3'd4;


    always @ (posedge clk) begin
        if (reset) begin
            cur_state <= S0_IDLE;
        end else begin
            cur_state <= next_state;
        end
    end

    always @ (*) begin
        case (cur_state)
            S0_IDLE :   if (data == 1'b1)
                            next_state = S1_1;
                        else 
                            next_state = S0_IDLE;
            S1_1    :
                        if (data == 1'b1)
                            next_state = S2_11;
                        else if (data == 1'b0)
                            next_state = S0_IDLE;
                        else
                            next_state = S1_1;
            S2_11   :
                        if (data == 1'b0)
                            next_state = S3_110;
                        else
                            next_state = S2_11;
            S3_110  :
                        if (data == 1'b1)
                            next_state = S4_1101;
                        else if (data == 1'b0)
                            next_state = S0_IDLE;
                        else
                            next_state = S3_110;
            S4_1101 :   if (done && ack)
                            next_state = S0_IDLE;
                        else
                            next_state = S4_1101;                         
            default : 
                        next_state = S0_IDLE;
        endcase
    end

    assign  s4_tri_pos = s4_tri && (!s4_tri_d1);
    assign  s4_tri = next_state == S4_1101;

    always @ (posedge clk) begin
        if (reset) begin
            s4_tri_d1 <= 1'b0;
        end else begin
            s4_tri_d1 <= s4_tri;
        end
    end

    always @ (posedge clk) begin
        if (reset)
            start_shifting <= 1'b0;
        else if (s4_tri_pos)
            start_shifting <= 1'b1;
        else
            start_shifting <= 1'b0;            
    end

    always @ (posedge clk) begin
        if (reset) begin
            rst_d1 <= 1'b0;
        end else if (start_shifting) begin
            rst_d1 <= start_shifting;
        end else begin
            rst_d1 <= 1'd0;
        end           
    end

    always @ (posedge clk) begin
        if (reset) begin
            rst_d2 <= 1'b0;
            rst_d3 <= 1'b0;
//            rst_d4 <= 1'b0;
        end else begin
            rst_d2 <= rst_d1;
            rst_d3 <= rst_d2;
//            rst_d4 <= rst_d3;
        end   
    end

    assign shift_ena = rst_d3 | rst_d2 | rst_d1 | start_shifting;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_ena_cnt <= 2'd0;
        end else if (shift_ena) begin
            shift_ena_cnt <= shift_ena_cnt + 1'b1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
        end else if (shift_ena && shift_ena_cnt == 2'd3) begin
            counting <= 1'b1;
        end else if (done_counting) begin
            counting <= 1'b0;
        end
    end

    always @ (posedge clk) begin
        if (reset) begin
            done <= 1'b0;
        end else if (counting && done_counting) begin
            done <= 1'b1;
        end else if (ack) begin
            done <= 1'b0;
        end
    end

endmodule