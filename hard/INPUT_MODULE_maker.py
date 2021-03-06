n = int( input() )

import math

# 2つの行列要素と計算開始命令のためのアドレスサイズreg_addr_sizeを求める．
# このセレクタは0から2(n^2)の合計2(n^2)+1個を区別する．2(n^2)を表現可能なビットサイズを求める
reg_addr_size = math.ceil( math.log2(2*n**2 + 1) )    
# この値は4Bの入力データの識別アドレス.ARMからは1Bに1アドレスで送られる．そのため下位2bitを加える。
reg_addr_size +=2;

# input_moduleから内積計算のための要素を取得する際のアドレスサイズnselect_sizeを求める．
# このセレクタは0からn-1の合計n個を区別する．n-1を表現可能なビットサイズを求める
nselect_size = math.ceil( math.log2(n) )


print("module INPUT_MODULE #")
print("	(")
print("		parameter integer C_S_AXI_DATA_WIDTH	= 32,")
print("		// Width of S_AXI address bus")
print("		parameter integer C_S_AXI_ADDR_WIDTH	=", reg_addr_size,"")
print("	)")
print("	(")
print("		output wire C_START,")
print("		input wire [",nselect_size-1,":0] A_SELECT,",sep='')
print("		input wire [",nselect_size-1,":0] B_SELECT,",sep='')

for i in range(n):
    print("		output wire [31:0] REG_DATA_A", i,",",sep='')
for i in range(n):
    print("		output wire [31:0] REG_DATA_B", i,",",sep='')
print("		// Global Clock Signal")
print("		input wire  S_AXI_ACLK,")
print("		// Global Reset Signal. This Signal is Active LOW")
print("		input wire  S_AXI_ARESETN,")
print("		// Write address (issued by master, acceped by Slave)")
print("		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,")
print("		// Write channel Protection type. This signal indicates the")
print("    		// privilege and security level of the transaction, and whether")
print("    		// the transaction is a data access or an instruction access.")
print("		input wire [2:0] S_AXI_AWPROT,")
print("		// Write address valid. This signal indicates that the master signaling")
print("    		// valid write address and control information.")
print("		input wire  S_AXI_AWVALID,")
print("		// Write address ready. This signal indicates that the slave is ready")
print("    		// to accept an address and associated control signals.")
print("		output wire  S_AXI_AWREADY,")
print("		// Write data (issued by master, acceped by Slave) ")
print("		input wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,")
print("		// Write strobes. This signal indicates which byte lanes hold")
print("    		// valid data. There is one write strobe bit for each eight")
print("    		// bits of the write data bus.    ")
print("		input wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,")
print("		// Write valid. This signal indicates that valid write")
print("    		// data and strobes are available.")
print("		input wire  S_AXI_WVALID,")
print("		// Write ready. This signal indicates that the slave")
print("    		// can accept the write data.")
print("		output wire  S_AXI_WREADY,")
print("		// Write response. This signal indicates the status")
print("    		// of the write transaction.")
print("		output wire [1:0] S_AXI_BRESP,")
print("		// Write response valid. This signal indicates that the channel")
print("    		// is signaling a valid write response.")
print("		output wire  S_AXI_BVALID,")
print("		// Response ready. This signal indicates that the master")
print("    		// can accept a write response.")
print("		input wire  S_AXI_BREADY")
print("	);\n\n")

print("	// AXI4LITE signals")
print("	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;")
print("	reg  	axi_awready;")
print("	reg  	axi_wready;")
print("	reg [1 : 0] 	axi_bresp;")
print("	reg  	axi_bvalid;")
print("")
print("")
print("	// ADDR_LSB is used for addressing 32/64 bit registers/memories")
print("	// ADDR_LSB = 2 for 32 bits (n downto 2)")
print("	// ADDR_LSB = 3 for 64 bits (n downto 3)")
print("	localparam integer ADDR_LSB = 2;")
print("	//----------------------------------------------")
print("	//-- Signals for user logic register space example")
print("	//------------------------------------------------")

for i in range(2*n**2+1):
    print("    reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg", i,";",sep='')
    
print("	wire	 slv_reg_wren;")
print("	integer	 byte_index;")
print("	reg	 aw_en;")
print("")
print("	// I/O Connections assignments")
print("")
print("	assign S_AXI_AWREADY	= axi_awready;")
print("	assign S_AXI_WREADY	= axi_wready;")
print("	assign S_AXI_BRESP	= axi_bresp;")
print("	assign S_AXI_BVALID	= axi_bvalid;")
print("")
print("	// Implement axi_awready generation")
print("	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both")
print("	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is")
print("	// de-asserted when reset is low.")
print("")
print("	always @( posedge S_AXI_ACLK )")
print("	begin")
print("	  if ( S_AXI_ARESETN == 1'b0 )")
print("	    begin")
print("	      axi_awready <= 1'b0;")
print("	      aw_en <= 1'b1;")
print("	    end ")
print("	  else")
print("	    begin    ")
print("	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)")
print("	        begin")
print("	          // slave is ready to accept write address when ")
print("	          // there is a valid write address and write data")
print("	          // on the write address and data bus. This design ")
print("	          // expects no outstanding transactions. ")
print("	          axi_awready <= 1'b1;")
print("	          aw_en <= 1'b0;")
print("	        end")
print("	        else if (S_AXI_BREADY && axi_bvalid)")
print("	            begin")
print("	              aw_en <= 1'b1;")
print("	              axi_awready <= 1'b0;")
print("	            end")
print("	      else           ")
print("	        begin")
print("	          axi_awready <= 1'b0;")
print("	        end")
print("	    end ")
print("	end       ")
print("")
print("	// Implement axi_awaddr latching")
print("	// This process is used to latch the address when both ")
print("	// S_AXI_AWVALID and S_AXI_WVALID are valid. ")
print("")
print("	always @( posedge S_AXI_ACLK )")
print("	begin")
print("	  if ( S_AXI_ARESETN == 1'b0 )")
print("	    begin")
print("	      axi_awaddr <= 0;")
print("	    end ")
print("	  else")
print("	    begin    ")
print("	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)")
print("	        begin")
print("	          // Write Address latching ")
print("	          axi_awaddr <= S_AXI_AWADDR;")
print("	        end")
print("	    end ")
print("	end       ")
print("")
print("	// Implement axi_wready generation")
print("	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both")
print("	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is ")
print("	// de-asserted when reset is low. ")
print("")
print("	always @( posedge S_AXI_ACLK )")
print("	begin")
print("	  if ( S_AXI_ARESETN == 1'b0 )")
print("	    begin")
print("	      axi_wready <= 1'b0;")
print("	    end ")
print("	  else")
print("	    begin    ")
print("	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )")
print("	        begin")
print("	          // slave is ready to accept write data when ")
print("	          // there is a valid write address and write data")
print("	          // on the write address and data bus. This design ")
print("	          // expects no outstanding transactions. ")
print("	          axi_wready <= 1'b1;")
print("	        end")
print("	      else")
print("	        begin")
print("	          axi_wready <= 1'b0;")
print("	        end")
print("	    end ")
print("	end       ")
print("")
print("	// Implement memory mapped register select and write logic generation")
print("	// The write data is accepted and written to memory mapped registers when")
print("	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to")
print("	// select byte enables of slave registers while writing.")
print("	// These registers are cleared when reset (active low) is applied.")
print("	// Slave register write enable is asserted when valid address and data are available")
print("	// and the slave is ready to accept the write address and write data.")
print("	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;")

print("	always @( posedge S_AXI_ACLK )")
print("	begin")
print("	  if ( S_AXI_ARESETN == 1'b0 )")
print("	    begin")

for i in range(2*n**2+1):
    print("	      slv_reg", i," <= 0;",sep='')
    
print("	    end ")
print("	  else begin")
print("	    if (slv_reg_wren)")
print("	      begin")
# reg_addr_sizeは必要なアドレスのbit数．各アドレスが32bitのため，2bit増やす．
print("	        case ( axi_awaddr[", reg_addr_size-1 ,":ADDR_LSB] )",sep='')


for i in range(2*n**2+1):
    # 動的に0埋めを行う．binの出力は0b...の形のため，３文字目以降を利用する．
    # https://qiita.com/shirakiya/items/b1581b29869434d2a8ae
    output = (hex(i)[2:].zfill(-(-reg_addr_size // 4)-1)).upper()
    print("	          ",reg_addr_size-2,"\'h",output,":",sep='')
    print("	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )")
    print("	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin")
    print("	                // Respective byte enables are asserted as per write strobes ")
    print("	                slv_reg",i,"[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];",sep='')
    print("	              end  ")

print("	          default : begin")
for i in range(2*n**2+1):
    print("	                slv_reg",i," <= slv_reg",i,";",sep='')
print("	          end")


print("	        endcase")
print("	      end")
print("	  end")
print("	end")
print("	")
print("	")
print("	// Implement write response logic generation")
print("	// The write response and response valid signals are asserted by the slave ")
print("	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  ")
print("	// This marks the acceptance of address and indicates the status of ")
print("	// write transaction.")
print("")
print("	always @( posedge S_AXI_ACLK )")
print("	begin")
print("	  if ( S_AXI_ARESETN == 1'b0 )")
print("	    begin")
print("	      axi_bvalid  <= 0;")
print("	      axi_bresp   <= 2'b0;")
print("	    end ")
print("	  else")
print("	    begin    ")
print("	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)")
print("	        begin")
print("	          // indicates a valid write response is available")
print("	          axi_bvalid <= 1'b1;")
print("	          axi_bresp  <= 2'b0; // 'OKAY' response ")
print("	        end                   // work error responses in future")
print("	      else")
print("	        begin")
print("	          if (S_AXI_BREADY && axi_bvalid) ")
print("	            //check if bready is asserted while bvalid is high) ")
print("	            //(there is a possibility that bready is always asserted high)   ")
print("	            begin")
print("	              axi_bvalid <= 1'b0; ")
print("	            end  ")
print("	        end")
print("	    end")
print("	end   ")
print("	")
print("	")
print("	//One Shot Generator")
print("    reg c_start_plus;")
print("    assign C_START = c_start_plus;")
print("    always @( posedge S_AXI_ACLK )")
print("    begin")
print("        if ( S_AXI_ARESETN == 1'b0 ) begin")
print("            c_start_plus <= 0;")
print("        end else begin")
print("            if (slv_reg_wren & (axi_awaddr[",reg_addr_size-1,":ADDR_LSB] == ",reg_addr_size-2,"\'h00) ) begin //One Shot Generator")
print("                c_start_plus <=  S_AXI_WDATA[0];")
print("            end else begin          ")
print("                c_start_plus <= 1'b0;")
print("            end")
print("        end")
print("    end")

print("\n")
print("    function [C_S_AXI_DATA_WIDTH-1:0] select",n,";",sep='')
print("        input [",nselect_size-1,":0] select;",sep='')
print("        input [C_S_AXI_DATA_WIDTH-1:0] ",end='')
for i in range(n):
    print("in",i,sep='',end='');
    if (i==n-1): print(";")
    else: print(", ", end='')
print("        case (select)")
for i in range(n):\
    # 動的に0埋めを行う．binの出力は0b...の形のため，３文字目以降を利用する．
    # https://qiita.com/shirakiya/items/b1581b29869434d2a8ae
    output = bin(i)[2:].zfill(nselect_size)
    print("            ",nselect_size,"\'b", output,sep='',end='');
    print(": select",n, " = in", i, ";", sep='')
print("        endcase")
print("    endfunction")


print("\n\n")

for i in range(n):
  print("    assign REG_DATA_A",i, " = select",n,"(A_SELECT,",sep='')
  for j in range(n):
    print("slv_reg",1+i+j*n,sep='',end='');
    if (j==n-1): print(");")
    else: print(", ", end='')
  print()

# print("\n\n")
    
for i in range(n):
  print("    assign REG_DATA_B",i, " = select",n,"(B_SELECT,",sep='')
  for j in range(n):
    print("slv_reg",n**2+1+i*n+j,sep='',end='');
    if (j==n-1): print(");")
    else: print(", ", end='')
  print()
    
print("endmodule")
