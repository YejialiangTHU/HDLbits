//In addition to walking left and right, Lemmings will fall (and presumably go "aaah!") if the ground disappears underneath them.
//In addition to walking left and right and changing direction when bumped, when ground=0, the Lemming will fall and say "aaah!". 
//When the ground reappears (ground=1), the Lemming will resume walking in the same direction as before the fall. 
//Being bumped while falling does not affect the walking direction, 
//and being bumped in the same cycle as ground disappears (but not yet falling), 
//or when the ground reappears while still falling, also does not affect the walking direction.
//Build a finite state machine that models this behaviour.

//create four state to describe this behavior
module Lemmings2(
    input       clk,
    input       areset,    // Freshly brainwashed Lemmings walk left.
    input       bump_left,
    input       bump_right,
    input       ground,
    output      walk_left,
    output      walk_right,
    output      aaah 
    ); 

    parameter LEFT=2'b00;
    parameter RIGHT=2'b01;
    parameter FALL_L=2'b10;
    parameter FALL_R=2'b11;
    
    reg [1:0] 	cur_state;
    reg	[1:0]	nxt_state;
    
    wire [1:0]	bump_lr;
    
    assign bump_lr = {bump_left, bump_right};
    
    always @(*) begin
        case (cur_state)
            LEFT: begin
                if (ground==1'b0) begin
                    nxt_state = FALL_L;
                end else if (ground==1'b1) begin
                    if(bump_lr==2'b10 || bump_lr==2'b11)
                        nxt_state = RIGHT;
                    else
                        nxt_state =LEFT;
                end else
                        nxt_state =LEFT;
            end
            
             RIGHT: begin
                if (ground==1'b0) begin
                    nxt_state = FALL_R;
                end else if (ground==1'b1) begin
                    if(bump_lr==2'b01 || bump_lr==2'b11)
                        nxt_state = LEFT;
                    else
                        nxt_state = RIGHT;
                end else
                        nxt_state = RIGHT;
            end 
            
            FALL_L : begin
                if (ground == 1'b1) 
                    nxt_state = LEFT;
                else 
             		nxt_state = FALL_L;
            end          
             
            FALL_R : begin
                if (ground == 1'b1) 
                    nxt_state = RIGHT;
                else 
             		nxt_state = FALL_R;
            end           
            default : nxt_state =LEFT;              
        endcase
    end    
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            cur_state <= LEFT;
        end else begin
             cur_state <= nxt_state;           
        end
    end
    
    //output logic
    
    assign walk_left = cur_state==LEFT;
    assign walk_right = cur_state==RIGHT;
    assign aaah = (cur_state==FALL_L || cur_state==FALL_R);    

endmodule