
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ID is
    Port ( RegWrite : in STD_LOGIC;
          -- RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_vector(31 downto 0 );
           RD2 : out STD_LOGIC_vector(31 downto 0);
           instruction2: in std_logic_vector(25 downto 0);
           Ext_Imm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0);
           WD : in std_logic_vector(31 downto 0);
           WA:in std_logic_vector(4 downto 0);
           rt:out std_logic_vector(4 downto 0);
           rd:out std_logic_vector(4 downto 0);
           clk:in std_logic;
           en: in std_logic;
           sa: out std_logic_vector(4 downto 0));
           
           
           
end ID;

architecture Behavioral of ID is

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (
others => X"00000000");
--signal wa: std_logic_vector(4 downto 0);

begin

RD1<=reg_file(conv_integer(instruction2(25 downto 21)));
RD2<=reg_file(conv_integer(instruction2(20 downto 16)));
 

 
 process(Regwrite,clk,en)
 begin
 if  en='1'  then
 if clk'event and clk='0' then
 reg_file(conv_integer(WA))<=WD;
 end if;
 end if;
  end process;
  
process(ExtOp)
begin
if ExtOp='0' then
Ext_Imm<=X"0000"&instruction2( 15 downto 0);
else
if ExtOP='1' then
Ext_imm(15 downto 0)<= instruction2(15 downto 0);
Ext_imm(31 downto 16)<=(others => instruction2(15));
end if;end if;
end process;

func<=instruction2(5 downto 0);
sa<=instruction2(10 downto 6);
rt<=instruction2(20 downto 16);
rd<=instruction2(15 downto 11);
end Behavioral;

