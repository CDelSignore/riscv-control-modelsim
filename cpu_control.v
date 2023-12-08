module cpu_control(
    input clk,
    input rst,
    input [6:0] OPCode, 
    output reg MemRead,
    output reg ALUSrcA,
    output reg IorD,
    output reg IRWrite,
    output reg [1:0] ALUSrcB,
    output reg [1:0] ALUOp,
    output reg PCWrite,
    output reg PCSource,
    output reg MemToReg,
    output reg RegWrite,
    output reg RegDst,
    output reg MemWrite,
    output reg PCWriteCond);

    reg[3:0] curState;

    always@(posedge clk) begin
        if(rst) begin
            MemRead     <=  0;
            ALUSrcA     <=  0;
            IorD        <=  0;
            ALUSrcB     <= 00;
            ALUOp       <= 00;
            PCWrite     <=  0;
            PCSource    <= 00;
            IRWrite     <=  0;
            MemToReg    <=  0;
            RegWrite    <=  0;
            RegDst      <=  0;
            MemWrite    <=  0;
            PCWriteCond <=  0;

            curState    <= 4'b0000;
        end

        else begin
            case(curState)
                // State 0: Instruction Fetch
                4'b0000 : begin
                    MemRead     <=  1;
                    ALUSrcA     <=  0;
                    IorD        <=  0;
                    ALUSrcB     <= 01;
                    ALUOp       <= 00;
                    PCWrite     <=  1;
                    PCSource    <= 00;

                    curState    <= 4'b0001;
                end

                // State 1: Instruction Decode
                4'b0001 : begin
                    ALUSrcA     <=  0;
                    ALUSrcB     <= 10;
                    ALUOp       <= 00;

                    case(OPCode)
                        7'b0000011 : curState <= 4'b0010;   // LW
                        7'b0100011 : curState <= 4'b0010;   // SW
                        7'b0110011 : curState <= 4'b0110;   // R-Type
                        7'b1100011 : curState <= 4'b1000;   // BEQ
                        7'b1100111 : curState <= 4'b1001;   // J
                        default    : curState <= 4'b1111;   // INVALID
                    endcase
                end

                // State 2: Memory Address Computation
                4'b0010 : begin
                    ALUSrcA     <=  1;
                    ALUSrcB     <= 10;
                    ALUOp       <= 00;

                    case(OPCode)
                        7'b0000011 : curState <= 4'b0011;   // LW
                        7'b0100011 : curState <= 4'b0101;   // SW
                        default    : curState <= 4'b1111;   // INVALID
                    endcase
                end

                // State 3:
                4'b0011 : begin
                    MemRead     <=  1;
                    IorD        <=  1;

                    curState    <= 4'b0100;
                end

                // State 4:
                4'b0100 : begin
                    RegDst      <=  0;
                    RegWrite    <=  1;
                    MemToReg    <=  1;

                    curState    <= 4'b0000;
                end

                // State 5:
                4'b0101 : begin
                    MemWrite    <=  1;
                    IorD        <=  1;

                    curState    <= 4'b0000;
                end

                // State 6: Execution
                4'b0110 : begin
                    ALUSrcA     <=  1;
                    ALUSrcB     <= 00;
                    ALUOp       <= 10;

                    curState    <= 4'b0111;
                end

                // State 7:
                4'b0111 : begin
                    RegDst      <=  1;
                    RegWrite    <=  1;
                    MemToReg    <=  0;

                    curState    <= 4'b0000;
                end

                // State 8: Branch Execution
                4'b1000 : begin
                    ALUSrcA     <=  1;
                    ALUSrcB     <= 00;
                    ALUOp       <= 01;
                    PCWriteCond <=  1;
                    PCSource    <= 01;

                    curState    <= 4'b0000;
                end

                // State 9: Jump Completion
                4'b1001 : begin
                    PCWrite     <=  1;
                    PCSource    <= 10;

                    curState    <= 4'b0000;
                end

                // Invalid State
                default:
                    $error("Invalid State Reached");
                    
            endcase
        end
    end
endmodule