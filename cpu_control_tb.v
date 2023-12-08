module cpu_control_tb(); 
    integer program[3:0];
    reg [6:0] OPCode;
    wire [1:0] ALUSrcB, ALUOp;
    reg clk, rst;
    reg[1:0] PC;
    wire MemRead, ALUSrcA, IorD, IRWrite, PCWrite, PCSource, MemToReg, RegWrite, RegDst, MemWrite, PCWriteCond;
    
    cpu_control dut(clk, rst, OPCode, MemRead, ALUSrcA, IorD, IRWrite, ALUSrcB, ALUOp, PCWrite, PCSource, MemToReg, RegWrite, RegDst, MemWrite, PCWriteCond);

    initial begin : init
        program[0] <= 32'b00000000110000010010001010000011;
        program[1] <= 32'b00000000011110110010100000100011; 
        program[2] <= 32'b01000001111101001000000110110011;
        program[3] <= 32'b00000000101101000000001001100011;
        OPCode     <= program[0];
        rst <= 1;
        clk <= 0;
        PC  <= 0;
        
        #100;
        rst <= 0;
    end

    initial begin
        forever #10 clk = ~clk;
    end

    always @(negedge clk) begin
        if (MemRead==1 && ALUSrcA == 0 && IorD == 0 && ALUSrcB == 01 && ALUOp == 00 && PCWrite == 1 && PCSource == 00 && ~rst) begin
            OPCode <= program[PC] & 32'b00000000000000000000000001111111;
            PC=PC+1;
        end
    end

endmodule