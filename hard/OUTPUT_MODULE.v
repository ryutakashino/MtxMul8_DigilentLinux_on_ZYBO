module OUTPUT_MODULE #
    (
		// Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH    = 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 10 
    )(
    input C_START,
    input [5:0] SELECT,
    input END_SIGNAL,
    input [C_S_AXI_DATA_WIDTH-1:0] DOT_PRODUCT,
    output [1:0] STATUS,

    // Global Clock Signal
    input wire  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input wire  S_AXI_ARESETN,

    // Read address (issued by master, acceped by Slave)
    input wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    input wire [2:0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input wire  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output wire  S_AXI_ARREADY,
    // Read data (issued by slave)
    output wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output wire [1:0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output wire  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input wire  S_AXI_RREADY
    );


	// AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1:0]     axi_araddr;
    reg      axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1:0]     axi_rdata;
    reg [1:0]     axi_rresp;
    reg      axi_rvalid;

	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = 2;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg21;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg22;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg23;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg24;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg25;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg26;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg27;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg28;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg29;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg30;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg31;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg32;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg33;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg34;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg35;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg36;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg37;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg38;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg39;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg40;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg41;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg42;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg43;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg44;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg45;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg46;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg47;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg48;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg49;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg50;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg51;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg52;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg53;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg54;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg55;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg56;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg57;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg58;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg59;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg60;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg61;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg62;
    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg63;
  	wire	 slv_reg_rden;
    reg [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;

    // I/O Connections assignments
    assign S_AXI_ARREADY    = axi_arready;
    assign S_AXI_RDATA    = axi_rdata;
    assign S_AXI_RRESP    = axi_rresp;
    assign S_AXI_RVALID    = axi_rvalid;    
   // ***READ***
    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXI_ACLK clock cycle when
    // S_AXI_ARVALID is asserted. axi_awready is 
    // de-asserted when reset (active low) is asserted. 
    // The read address is also latched when S_AXI_ARVALID is 
    // asserted. axi_araddr is reset to zero on reset assertion.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_arready <= 1'b0;
          axi_araddr  <= 32'b0;
        end 
      else
        begin    
          if (~axi_arready && S_AXI_ARVALID)
            begin
              // indicates that the slave has acceped the valid read address
              axi_arready <= 1'b1;
              // Read address latching
              axi_araddr  <= S_AXI_ARADDR;
            end
          else
            begin
              axi_arready <= 1'b0;
            end
        end 
    end       

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    // data are available on the axi_rdata bus at this instance. The 
    // assertion of axi_rvalid marks the validity of read data on the 
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    // is deasserted on reset (active low). axi_rresp and axi_rdata are 
    // cleared to zero on reset (active low).  
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rvalid <= 0;
          axi_rresp  <= 0;
        end 
      else
        begin    
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
              // Valid read data is available at the read data bus
              axi_rvalid <= 1'b1;
              axi_rresp  <= 2'b0; // 'OKAY' response
            end   
          else if (axi_rvalid && S_AXI_RREADY)
            begin
              // Read data is accepted by the master
              axi_rvalid <= 1'b0;
            end
        end
    end


     // To show calcuration status
     reg [1:0] status; // IDLE:00, DO:01, END:11

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    always @(*)
    begin
          // Address decoding for reading registers
	        case ( axi_araddr[C_S_AXI_ADDR_WIDTH-1:ADDR_LSB] )
              8'h000:reg_data_out <= status;
              8'h001: reg_data_out <= slv_reg0;
              8'h002: reg_data_out <= slv_reg1;
              8'h003: reg_data_out <= slv_reg2;
              8'h004: reg_data_out <= slv_reg3;
              8'h005: reg_data_out <= slv_reg4;
              8'h006: reg_data_out <= slv_reg5;
              8'h007: reg_data_out <= slv_reg6;
              8'h008: reg_data_out <= slv_reg7;
              8'h009: reg_data_out <= slv_reg8;
              8'h00a: reg_data_out <= slv_reg9;
              8'h00b: reg_data_out <= slv_reg10;
              8'h00c: reg_data_out <= slv_reg11;
              8'h00d: reg_data_out <= slv_reg12;
              8'h00e: reg_data_out <= slv_reg13;
              8'h00f: reg_data_out <= slv_reg14;
              8'h010: reg_data_out <= slv_reg15;
              8'h011: reg_data_out <= slv_reg16;
              8'h012: reg_data_out <= slv_reg17;
              8'h013: reg_data_out <= slv_reg18;
              8'h014: reg_data_out <= slv_reg19;
              8'h015: reg_data_out <= slv_reg20;
              8'h016: reg_data_out <= slv_reg21;
              8'h017: reg_data_out <= slv_reg22;
              8'h018: reg_data_out <= slv_reg23;
              8'h019: reg_data_out <= slv_reg24;
              8'h01a: reg_data_out <= slv_reg25;
              8'h01b: reg_data_out <= slv_reg26;
              8'h01c: reg_data_out <= slv_reg27;
              8'h01d: reg_data_out <= slv_reg28;
              8'h01e: reg_data_out <= slv_reg29;
              8'h01f: reg_data_out <= slv_reg30;
              8'h020: reg_data_out <= slv_reg31;
              8'h021: reg_data_out <= slv_reg32;
              8'h022: reg_data_out <= slv_reg33;
              8'h023: reg_data_out <= slv_reg34;
              8'h024: reg_data_out <= slv_reg35;
              8'h025: reg_data_out <= slv_reg36;
              8'h026: reg_data_out <= slv_reg37;
              8'h027: reg_data_out <= slv_reg38;
              8'h028: reg_data_out <= slv_reg39;
              8'h029: reg_data_out <= slv_reg40;
              8'h02a: reg_data_out <= slv_reg41;
              8'h02b: reg_data_out <= slv_reg42;
              8'h02c: reg_data_out <= slv_reg43;
              8'h02d: reg_data_out <= slv_reg44;
              8'h02e: reg_data_out <= slv_reg45;
              8'h02f: reg_data_out <= slv_reg46;
              8'h030: reg_data_out <= slv_reg47;
              8'h031: reg_data_out <= slv_reg48;
              8'h032: reg_data_out <= slv_reg49;
              8'h033: reg_data_out <= slv_reg50;
              8'h034: reg_data_out <= slv_reg51;
              8'h035: reg_data_out <= slv_reg52;
              8'h036: reg_data_out <= slv_reg53;
              8'h037: reg_data_out <= slv_reg54;
              8'h038: reg_data_out <= slv_reg55;
              8'h039: reg_data_out <= slv_reg56;
              8'h03a: reg_data_out <= slv_reg57;
              8'h03b: reg_data_out <= slv_reg58;
              8'h03c: reg_data_out <= slv_reg59;
              8'h03d: reg_data_out <= slv_reg60;
              8'h03e: reg_data_out <= slv_reg61;
              8'h03f: reg_data_out <= slv_reg62;
              8'h040: reg_data_out <= slv_reg63;
              default : reg_data_out <= 32'hFFFF;
          endcase
    end
    
    // Output register or memory read data
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rdata  <= 0;
        end 
      else
        begin    
          // When there is a valid read address (S_AXI_ARVALID) with 
          // acceptance of read address by the slave (axi_arready), 
          // output the read dada 
          if (slv_reg_rden)
            begin
              axi_rdata <= reg_data_out;     // register read data
            end   
        end
    end

    always @( posedge S_AXI_ACLK )
    begin
        if ( S_AXI_ARESETN == 1'b0 )
        begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	      slv_reg8 <= 0;
	      slv_reg9 <= 0;
	      slv_reg10 <= 0;
	      slv_reg11 <= 0;
	      slv_reg12 <= 0;
	      slv_reg13 <= 0;
	      slv_reg14 <= 0;
	      slv_reg15 <= 0;
	      slv_reg16 <= 0;
	      slv_reg17 <= 0;
	      slv_reg18 <= 0;
	      slv_reg19 <= 0;
	      slv_reg20 <= 0;
	      slv_reg21 <= 0;
	      slv_reg22 <= 0;
	      slv_reg23 <= 0;
	      slv_reg24 <= 0;
	      slv_reg25 <= 0;
	      slv_reg26 <= 0;
	      slv_reg27 <= 0;
	      slv_reg28 <= 0;
	      slv_reg29 <= 0;
	      slv_reg30 <= 0;
	      slv_reg31 <= 0;
	      slv_reg32 <= 0;
	      slv_reg33 <= 0;
	      slv_reg34 <= 0;
	      slv_reg35 <= 0;
	      slv_reg36 <= 0;
	      slv_reg37 <= 0;
	      slv_reg38 <= 0;
	      slv_reg39 <= 0;
	      slv_reg40 <= 0;
	      slv_reg41 <= 0;
	      slv_reg42 <= 0;
	      slv_reg43 <= 0;
	      slv_reg44 <= 0;
	      slv_reg45 <= 0;
	      slv_reg46 <= 0;
	      slv_reg47 <= 0;
	      slv_reg48 <= 0;
	      slv_reg49 <= 0;
	      slv_reg50 <= 0;
	      slv_reg51 <= 0;
	      slv_reg52 <= 0;
	      slv_reg53 <= 0;
	      slv_reg54 <= 0;
	      slv_reg55 <= 0;
	      slv_reg56 <= 0;
	      slv_reg57 <= 0;
	      slv_reg58 <= 0;
	      slv_reg59 <= 0;
	      slv_reg60 <= 0;
	      slv_reg61 <= 0;
	      slv_reg62 <= 0;
	      slv_reg63 <= 0;
      end
    else begin
         case (SELECT)
	          6'h00: slv_reg0 <= DOT_PRODUCT;
	          6'h01: slv_reg1 <= DOT_PRODUCT;
	          6'h02: slv_reg2 <= DOT_PRODUCT;
	          6'h03: slv_reg3 <= DOT_PRODUCT;
	          6'h04: slv_reg4 <= DOT_PRODUCT;
	          6'h05: slv_reg5 <= DOT_PRODUCT;
	          6'h06: slv_reg6 <= DOT_PRODUCT;
	          6'h07: slv_reg7 <= DOT_PRODUCT;
	          6'h08: slv_reg8 <= DOT_PRODUCT;
	          6'h09: slv_reg9 <= DOT_PRODUCT;
	          6'h0a: slv_reg10 <= DOT_PRODUCT;
	          6'h0b: slv_reg11 <= DOT_PRODUCT;
	          6'h0c: slv_reg12 <= DOT_PRODUCT;
	          6'h0d: slv_reg13 <= DOT_PRODUCT;
	          6'h0e: slv_reg14 <= DOT_PRODUCT;
	          6'h0f: slv_reg15 <= DOT_PRODUCT;
	          6'h10: slv_reg16 <= DOT_PRODUCT;
	          6'h11: slv_reg17 <= DOT_PRODUCT;
	          6'h12: slv_reg18 <= DOT_PRODUCT;
	          6'h13: slv_reg19 <= DOT_PRODUCT;
	          6'h14: slv_reg20 <= DOT_PRODUCT;
	          6'h15: slv_reg21 <= DOT_PRODUCT;
	          6'h16: slv_reg22 <= DOT_PRODUCT;
	          6'h17: slv_reg23 <= DOT_PRODUCT;
	          6'h18: slv_reg24 <= DOT_PRODUCT;
	          6'h19: slv_reg25 <= DOT_PRODUCT;
	          6'h1a: slv_reg26 <= DOT_PRODUCT;
	          6'h1b: slv_reg27 <= DOT_PRODUCT;
	          6'h1c: slv_reg28 <= DOT_PRODUCT;
	          6'h1d: slv_reg29 <= DOT_PRODUCT;
	          6'h1e: slv_reg30 <= DOT_PRODUCT;
	          6'h1f: slv_reg31 <= DOT_PRODUCT;
	          6'h20: slv_reg32 <= DOT_PRODUCT;
	          6'h21: slv_reg33 <= DOT_PRODUCT;
	          6'h22: slv_reg34 <= DOT_PRODUCT;
	          6'h23: slv_reg35 <= DOT_PRODUCT;
	          6'h24: slv_reg36 <= DOT_PRODUCT;
	          6'h25: slv_reg37 <= DOT_PRODUCT;
	          6'h26: slv_reg38 <= DOT_PRODUCT;
	          6'h27: slv_reg39 <= DOT_PRODUCT;
	          6'h28: slv_reg40 <= DOT_PRODUCT;
	          6'h29: slv_reg41 <= DOT_PRODUCT;
	          6'h2a: slv_reg42 <= DOT_PRODUCT;
	          6'h2b: slv_reg43 <= DOT_PRODUCT;
	          6'h2c: slv_reg44 <= DOT_PRODUCT;
	          6'h2d: slv_reg45 <= DOT_PRODUCT;
	          6'h2e: slv_reg46 <= DOT_PRODUCT;
	          6'h2f: slv_reg47 <= DOT_PRODUCT;
	          6'h30: slv_reg48 <= DOT_PRODUCT;
	          6'h31: slv_reg49 <= DOT_PRODUCT;
	          6'h32: slv_reg50 <= DOT_PRODUCT;
	          6'h33: slv_reg51 <= DOT_PRODUCT;
	          6'h34: slv_reg52 <= DOT_PRODUCT;
	          6'h35: slv_reg53 <= DOT_PRODUCT;
	          6'h36: slv_reg54 <= DOT_PRODUCT;
	          6'h37: slv_reg55 <= DOT_PRODUCT;
	          6'h38: slv_reg56 <= DOT_PRODUCT;
	          6'h39: slv_reg57 <= DOT_PRODUCT;
	          6'h3a: slv_reg58 <= DOT_PRODUCT;
	          6'h3b: slv_reg59 <= DOT_PRODUCT;
	          6'h3c: slv_reg60 <= DOT_PRODUCT;
	          6'h3d: slv_reg61 <= DOT_PRODUCT;
	          6'h3e: slv_reg62 <= DOT_PRODUCT;
	          6'h3f: slv_reg63 <= DOT_PRODUCT;
            default :;   
          endcase
        end
    end
   
    //add 12/24
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 ) begin
        status  <= 2'b00;
      end else begin
        if (C_START) status <= 2'b01;
        else if (END_SIGNAL) status <= 2'b11;
        else status <= status;
      end
    end
    
    assign STATUS = status[1:0];

       
endmodule
