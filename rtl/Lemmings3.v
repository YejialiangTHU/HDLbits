//In addition to walking and falling, Lemmings can sometimes be told to do useful things, 
//like dig (it starts digging when dig=1). 
//A Lemming can dig if it is currently walking on ground (ground=1 and not falling), 
//and will continue digging until it reaches the other side (ground=0). 
//At that point, since there is no ground, it will fall (aaah!), 
//then continue walking in its original direction once it hits ground again. 
//As with falling, being bumped while digging has no effect, 
//and being told to dig when falling or when there is no ground is ignored.
//(In other words, a walking Lemming can fall, dig, or switch directions. 
//If more than one of these conditions are satisfied, fall has higher precedence than dig, 
//which has higher precedence than switching directions.)
module Lemmings3(
    input       clk,
    input       areset,    // Freshly brainwashed Lemmings walk left.
    input       bump_left,
    input       bump_right,
    input       ground,
    input       dig,
    output      walk_left,
    output      walk_right,
    output      aaah,
    output      digging
    ); 

    parameter LEFT=3'b000;
    parameter RIGHT=3'b001;
    parameter FALL_L=3'b010;
    parameter FALL_R=3'b011;
    parameter DIG_L = 3'b100;
    parameter DIG_R = 3'b101;   
    
    reg		[2:0]   cur_state, nxt_state;
    wire	[1:0]	bump_lr;

    assign bump_lr = {bump_left, bump_right};
    
    always @ (*) begin
        case (cur_state)
            default: nxt_state = LEFT;

            LEFT: 	if (ground==1'b0) begin
                		nxt_state = FALL_L;
           	 		end else if(ground == 1'b1) begin
                        if (dig == 1'b1) begin
                    		nxt_state = DIG_L;
                        end else if ((bump_lr==2'b10) || (bump_lr==2'b11)) begin
                            nxt_state = RIGHT;
                        end else begin
                          	nxt_state = LEFT;
                        end
                   end else begin
                   		nxt_state = LEFT;
                   end
            
            RIGHT:  if (ground==1'b0)
                		nxt_state = FALL_R;
                        else if (ground == 1'b1)
                		if (dig == 1'b1)
                    		nxt_state = DIG_R;
            			else if (bump_lr==2'b01 || bump_lr==2'b11)
                            nxt_state = LEFT;
            			else
                          	nxt_state = RIGHT;
            		else
                          	nxt_state = RIGHT;
            
            FALL_L: if (ground == 1'b1)
                		nxt_state = LEFT;
            		else 
                     	nxt_state = FALL_L;
            
            DIG_L: if (ground == 1'b0)
                		nxt_state = FALL_L;
            		else 
                     	nxt_state = DIG_L;            
            
            FALL_R: if (ground == 1'b1)
                		nxt_state = RIGHT;
            		else 
                     	nxt_state = FALL_R;
            
            DIG_R: if (ground == 1'b0)
                		nxt_state = FALL_R;
            		else 
                     	nxt_state = DIG_R;            
        endcase
    end
    
    always @ (posedge clk or posedge areset) begin
        if (areset) begin
            cur_state <= LEFT;
        end else begin
            cur_state <= nxt_state;
        end
    end
   
    //output logic
    
    assign walk_left = cur_state== LEFT;
    assign walk_right = cur_state== RIGHT;
    assign digging = (ur_state== DIG_L || cur_state== DIG_R);
    assign aaah = (cur_state==FALL_L || cur_state==FALL_R); 
     
endmodule