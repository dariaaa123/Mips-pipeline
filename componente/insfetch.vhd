
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity insfetch is
    Port ( clk : in STD_LOGIC;
           rst:in std_logic;
           en: in std_logic;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           pcplus4 : out STD_LOGIC_VEcTOR(31 downto 0);
           JumpAddress: in std_logic_vector (31 downto 0);
           BranchAdress: in std_logic_vector(31 downto 0);
            outtt: out std_logic_vector(31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0));
           
end insfetch;


architecture Behavioral of insfetch is


signal pc_nou : STD_LOGIC_VEcTOR(31 downto 0):=(others=>'0');
signal pc:std_logic_vector(31 downto 0):=(others=>'0');

signal adresa:std_logic_vector(4 downto 0):=(others=>'0');
type rom_type is array (63 downto 0) of std_logic_vector(31 downto 0);
signal romm : rom_type :=(
0=>B"000000_00000_00000_00001_00000_100000",  --00000820
1=>B"001000_00000_00100_0000000000000100",    --20040004
2=>B"001000_00000_00010_0000000000000100",    --20020004
3=>B"000000_00000_00000_00101_00000_100000",  --00002820
4=>B"100011_00100_00011_0000000000000000",    --8c830000
5=>B"000000_00000_00000_00000_00000_100000",  --NOOP
6=>B"000000_00000_00000_00000_00000_100000",  --noop
--begin loop
7=>B"000100_00001_00011_0000000000011101",   --1023001D
8=>B"000000_00000_00000_00000_00000_100000",  --noop
9=>B"000000_00000_00000_00000_00000_100000",  --noop
10=>B"000000_00000_00000_00000_00000_100000",  --noop
11=>B"001000_00010_00010_0000000000000100",   --20420004
12=>B"000000_00000_00000_00000_00000_100000",  --noop
13=>B"000000_00000_00000_00000_00000_100000",  --noop
14=>B"100011_00010_00110_0000000000000000",   --80460000
15=>B"000000_00000_00000_00000_00000_100000",  --noop
16=>B"000000_00000_00000_00000_00000_100000",  --noop
17=>B"000111_00110_00000_0000000000000111",   --1CC00007
18=>B"000000_00000_00000_00000_00000_100000",  --noop
19=>B"000000_00000_00000_00000_00000_100000",  --noop
20=>B"000000_00000_00000_00000_00000_100000",  --noop
21=>B"001000_00001_00001_0000000000000100",   --20210004
22=>B"000010_00000000000000000000000111",     --8000007
23=>B"000000_00000_00000_00000_00000_100000",  --noop
 --mai mare decat zero
24=>B"000000_00000_00110_00110_11111_000000",  --000637c0
25=>B"000000_00000_00000_00000_00000_100000",  --noop
26=>B"000000_00000_00000_00000_00000_100000",  --noop  
27=>B"000100_00110_00000_0000000000000111", -- 10C00007   beq
28=>B"000000_00000_00000_00000_00000_100000",  --noop
29=>B"000000_00000_00000_00000_00000_100000",  --noop
30=>B"000000_00000_00000_00000_00000_100000",  --noop
31=>B"001000_00001_00001_0000000000000001",   --20210001
32=>B"000010_00000000000000000000000111",   --8000007
33=>B"000000_00000_00000_00000_00000_100000",  --noop
 --par   
34=>B"001000_00101_00101_0000000000000001",  --20a50001
35=>B"001000_00001_00001_0000000000000101",  --20210005
36=>B"000010_00000000000000000000000111",    --8000007
37=>B"000000_00000_00000_00000_00000_100000",  --noop
    
38=>B"101011_00000_00101_0000000000000000",   --ac050000
    others => B"00000000000000000000000000000000"      
   
);
-- 1=> add $1,$0,$0          initializam contorul in reg 1 cu 0
-- 2=> addi $4,$0,4          punem in &4 valoarea 4 pentru ca mai tarziu sa-l folosim ca adresa de unde citim N - numere 
-- 3=>addi $2,$0,4           reg 2 va sta pe post de index al memoriei, il initilizam cu 4 ca mai incolo sa putem face +4
-- 4 =>add $5,$0,$0           reg 5 este contorul pentru numerele pare cautate, se initilizeaza cu 0
-- 5 =>lw $3, addr($4)       in reg 3 am incercat numarul de iteratii pe care trebuie sa le faca programul, ne va folosi pe post de for
-- 6=>noop
-- 7=>noop
-- begin_loop:
-- 8=>beq $1,$3, end_loop    se verifica daca contorul $1 a ajuns la nr de iteratii din reg 3, daca da, se face salt la end_loop
-- 9=>noop
-- 10=>noop
-- 11=>noop
-- 12 =>addi $2,$2,4          se incrementeaza indexul memeoriei, numerele se afla incepand de la adresa 8 din 4 in 4
-- 13=>noop
-- 14=>noop
-- 15 =>lw $6,addr($2)        se incarca in reg 6 numarul de la adresa offset+$2
-- 16=>noop
-- 17=>noop
-- 18 =>bgtz $6, mai_mare_decat_zero     verifica daca numarul este pozitiv ( strict pozitiv)
-- 19=>noop
-- 20=>noop
-- 21=>noop
-- 22 =>addi $1,$1,1         daca nu s-a facut branch ul anterior, se incrementeaza contorul for-ului
-- 23 =>j begin_loop         se sare la adresa indicata de eticheta begin_loop(inceputul iteratiei)
-- 24=>noop
-- mai mare decat zero:
-- 25 => sll $6,$6,31        se shifteaza la stanga numarul pe 32 de biti cu 31 de pozitii, astfel incat cel mai nesemnificativ bit al numarul ajunge cel mai semnificativ bit al noului numar
 -- ( am abordat logica urmatoare: pentru a verifica daca un nuumar este par sau nu, ne folosim de cel mai nesemnificativ bit al sau)
 -- ( daca acest bit este 0, atunci numarul e par, daca este 1, atunci avem numar par + 2 la puterea 0, adica 1=> numar impar)
-- 26=>noop
-- 27=>noop
 --28 => beq $6,$0, par       comparam numarul shiftat care ar trebui sa fie 0 daca numarul este par cu reg 0, daca da, se sare l adresa par
-- 29=>noop
-- 30=>noop
-- 31=>noop
 -- 32 => addi $1,$1,1        daca nu s-a sarit la par, se incrementeza $1
 -- 33 => j begin_loop        apoi se sare la inceputul buclei
-- 34=>noop
 -- par:
 -- 35 => addi $5,$5,1       se incrementeza contorul de numere pare
 -- 36 => addi $1,$1,1       se incrementeza contorul for-ului
 -- 37 => j begin_loop       se sare la inceputul buclei
-- 38=>noop
 -- end_loop:
 -- 39 => sw $5,addr($0)     dupa terminarea iteratiilor, se scrie in reg 5 numarul de numere pare gasite
begin
process(rst,en,clk)
begin
if rst='1' then
pc<=(others=>'0');
else if en='1' and clk'event and clk='1' then
pc<=pc_nou;
end if;
end if;
end process;

process(jump,pcsrc)
begin
if jump='1'then
pc_nou<=JumpAddress;
else if jump='0' then
if pcsrc='1' then
pc_nou<=BranchAdress;
else if pcsrc='0' then
pc_nou<=pc+4;

end if;
end if;
end if;
end if;
end process;
--adresa<=pc(6 downto 2);
instruction<=romm(conv_integer(pc(7 downto 2)));
outtt<=romm(conv_integer(pc(7 downto 2)));
pcplus4<=pc+4;
end Behavioral;
