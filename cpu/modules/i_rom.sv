module i_rom (
    input  logic [7:0] address,   // 8 bits = 256 posiciones
    output logic [31:0] data
);
    // Memoria de 256 palabras de 32 bits
    logic [31:0] memory [0:255];
    
    // Inicialización con algunas instrucciones de ejemplo
    initial begin

        for (int i = 0; i < 256; i++) begin
            memory[i] = 32'h00000013;
        end

        //IO operations
        memory[0] = 32'h00000293; //addi x5, x0, 0      0
        memory[1] = 32'h02102283; //lw x5, 33(x0)       4       
  
        memory[2] = 32'h025021a3; //sw x5, 35(x0)       8
        memory[3] = 32'hff5ff36f;  //jal x6, -12        12      end program


        // // load and store 

        // memory[0] = 32'h01700213; //addi x4, x0, 23     0       res= 23
        // memory[1] = 32'h00020233; //add x4, x4, x0      4       res= 23
        // memory[2] = 32'h00402023; //sw x4, 0(x0)        8       res= 0  (x0 + 0)
        // memory[3] = 32'h00002103; //lw x2, 0(x0)        12      res= 0 data_out = 23
        // memory[4] = 32'h00010133; //add x2, x2, x0      16      res= 23
        

        // memory[5] = 32'h7ef00193; //addi x3, x0,21031   20      res= 2031 (7ef)
        // memory[6] = 32'h00519193; //slli x3, x3, 5      24      res= 64992 (fde0)
        // memory[7] = 32'h003020a3; //swx3, 1(x0)         28      res= 1
        // memory[8] = 32'h00101203; //lh x4, 1(x0)        32      res= 1 data_out –544
        // memory[9] = 32'h00105283; //lhu x5, 1(x0)       36      res= 1 data_out = fde0 (64992)

        // memory[10]= 32'h00100303; //lb x6, 1(x0)        40      res= 1 data_out = -32
        // memory[11]= 32'h00104383; //lbu, x7, 1(x0)      44      res= 1 data_out = e0 (224)

        // memory[12]= 32'h00119193; //slli x3, x3, 1      48      res= 129984 (1fbc0)
        // memory[13]= 32'h00301123; //sh x3, 2(x0)        52      res= 2
        // memory[14]= 32'h00202083; //lw x2, 2(x0)        56      res= 2 data_out = 64448

        // memory[15]= 32'h003001a3; //sb x3, 3(x0)        60      res= 3
        // memory[16]= 32'h00302283; //lw x5, 3(x0)        64      res= 3 data_out = 192

        
        // //bit to bit operations and comparisons

        // memory[0] = 32'h01700213; //addi x4, x0, 23     0       res= 23
        // memory[1] = 32'h00020233; //add x4, x4, x0      4       res= 23
        // memory[2] = 32'h00b00313; //addi x6, x0, 11     8       res= 11
        // memory[3] = 32'h00030333; //add x6,x6,x0        12      res= 11

        // //and andi
        // memory[4] = 32'h006273b3; //and x7, x4, x6      16      res= 3
        // memory[5] = 32'h000383b3; //add x7, x7, x0      20      res= 3
        // memory[6] = 32'h00f3f413; //andi x8, x7 15      24      res= 3
        // memory[7] = 32'h00040433; //add x8, x8, x0      28      res= 3

        // //xor xori
        // memory[8] = 32'h004444b3; //xor x9, x8, x4      32      res= 20
        // memory[9] = 32'h000484b3; //add x9,x9,x0        36      res= 20
        // memory[10]= 32'hfd44c513; //xori x10, x9, -44   40      res= -64
        // memory[11]= 32'h00050533; //add x10,x10,x0      44      res= -64

        // //sub 
        // memory[12]= 32'h404305b3; // sub x11, x6, x4    48      res= -12
        // memory[13]= 32'h000585b3; //add x11, x11, x0    52      res= -12

        // //or ori
        // memory[14]= 32'h00a3e633; //or x12, x7, x10     56      res= -61
        // memory[15]= 32'h00060633; //add x12, x12, x0    60      res= -61
        // memory[16]= 32'hf9d36693; //ori x13,x6, -99     64      res= -97
        // memory[17]= 32'h000686b3; //add x13,x13,x0      68      res= -97
        

        // //blt
        // memory[18]= 32'h00d64463; //blt x12, x13, 8     72      (-61 < -97) = 0
        // memory[19]= 32'h00c6c463; //blt x13, x12, 8     76      (-97 < -61) = 1
        // //                                                      branch pc = 88

        // //bge
        // memory[22]= 32'h0093d463; //bge x7, x9, 8       88      (3 >= 20) = 0
        // memory[23]= 32'h0074d263; //bge x9, x7, 4       92      (20 >= 3) = 1 
        // //                                                      branch pc = 100
        // memory[25]= 32'h00745263; //bge x8, x7, 4       100     (3 >= 3 ) = 1 
        // //                                                      branch pc = 108  
        
        // //bne
        // memory[27]= 32'h00741263; //bne x8, x7, 4       108     (3 != 3) = 0
        // memory[28]= 32'h00721263; //bne x4, x7,4        112     (23 != 3) = 1 
        // //                                                      branch pc = 120

        // //bltu
        // memory[30]= 32'h0076e263; //bltu x13, x7, 4     120     unsigned(-97 < 3) = 0
        // memory[31]= 32'h00d3e263; //bltu x7, x13, 4    124      unsigned(3 < -97) = 1
        // //                                                      branch pc = 132     
        
        // //bgeu
        // memory[33]= 32'h00d3f263; //bgeu x7, x13, 4    132      unsigned(3 > -97) = 0
        // memory[34]= 32'h0076f263; //bgeu x13, x7, 4    136      unsigned(-97 > 3) = 1
        // //                                                      branch pc = 144

        // //slti sltiu
        // memory[36]= 32'hff93a713; //slti x14, x7, -7   144      (3 < -1) = 0
        // memory[37]= 32'h00070733; //add x14, x14, x0   148      res = 0
        // memory[38]= 32'h0143a713; //slti x14, x7, 20   152      (3 < 20) = 1 
        // memory[39]= 32'h00070733; //add x14, x14, x0   156      res = 1

        // memory[40]= 32'hff93b713; //sltiu x14, x7, -7  160      unsigned(3 < -7) = 1 
        // memory[41]= 32'h00070733; //add x14, x14, x0   164      res = 1
        // memory[42]= 32'h0013b713; //sltiu x14, x7, 1   168      unsigned(3 < 1) = 0
        // memory[43]= 32'h00070733; //add x14, x14, x0   172      res = 0;


        // // slt sltu
        // memory[44] = 32'h00b3a733; //slt x14, x7, x11  176      (3 < -12) = 0
        // memory[47] = 32'h00070733; //add x14, x14, x0  188      res = 1
        // memory[45] = 32'h00070733; //add x14, x14, x0  180      res = 0
        // memory[46] = 32'h0093a713; //slt x14, x7, x9   184      (3 < 20) = 1

        // memory[48] = 32'h00b3b713; //sltu x14, x7, x11 192      unsigned(3 < -12) = 1
        // memory[49] = 32'h00070733; //add x14, x14, x0  196      res = 1
        // memory[50] = 32'h00623733; //sltu x14, x4, x6  200      unsigned(23 < 11) = 0
        // memory[51] = 32'h00070733; //add x14, x14, x0  204      res = 0
        // memory[52] = 32'h24ea1797;//auipc x15, 151201  208      
        // memory[53] = 32'h000787b3; //add x15, x15, x0  212      res = 619 319 508


        // // Shifting instructions
        // memory[0] = 32'h00100093;  //addi x1, x0, 1     0 res = 1

        // //sll
        // memory[1] = 32'h00109133;  //sll x2, x1, x1     4  res = 2
        // memory[2] = 32'h00010133;  //add x2, x2, x0     8  res = 2
        // memory[3] = 32'h001111b3;  //sll x3, x2, x1     12 res = 4
        // memory[4] = 32'h000181b3;  //add x3, x3, x0     16 res = 4

        // //srl
        // memory[5] = 32'h0011d233;  //srl x4, x3, x1     20 res = 2
        // memory[6] = 32'h00020233;  //add x4, x4, x0     24 res = 2

        // //sra vs srl
        // memory[7] = 32'hff100293;  //addi x5, x0, -15   28 res = -15
        // memory[8] = 32'h000282b3;  //add x5, x5, x0     32 res = -15
        // memory[9] = 32'h0012d333;  //srl x6, x5, x1     36 res = 2147483640
        // memory[10]= 32'h00030333;  //add x6, x6, x0     40 res = 2147483640
        // memory[11]= 32'h4012d3b3;  //sra x7, x5, x1     44 res = -8
        // memory[12]= 32'h000383b3;  //add x7, x7, x0     48 res = -8

        // //slli
        // memory[13]= 32'h00219413; //slli x8, x3, 2      52 res = 16
        // memory[14]= 32'h00040433; //add x8, x8, 0       56 res = 16

        // //srli vs srai
        // memory[15]= 32'h0032d493; //srli x9, x5, 3      60 res = 536.870.910
        // memory[16]= 32'h000484b3; // add x9, x9, 0      64 res = 536.870.910

        // memory[17]= 32'h4032d513; //srai x10, x5, 3     68 res = -2
        // memory[18]= 32'h00050533; //add x10, x10, 0     72 res = -2

       
       
        

    end
    
    // Lectura asíncrona
    assign data = memory[address];
endmodule