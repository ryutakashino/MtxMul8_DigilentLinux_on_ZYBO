`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 2018/02/28 17:57:12
// Design Name: 
// Module Name: counter
// 
//////////////////////////////////////////////////////////////////////////////////


module COUNTER #(
    parameter CNT_WIDTH = 4
)(
    input  CLK         ,   // in   : System clock
    input  RST         ,   // in   : System reset
    input COUNT_RST    ,   // in   : Count reset
    input  CE          ,   // in   : Clock enable
    input C_IN         ,   // in   : Carry in

    output C_OUT       ,   // out  : Carry out
    output [CNT_WIDTH-1:0] Q     // out  : Count[7:0]
);

//-------- n-bit counter -------------
    reg     [CNT_WIDTH-1:0]   counter;
    //reg                       carry_out;

    always@ (posedge CLK) begin
        if(RST == 1'b0)begin
            counter[CNT_WIDTH-1:0]  <=  {(CNT_WIDTH){1'b0}};
            //carry_out = 1'b0;
		end else if (COUNT_RST) begin
            counter[CNT_WIDTH-1:0]  <=  {(CNT_WIDTH){1'b0}};
            //carry_out = 1'b0;
        end else begin
            if(C_IN & CE)begin
                if (counter[CNT_WIDTH-1:0] == {(CNT_WIDTH){1'b1}} ) begin
                    counter[CNT_WIDTH-1:0]  <= {(CNT_WIDTH){1'b0}};
                    //carry_out               <= 1'b1;
                end else begin
                    counter[CNT_WIDTH-1:0]  <= counter[CNT_WIDTH-1:0] + {{(CNT_WIDTH-1){1'b0}},1'd1};
                    //carry_out               <= 1'b0;  
                end
            end else begin
                counter[CNT_WIDTH-1:0]  <= counter[CNT_WIDTH-1:0];
                //carry_out               <= carry_out;  
            end
        end
    end

    assign Q[CNT_WIDTH-1:0] = counter[CNT_WIDTH-1:0];
    assign C_OUT = C_IN  &  (counter[CNT_WIDTH-1:0] == {(CNT_WIDTH){1'b1}} );

endmodule