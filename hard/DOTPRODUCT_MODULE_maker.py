import math

n = int(input())

# 内積結果をoutput_moduleへ格納する際のアドレスサイズselect_sizeを求める．
# このセレクタは0からn^2-1の合計n^2個を区別する．n^2-1を表現可能なビットサイズを求める
select_size = math.ceil( math.log2(n**2) )

#何段パイプラインになるかを調べる．各積に1段そして加算加算に[log3n]+1段の合計[log3n]+2段となる．
log3n_ceil  = math.ceil( math.log(n, 3) )



#モジュール部分
print("module DOTPRODUCT_MODULE(")
print("        input ACLK, ARESETN,")
print("        input [",select_size-1,":0] DEST_I,",sep='')
print("        input [31:0] ",end='')

for i in range(n):
    print("A_ELEM",i,", ",sep='',end='');

print();
print("        input [31:0] ",end='')
for i in range(n):
    print("B_ELEM",i,", ",sep='',end='');
print();
 

print("        output reg [31:0] DOT_PRODUCT,")
print("        output reg [",select_size-1,":0] DEST_O",sep='')
print("    );")
print("")

#本体
print("    reg [",select_size-1,":0] ",end='')
for i in range(log3n_ceil):
    print("dest_pipline",i,sep='',end='');
    if (i==log3n_ceil-1): print(";")
    else: print(", ", end='')
    
print("    reg [31:0] ",end='')
for i in range(n):
    print("product",i,sep='',end='');
    if (i==n-1): print(";")
    else: print(", ", end='') 
    
print("")
print("")


#１段目
print("//1st")
print("    always @(posedge ACLK) begin")
print("      if (ARESETN == 1'b0) begin")
print("        dest_pipline0 <= 0;")
for i in range(n):
    print("        product",i," <= 0;",sep='');
print("      end")
print("      else begin")
print("        dest_pipline0 <= DEST_I;")
for i in range(n):
    print("        product",i," <= A_ELEM",i," * B_ELEM",i,";",sep='');
print("      end")
print("    end")
print("")
print("")


#２段目以降

num_term = (n // 3)
mod3 = n%3 
num_sum = -(-n // 3)

for i in range(log3n_ceil):
    print("//",i+2,"th")
    
    
    if (i==log3n_ceil-1):
        dest="DEST_O"
        print("    always @(posedge ACLK) begin")
        print("      if (ARESETN == 1'b0) begin")
        print("        ",dest," <= 0; ",sep='')
        
        for j in range(num_sum):
            output = "DOT_PRODUCT"
            print("        ",output," <= 0;",sep='');
            
        print("      end")
        print("      else begin")
        print("        ",dest," <= dest_pipline",i,";",sep='')  
   
        if (i==0): title="product"
        else: title="tmp_sum"+str(i-1)+"_"

        for j in range(num_term):
            output = "DOT_PRODUCT"
            print("        ",output," <= ", title,3*j," + ", title,3*j+1," + ", title,3*j+2,";",sep='')
        
        if (mod3==2 and j==0): print("        DOT_PRODUCT"," <= ", title,j," + ", title,j+1,";",sep='')
        elif (mod3==2): print("        DOT_PRODUCT"," <= ", title,3*(j+1)," + ", title,3*(j+1)+1,";",sep='')
        elif (mod3==1 and j==0): print("        DOT_PRODUCT"," <= ", title,j,";",sep='')
        elif (mod3==1): print("        DOT_PRODUCT"," <= ", title,3*(j+1),";",sep='')


    else:
        print("    reg [31:0] ",end='')
        for j in range(num_sum):
            print("tmp_sum",i,"_",j,sep='',end='');
            if (j==num_sum-1): print(";")
            else: print(", ", end='')

        dest="dest_pipline"+str(i+1)    
        print("    always @(posedge ACLK) begin")
        print("      if (ARESETN == 1'b0) begin")
        print("        ",dest," <= 0; ",sep='')
    
        for j in range(num_sum):
            output="tmp_sum"+str(i)+"_"
            print("        ",output,j," <= 0;",sep='');
        print("      end")
        print("      else begin")
        print("        ",dest," <= dest_pipline",i,";",sep='')
        
        if (i==0): title="product"
        else: title="tmp_sum"+str(i-1)+"_"
        
        for j in range(num_term):
            output="tmp_sum"+str(i)+"_"+str(j)
            print("        ",output," <= ", title,3*j," + ", title,3*j+1," + ", title,3*j+2,";",sep='')        

        if (mod3==2): print("        tmp_sum",i,"_",j+1," <= ", title,3*(j+1)," + ", title,3*(j+1)+1,";",sep='')
        elif (mod3==1): print("        tmp_sum",i,"_",j+1," <= ", title,3*(j+1),";",sep='')        

    
    print("      end")
    print("    end\n")
    
    num_term = (num_sum // 3) #3で割って切り下げ
    mod3 = num_sum%3
    num_sum = -(-num_sum // 3) #3で割って切り上げ


print("endmodule")
print("")
