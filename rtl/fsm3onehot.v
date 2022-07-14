//The following is the state transition table for a Moore state machine with one input, one output, and four states. 
//Use the following one-hot state encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000.
//Derive state transition and output logic equations by inspection assuming a one-hot encoding. 
//Implement only the state transition logic and output logic (the combinational logic portion) for this state machine. 
//(The testbench will test with non-one hot inputs to make sure you're not trying to do something more complicated).
module fsm3onehot
    (
        input           in,
        input   [3:0]   state,
        output  [3:0]   next_state,
        output          out
    ); //
    
        parameter A=0, B=1, C=2, D=3;
    
        // State transition logic: Derive an equation for each state flip-flop.
        assign next_state[A] = state[0]&(~in) | state[2]&(~in);
        assign next_state[B] = state[0]&(in) | state[1]&in | state[3]&in;
        assign next_state[C] = state[1]&(~in) | state[3] &(~in);
        assign next_state[D] = state[2]&(in);
    
        // Output logic: 
        assign out = state[3];
    
endmodule