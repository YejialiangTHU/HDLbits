//the game Lemmings involves critters with fairly simple brains. So simple that we are going to model it using a finite state machine.
//In the Lemmings' 2D world, Lemmings can be in one of two states: walking left or walking right. It will switch directions if it hits an obstacle. 
//In particular, if a Lemming is bumped on the left, it will walk right. 
//If it's bumped on the right, it will walk left. If it's bumped on both sides at the same time, it will still switch directions.
//Implement a Moore state machine with two states, two inputs, and one output that models this behaviour.
module Lemmings1(
    input       clk,
    input       areset,    // Freshly brainwashed Lemmings walk left.
    input       bump_left,
    input       bump_right,
    output      walk_left,
    output      walk_right
    ); //  

    parameter   LEFT=1'b0;
    parameter   RIGHT=1'b1;
    reg         state;
    reg         next_state;
	
    wire	[1:0]	bump_lr;
    
    assign bump_lr = {bump_left, bump_right};
    
    always @(*) begin
        // State transition logic
        case (state)
            LEFT: if (bump_lr == 2'b10 || bump_lr == 2'b11)
                		next_state = RIGHT;
            		else
						next_state = LEFT;
            RIGHT: if (bump_lr == 2'b10 || bump_lr == 2'b00)
                		next_state = RIGHT;
            		else
						next_state = LEFT;
            default : next_state = LEFT;
        endcase            
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end							// State flip-flops with asynchronous reset
    end

    // Output logic
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule