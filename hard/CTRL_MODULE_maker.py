n=int(input())
   

import math

# 内積結果をoutput_moduleへ格納する際のアドレスサイズselect_sizeを求める．
# このセレクタは0からn^2-1の合計n^2個を区別する．n^2-1を表現可能なビットサイズを求める
select_size = math.ceil( math.log2(n**2) )

# input_moduleから内積計算のための要素を取得する際のアドレスサイズnselect_sizeを求める．
# このセレクタは0からn-1の合計n個を区別する．n-1を表現可能なビットサイズを求める
nselect_size = math.ceil( math.log2(n) )

print("module CTRL_MODULE(")
print("    input ACLK, ARESETN,")
print("    input C_START,")
print("")
print("    output wire [",nselect_size-1,":0] A_SELECT,",sep='')
print("    output wire [",nselect_size-1,":0] B_SELECT,",sep='')
print("    output wire [",select_size-1,":0] SELECT,",sep='')
print("    output END_SIGNAL")
print("    );")
print("")
print("    reg [",nselect_size-1,":0] a_select;",sep='')
print("    reg [",nselect_size-1,":0] b_select;",sep='')
print("    reg [",select_size-1,":0] select;")
print("    assign A_SELECT = a_select;")
print("    assign B_SELECT = b_select;")
print("    assign SELECT = select;")
print("    ")
print("    reg [",select_size-1,":0] STATE;",sep='')

for i in range(n**2):
    # 16進数の桁数は2進数の桁数を4で割って切り上げた数に等しい
    output = hex(i)[2:].zfill(-(-select_size // 4))
    print("    `define P",i," ",select_size,"\'h",output,sep='')
    #print ("    `define P", i, " 6'b"'{:>06b}'.format(i), ";",sep=''); 
    
print("    always @(posedge ACLK)")
print("        begin: state_machine")
print("            if (ARESETN == 1'b0) begin")
print("                STATE <= `P0;")
print("                a_select <= ",nselect_size,"'b0;")
print("                b_select <= ",nselect_size,"'b0;")
print("                select <= ",select_size,"'d0;")
print("            end else begin")
print("                case (STATE)")

print("                    `P0: begin")
print("                        if (C_START) begin")
print("                            a_select <= ",nselect_size,"'b0;")
print("                            b_select <= ",nselect_size,"'b0;")
print("                            select <= ",select_size,"'d0;")
print("                            STATE <= `P1;")
print("                        end else begin")
print("                            STATE <= `P0;")
print("                        end")
print("                    end")

for i in range(n):
    for j in range(n):
        if (i==0 and j==0): continue

        print ("                    ", "`P", i*n+j, ": begin", sep='')
        output_i = bin(i)[2:].zfill(nselect_size)
        output_j = bin(j)[2:].zfill(nselect_size)
        output_select = str(i*n+j).zfill(-(-(n**2) // 10))
        print ("                        ", "a_select <= ",nselect_size,"'b",output_i, ";",sep='');
        print ("                        ", "b_select <= ",nselect_size,"'b",output_j, ";",sep='');
        print ("                        ", "select <= ",select_size,"'d",i*n+j, ";",sep='');
        if (i*n+j==n**2-1): print ("                        ", "STATE <= `P0;", sep='')
        else: print ("                        ", "STATE <= `P", i*n+j+1,";", sep='')
        print("                    end")

print("                    default: STATE <= `P0;")
print("            endcase")
print("        end")
print("    end")


print("    reg end_signal;")
print("    always @(posedge ACLK)")
print("        begin")
print("            if (ARESETN == 1'b0) begin")
print("                END_SIGNAL <= 1'b0;")
print("            end else begin")
print("                if (STATE == `P",n**2-1, ") begin",sep='')
print("                    END_SIGNAL <= 1'b1;")
print("                end else begin",sep='')
print("                    END_SIGNAL <= 1'b0;")
print("                end")
print("            end")
print("       end")
print("   assign END_SIGNAL = end_signal;")

print("endmodule")
