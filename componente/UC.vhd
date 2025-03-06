

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UC is
    Port ( instruction1 : in STD_LOGIC_VECTOR (5 downto 0);
    RegDst: out std_logic;
     ExtOp: out std_logic;
      ALUSrc: out std_logic;
       Branch: out std_logic;
        Jump: out std_logic;
        ALUOp: out std_logic_vector(2 downto 0);
         MemWrite: out std_logic;
          MemtoReg: out std_logic;
           RegWrite: out std_logic );
end UC;

architecture Behavioral of UC is

begin
process(instruction1)
begin

 RegDst<='0';
 ExtOp<='0';
 ALUSrc<='0';
 Branch<='0';
 Jump<='0';
 ALUOp<="000";
 MemWrite<='0';
 MemtoReg<='0';
 RegWrite<='0';

case instruction1 is
when "000000"=>RegDst<='1';ALUOp<="001";RegWrite<='1';--R
when "001000"=>ExtOp<='1';ALUSrc<='1';ALUOp<="010";RegWrite<='1';--addi
when "101011"=>ExtOp<='1';ALUSrc<='1';ALUOp<="010";RegDst<='1';MemWrite<='1';--sw
when "100011"=>ExtOp<='1';ALUSrc<='1';ALUOp<="010";RegWrite<='1';MemtoReg<='1';--lw
when "001100"=>ExtOp<='1';ALUSrc<='1';ALUOp<="011";--andi
when "000100"=>ExtOp<='1';Branch<='1';ALUOp<="100";--beq
when "000111"=>ExtOp<='1';Branch<='1';ALUOp<="101";--bgtz
when "000010"=>Jump<='1';--jump
 when others => 
                RegDst <= 'X'; ExtOp <= 'X'; ALUSrc <= 'X'; 
                Branch <= 'X'; Jump <= 'X'; MemWrite <= 'X';
                MemtoReg <= 'X'; RegWrite <= 'X';
                ALUOp <= "XXX";

end case;
end process;
end Behavioral;
