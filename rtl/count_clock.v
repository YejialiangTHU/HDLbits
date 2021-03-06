module count_clock(
    input 					clk,
    input 					reset,
    input 					ena,
    output reg 				pm,
    output reg [7:0] 		hh,
    output reg [7:0] 		mm,
    output reg [7:0] 		ss
);// 

    //ss cnt
    wire ss_en_l;
    wire ss_en_h;
    
    assign ss_en_l = ena;
    assign ss_en_h = (ss[3:0] == 4'b1001) && ena;
    
    always @(posedge clk) begin
        if (reset) begin
            ss[3:0] <= 4'h0;
        end else if (ss_en_l) begin
            if (ss[3:0] == 4'b1001)
                ss[3:0] <= 4'd0;
            else 
                ss[3:0] <= ss[3:0] + 1'b1;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            ss[7:4] <= 4'h0;
        end else if (ss_en_h) begin
            if (ss[7:4] == 4'b0101)
                ss[7:4] <= 4'd0;
            else 
                ss[7:4] <= ss[7:4] + 1'b1;
        end
    end
    
    // mm cnt
    wire mm_en_l;
    wire mm_en_h;
    
    assign mm_en_l = ss[7:0] == 8'h59;
    assign mm_en_h = ss[7:0] == 8'h59 && (mm[3:0] == 4'h9);
    
    always @(posedge clk) begin
        if (reset) begin
            mm[3:0] <= 4'h0;
        end else if (mm_en_l) begin
            if (mm[3:0] == 4'b1001)
                mm[3:0] <= 4'd0;
            else 
                mm[3:0] <= mm[3:0] + 1'b1;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            mm[7:4] <= 4'h0;
        end else if (mm_en_h) begin
            if (mm[7:4] == 4'b0101)
                mm[7:4] <= 4'd0;
            else 
                mm[7:4] <= mm[7:4] + 1'b1;
        end
    end   
    
    //hh cnt
    wire hh_en_l;
    wire hh_en_h;
    
    assign hh_en_l = (mm==8'h59) && (ss==8'h59);
    assign hh_en_h = (mm==8'h59) && (ss==8'h59) && (hh[3:0]==4'b1001);
    
    always @(posedge clk) begin
        if (reset) begin
            hh[3:0] <= 4'h2;
        end else if (hh_en_l) begin
            if (hh[7:4] == 4'd0) begin
            	if (hh[3:0] == 4'b1001)
                	hh[3:0] <= 4'd0;
            	else 
                	hh[3:0] <= hh[3:0] + 1'b1;
            end else if (hh[7:4] == 4'd1) begin
                if (hh[3:0] == 4'b0010)
                    hh[3:0] <= 4'd1;
                else
                    hh[3:0] <= hh[3:0] + 1'b1;
            end
        end
    end
    
     always @(posedge clk) begin
        if (reset) begin
            hh[7:4] <= 4'd1;
        end else if (hh[7:0] == 8'h12 && hh_en_l) begin
            hh[7:4] <= 4'd0;
        end else if (hh[7:4]==4'd0 && hh_en_h) begin
            hh[7:4] <= hh[7:4] + 1'b1;
        end
    end   

    //pm flag
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;
        end else if (pm==1'b0 && hh==8'h11 && mm==8'h59 && ss==8'h59) begin
            pm <= 1'b1;
        end else if (pm==1'b1 && hh==8'h11 && mm==8'h59 && ss==8'h59) begin
            pm <= 1'b0;
        end
    end
    
endmodule
