
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EX is
    Port ( RD1 : in STD_LOGIC_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2 : in std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector( 4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    PCplus4:in std_logic_vector(31 downto 0);
    Zero1: out std_logic;--pt beq
    Zero2: out std_logic;--pt bgtz
    --Zero3: out std_logic;--pt bgtz
    ALURes: out std_logic_vector (31 downto 0);
    RegDst: in std_logic;
    rWA: out std_logic_vector(4 downto 0);
     rt: in std_logic_vector(4 downto 0);
     rd: in std_logic_vector(4 downto 0);
    
    BranchAddress: out std_logic_vector(31 downto 0)
     
    );
end EX;

architecture Behavioral of EX is
signal ALUControl: std_logic_vector(3 downto 0);
signal operator: std_logic_vector(31 downto 0);
signal rez: std_logic_vector(31 downto 0);
signal rez1: std_logic_vector(31 downto 0);
signal ok: std_logic;

begin
process(ALUOp,func)
begin
case ALUOp is
when "001" => 
case func is 
when "100000" =>ALUControl<="0000"; --adunare
when "100010" =>ALUControl<="0001"; --scadere
when "000000"=>ALUControl<="0010"; --shiftare stanga
when "000010"=>ALUControl<="0011"; --shiftare dreapta
when "100100"=>ALUControl<="0100"; -- si logic
when "100101"=>ALUControl<="0101"; -- sau logic
when others=>ALUControl<="0110"; -- xor logic

end case;
when "010"=>ALUControl<="0111";  --lw ws si addi
when "011"=>ALUControl<="1000"; -- andi
when "100"=>ALUControl<="0001"; -- beq
when others=>ALUControl<="1001"; -- bgtz
end case;
end process;

process(ALUSrc)
begin
if ALUSrc='1' then
operator<=Ext_Imm;
else
operator<=RD2;
end if;
end process;

process(ALUControl,sa,operator)
begin 
case ALUControl is
when "0000"=> rez<=RD1+operator;AluRes<=rez;
when "0001"=> rez<=RD1-operator;AluRes<=rez;
when "0010"=> rez<=to_stdlogicvector(to_bitvector(RD1)sll conv_integer(sa));AluRes<=rez;
when "0011"=> rez<=to_stdlogicvector(to_bitvector(RD1)srl conv_integer(sa));AluRes<=rez;
when "0100"=> rez<=RD1 and operator;AluRes<=rez;
when "0101"=> rez <=RD1 or operator;AluRes<=rez;
when "0110"=> rez<=RD1 xor operator;AluRes<=rez;
when "0111"=> rez<=RD1+operator;AluRes<=rez;
when "1000"=> rez<=RD1 and operator;AluRes<=rez;

when others=> if signed(RD1) > signed(RD2) then
                    rez <= X"00000000";
                    AluRes <= X"00000000";
              else
                    rez <= X"00000001";
                    AluRes <= X"00000001";
              end if;
              end case;
--AluRes<=X"00000000";
--AluRes<=rez;


BranchAddress<=PCplus4+(Ext_Imm(29 downto 0) & "00");

end process;
process(rez)
begin
--ok<='0';

if rez=X"00000000" then
    Zero1<='1';
else
    Zero2<='0';
    
 --ok<='1';
 end if;

end process;

process(RegDst)
begin
if RegDst='1' then rWA<=rd;
else rWA<=rt;
end if;
end process;




end Behavioral;
