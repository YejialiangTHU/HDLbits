module fsmonehot(
    
    input               in,
    input       [9:0]   state,
    output      [9:0]   next_state,
    output              out1,
    output              out2

    );

    parameter S0 = 4'd0;
    parameter S1 = 4'd1;    
    parameter S2 = 4'd2;    
    parameter S3 = 4'd3;
    parameter S4 = 4'd4;
    parameter S5 = 4'd5;    
    parameter S6 = 4'd6;    
    parameter S7 = 4'd7;
    parameter S8 = 4'd8;    
    parameter S9 = 4'd9;

    //state transation
    assign next_state[S0] = (((state[0] || state[1] || state[2] || state[3] || state[4] || state[7] || state[8] || state[9]) && ~in));
    assign next_state[S1] = (state[0] || state[8] || state[9]) && in;
    assign next_state[S2] = state[1] && in;
    assign next_state[S3] = state[2] && in;
    assign next_state[S4] = state[3] && in;
    assign next_state[S5] = state[4] && in;
    assign next_state[S6] = state[5] && in;   
    assign next_state[S7] = (state[6] || state[7]) && in;
    assign next_state[S8] = state[5] && ~in;  
    assign next_state[S9] = state[6] && ~in;  

    //output logic
    assign out1 = state[8] || state[9];
    assign out2 = state[7] || state[9];
   
endmodule