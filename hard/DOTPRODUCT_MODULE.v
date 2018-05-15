module DOTPRODUCT_MODULE(
        input ACLK, ARESETN,
        input [5:0] DEST_I,
        input [31:0] A_ELEM0, A_ELEM1, A_ELEM2, A_ELEM3, A_ELEM4, A_ELEM5, A_ELEM6, A_ELEM7, 
        input [31:0] B_ELEM0, B_ELEM1, B_ELEM2, B_ELEM3, B_ELEM4, B_ELEM5, B_ELEM6, B_ELEM7, 
        output reg [31:0] DOT_PRODUCT,
        output reg [5:0] DEST_O
    );

    reg [ 5 :0] dest_pipline0, dest_pipline1;
    reg [31:0] product0, product1, product2, product3, product4, product5, product6, product7;


//1st
    always @(posedge ACLK) begin
      if (ARESETN == 1'b0) begin
        dest_pipline0 <= 0;
        product0 <= 0;
        product1 <= 0;
        product2 <= 0;
        product3 <= 0;
        product4 <= 0;
        product5 <= 0;
        product6 <= 0;
        product7 <= 0;
      end
      else begin
        dest_pipline0 <= DEST_I;
        product0 <= A_ELEM0 * B_ELEM0;
        product1 <= A_ELEM1 * B_ELEM1;
        product2 <= A_ELEM2 * B_ELEM2;
        product3 <= A_ELEM3 * B_ELEM3;
        product4 <= A_ELEM4 * B_ELEM4;
        product5 <= A_ELEM5 * B_ELEM5;
        product6 <= A_ELEM6 * B_ELEM6;
        product7 <= A_ELEM7 * B_ELEM7;
      end
    end


// 2 th
    reg [31:0] tmp_sum0_0, tmp_sum0_1, tmp_sum0_2;
    always @(posedge ACLK) begin
      if (ARESETN == 1'b0) begin
        dest_pipline1 <= 0; 
        tmp_sum0_0 <= 0;
        tmp_sum0_1 <= 0;
        tmp_sum0_2 <= 0;
      end
      else begin
        dest_pipline1 <= dest_pipline0;
        tmp_sum0_0 <= product0 + product1 + product2;
        tmp_sum0_1 <= product3 + product4 + product5;
        tmp_sum0_2 <= product6 + product7;
      end
    end

// 3 th
    always @(posedge ACLK) begin
      if (ARESETN == 1'b0) begin
        DEST_O <= 0; 
        DOT_PRODUCT <= 0;
      end
      else begin
        DEST_O <= dest_pipline1;
        DOT_PRODUCT <= tmp_sum0_0 + tmp_sum0_1 + tmp_sum0_2;
      end
    end

endmodule

