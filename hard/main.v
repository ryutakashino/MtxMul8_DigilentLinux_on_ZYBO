`timescale 1 ns / 1 ps

module MODULE_AXILite_v1_0 #(
    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH    = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH    = 10  
)(


    // Ports of Axi Slave Bus Interface S00_AXI
    input wire  s00_axi_aclk,
    input wire  s00_axi_aresetn,
    input wire [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_awaddr,
    input wire [2:0] s00_axi_awprot,
    input wire  s00_axi_awvalid,
    output wire  s00_axi_awready,
    input wire [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb,
    input wire  s00_axi_wvalid,
    output wire  s00_axi_wready,
    output wire [1:0] s00_axi_bresp,
    output wire  s00_axi_bvalid,
    input wire  s00_axi_bready,
    input wire [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_araddr,
    input wire [2:0] s00_axi_arprot,
    input wire  s00_axi_arvalid,
    output wire  s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_rdata,
    output wire [1:0] s00_axi_rresp,
    output wire  s00_axi_rvalid,
    input wire  s00_axi_rready,

    // Users to add ports here
    output wire [1:0] led,
    output wire [63:0] cycle,
    output wire overflow
);
        
	//INPUT_MODULE instance signals
    wire  c_start;
    wire [2:0] a_select;
    wire [2:0] b_select;
    
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a0;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a1;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a2;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a3;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a4;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a5;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a6;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_a7;
    
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b0;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b1;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b2;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b3;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b4;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b5;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b6;
    wire [C_S00_AXI_DATA_WIDTH-1:0] reg_data_b7;
    
    INPUT_MODULE #(
         .C_S_AXI_DATA_WIDTH( C_S00_AXI_DATA_WIDTH )
        ,.C_S_AXI_ADDR_WIDTH( C_S00_AXI_ADDR_WIDTH )
    ) in_unit (
         .C_START( c_start )
        ,.A_SELECT( a_select )
        ,.B_SELECT( b_select )
    
        ,.REG_DATA_A0( reg_data_a0 )
        ,.REG_DATA_A1( reg_data_a1 )
        ,.REG_DATA_A2( reg_data_a2 )
        ,.REG_DATA_A3( reg_data_a3 )
        ,.REG_DATA_A4( reg_data_a4 )
        ,.REG_DATA_A5( reg_data_a5 )
        ,.REG_DATA_A6( reg_data_a6 )
        ,.REG_DATA_A7( reg_data_a7 )
    
        ,.REG_DATA_B0( reg_data_b0 )
        ,.REG_DATA_B1( reg_data_b1 )
        ,.REG_DATA_B2( reg_data_b2 )
        ,.REG_DATA_B3( reg_data_b3 )
        ,.REG_DATA_B4( reg_data_b4 )
        ,.REG_DATA_B5( reg_data_b5 )
        ,.REG_DATA_B6( reg_data_b6 )
        ,.REG_DATA_B7( reg_data_b7 )
    
        ,.S_AXI_ACLK( s00_axi_aclk )
        ,.S_AXI_ARESETN( s00_axi_aresetn )
        ,.S_AXI_AWADDR( s00_axi_awaddr )
        ,.S_AXI_AWPROT( s00_axi_awprot )
        ,.S_AXI_AWVALID( s00_axi_awvalid )
        ,.S_AXI_AWREADY( s00_axi_awready )
        ,.S_AXI_WDATA( s00_axi_wdata )
        ,.S_AXI_WSTRB( s00_axi_wstrb )
        ,.S_AXI_WVALID( s00_axi_wvalid )
        ,.S_AXI_WREADY( s00_axi_wready )
        ,.S_AXI_BRESP( s00_axi_bresp )
        ,.S_AXI_BVALID( s00_axi_bvalid )
        ,.S_AXI_BREADY( s00_axi_bready )
    );
    
    
    
    //Ctrl
    wire [5:0] select;
    wire end_signal;
    CTRL_MODULE ctrl_unit (
         .ACLK( s00_axi_aclk )
        ,.ARESETN( s00_axi_aresetn )
        ,.C_START( c_start )
        ,.A_SELECT( a_select )
        ,.B_SELECT( b_select )
        ,.SELECT( select )
        ,.END_SIGNAL( end_signal )
    );
    //DOTPRODUCT
    wire [C_S00_AXI_DATA_WIDTH-1:0] dot_product;
    wire [5:0] dest_o;
    DOTPRODUCT_MODULE product_unit (
         .ACLK( s00_axi_aclk )
        ,.ARESETN( s00_axi_aresetn )
        ,.DEST_I( select )
    
        ,.A_ELEM0( reg_data_a0 )
        ,.A_ELEM1( reg_data_a1 )
        ,.A_ELEM2( reg_data_a2 )
        ,.A_ELEM3( reg_data_a3 )
        ,.A_ELEM4( reg_data_a4 )
        ,.A_ELEM5( reg_data_a5 )
        ,.A_ELEM6( reg_data_a6 )
        ,.A_ELEM7( reg_data_a7 )
    
        ,.B_ELEM0( reg_data_b0 )
        ,.B_ELEM1( reg_data_b1 )
        ,.B_ELEM2( reg_data_b2 )
        ,.B_ELEM3( reg_data_b3 )
        ,.B_ELEM4( reg_data_b4 )
        ,.B_ELEM5( reg_data_b5 )
        ,.B_ELEM6( reg_data_b6 )
        ,.B_ELEM7( reg_data_b7 )
    
        ,.DOT_PRODUCT( dot_product )
        ,.DEST_O( dest_o )
    );
    //OUTPUT
    OUTPUT_MODULE #(
         .C_S_AXI_DATA_WIDTH( C_S00_AXI_DATA_WIDTH )
        ,.C_S_AXI_ADDR_WIDTH( C_S00_AXI_ADDR_WIDTH )
    ) out_unit (
         .C_START( c_start )
        ,.SELECT( dest_o )
        ,.DOT_PRODUCT( dot_product )
        ,.STATUS( led )
        ,.END_SIGNAL( end_signal )
        ,.S_AXI_ACLK( s00_axi_aclk )
        ,.S_AXI_ARESETN( s00_axi_aresetn )
        ,.S_AXI_ARADDR( s00_axi_araddr )
        ,.S_AXI_ARPROT( s00_axi_arprot )
        ,.S_AXI_ARVALID( s00_axi_arvalid )
        ,.S_AXI_ARREADY( s00_axi_arready )
        ,.S_AXI_RDATA( s00_axi_rdata )
        ,.S_AXI_RRESP( s00_axi_rresp )
        ,.S_AXI_RVALID( s00_axi_rvalid )
        ,.S_AXI_RREADY( s00_axi_rready )
    );
    
    
    COUNTER #(
         .CNT_WIDTH( 64 )
    ) CYCLE_COUNTER (
         .CLK( s00_axi_aclk )
        ,.RST( s00_axi_aresetn )
        ,.COUNT_RST( c_start )
        ,.CE( 1'b1 )
        ,.C_IN( 1'b1 )
        ,.C_OUT( overflow )
        ,.Q( cycle )
    );    
endmodule
