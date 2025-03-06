

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;          
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0); 
            btn: in STD_LOGIC_VECTOR (4 downto 0);
           sw: in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));                  
end test_env;

architecture Behavioral of test_env is
component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component UC is
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
end component;

component ID is
    Port (
    clk: in std_logic; 
    RegWrite : in STD_LOGIC;
          -- RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_vector(31 downto 0 );
           RD2 : out STD_LOGIC_vector(31 downto 0);
            rt : out STD_LOGIC_vector(4 downto 0 );
           rd : out STD_LOGIC_vector(4 downto 0);
           instruction2: in std_logic_vector(25 downto 0);
               WA: in std_logic_vector(4 downto 0);
           Ext_Imm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0);
           WD : in std_logic_vector(31 downto 0);
           en: in std_logic;
           sa: out std_logic_vector(4 downto 0));
end component;

component SSDv1 is
Port(signal clk:in std_logic;
signal data:in std_logic_vector(31 downto 0);
signal cat:out std_logic_vector(6 downto 0);
signal an:out std_logic_vector(7 downto 0)
 );
end component;

component insfetch is
Port(clk : in STD_LOGIC;
en: in std_logic;
           rst: in std_logic;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           pcplus4 : out STD_LOGIC_VEcTOR(31 downto 0);
           JumpAddress: in std_logic_vector (31 downto 0);
           BranchAdress: in std_logic_vector(31 downto 0);
           outtt: out std_logic_vector(31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component  EX is
    Port ( RD1 : in STD_LOGIC_vector(31 downto 0);
    ALUSrc: in std_logic;
    RegDst: in std_logic;
    RD2 : in std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector( 4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    PCplus4:in std_logic_vector(31 downto 0);
    Zero1: out std_logic;
    Zero2: out std_logic;
    --Zero3: out std_logic;
    ALURes: out std_logic_vector (31 downto 0);
    rt : in STD_LOGIC_vector(4 downto 0 );
    rd : in STD_LOGIC_vector(4 downto 0);
    rWA : out STD_LOGIC_vector(4 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)     
    );
end component;

component MEM is
    Port ( ALUResin : in STD_LOGIC_VECTOR (31 downto 0);
    RD2 : in std_logic_vector( 31 downto 0);
    MemWrite: in std_logic;
    MemData : out std_logic_vector(31 downto 0);
    ALUResout: out std_logic_vector( 31 downto 0);
    clk : in std_logic;
    en: in std_logic
    );
end component;

signal pcplus4 : STD_LOGIC_VEcTOR(31 downto 0);
signal outtt : STD_LOGIC_VEcTOR(31 downto 0);
signal JumpAddress : STD_LOGIC_VEcTOR(31 downto 0);
signal BranchAddress : STD_LOGIC_VEcTOR(31 downto 0);
signal jump : STD_LOGIC;
signal schimba : STD_LOGIC;
signal pcsrc :  STD_LOGIC;
signal instruction :STD_LOGIC_VECTOR (31 downto 0);
signal en : std_logic;
signal rst : std_logic;
signal data : std_logic_vector(31 downto 0);
signal RegDst:  std_logic;
signal ExtOp:  std_logic;
signal ALUSrc:  std_logic;
signal Branch:  std_logic;
signal ALUOp:  std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite:  std_logic;
signal RD1 :  STD_LOGIC_vector(31 downto 0 );
signal RD2 :  STD_LOGIC_vector(31 downto 0);
signal WD :  STD_LOGIC_vector(31 downto 0);
signal ALUResin :  STD_LOGIC_VECTOR (31 downto 0);
signal MemData :  std_logic_vector(31 downto 0);
signal ALUResout:  std_logic_vector( 31 downto 0);
signal Ext_Imm: std_logic_vector(31 downto 0);
signal sa:std_logic_vector( 4 downto 0);
signal func:std_logic_vector(5 downto 0);
signal Zero1: std_logic;
signal Zero2: std_logic;
signal Zero3: std_logic;
signal ALURes: std_logic_vector (31 downto 0);
signal switch: std_logic_vector(2 downto 0);
signal rt : STD_LOGIC_vector(4 downto 0 );
signal rd :STD_LOGIC_vector(4 downto 0);
signal rWA :STD_LOGIC_vector(4 downto 0);
signal WA :STD_LOGIC_vector(4 downto 0);
signal reg_IF_ID : STD_LOGIC_VEcTOR(63 downto 0);
signal reg_ID_EXE : STD_LOGIC_VEcTOR(157 downto 0);
signal reg_EXE_MEM : STD_LOGIC_VEcTOR(106 downto 0);
signal reg_MEM_WB : STD_LOGIC_VEcTOR(70 downto 0);

begin

btn1: debouncer port map(clk=>clk, btn=>btn(0), en=>en);

fetch: insfetch port map(en=>en,pcplus4=>pcplus4,BranchAdress=>BranchAddress,
JumpAddress=>JumpAddress,clk=>clk,rst=>btn(1),jump=>jump,outtt=>outtt,
 pcsrc=>pcsrc,instruction=>instruction);
 
 process(clk)
 begin
 if clk'event and clk='1'then
if en='1' then
reg_IF_ID(31 downto 0) <= pcplus4;
reg_IF_ID(63 downto 32) <= Instruction;
end if; 
end if;
end process;


process(clk,en)
begin
if en='1' then
if clk'event and clk='1'then
reg_ID_EXE(0) <= MemtoReg;
reg_ID_EXE(1) <= RegWrite;
reg_ID_EXE(2) <= MemWrite;
reg_ID_EXE(3) <= Branch;
reg_ID_EXE(6 downto 4) <= ALUOp;
reg_ID_EXE(7) <= ALUSrc;
reg_ID_EXE(8) <= RegDst;
reg_Id_exe(40 downto 9)<=reg_if_id(31 downto 0);
reg_id_exe(72 downto 41)<=RD1;
reg_id_exe(104 downto 73)<=RD2;
reg_id_exe(109 downto 105)<=sa;
reg_id_exe(141 downto 110)<=Ext_Imm;
reg_id_exe(147 downto 142)<=func;
reg_id_exe(152 downto 148)<=rt;
reg_id_exe(157 downto 153)<=rd;
end if; 
end if;
 end process;
 
 process(clk,en)
 begin
 if en='1' then
 if clk'event and clk='1' then
 reg_exe_mem(0)<=reg_id_exe(0);
 reg_exe_mem(1)<=reg_id_exe(1);
 reg_exe_mem(2)<=reg_id_exe(2);
 reg_exe_mem(3)<=reg_id_exe(3);
 reg_exe_mem(35 downto 4)<=BranchAddress;
 reg_exe_mem(36)<=Zero1;
 reg_exe_mem(37)<=Zero2;
 reg_exe_mem(69 downto 38)<=ALURes;
 reg_exe_mem(101 downto 70)<=RD2;
 reg_exe_mem(106 downto 102)<=rWA;
 end if;end if;
 end process;
 
 process(clk,en)
 begin
 if en='1' then
 if clk'event and clk='1' then
 reg_mem_wb(0)<=reg_exe_mem(0);
 reg_mem_wb(1)<=reg_exe_mem(1);
 reg_mem_wb(33 downto 2)<=MemData;
 reg_mem_wb(65 downto 34)<=ALUResin;
 reg_mem_wb(70 downto 66)<=reg_exe_mem(106 downto 102);
 end if;end if;
 end process;
 
unitate_decoding:ID port map(clk=>clk,instruction2=>reg_if_id(57 downto 32),
 RegWrite=>reg_mem_wb(1),ExtOp=>ExtOp,func=>func,
 sa=>sa,RD1=>RD1,RD2=>RD2,WD=>WD,en=>en,WA=>reg_mem_wb(70 downto 66), Ext_Imm=>Ext_Imm,rt=>rt,rd=>rd);
 
ssd1: ssdv1 port map(clk=>clk, data=>data, an=>an, cat=>cat);
unitate_control: UC port map(instruction1=>reg_IF_Id(63 downto 58),
 RegDst=>RegDst,ExtOp=>ExtOp,ALUSrc=>ALUSrc, Branch=>Branch,Jump=>jump,
ALUOp=>ALUOp,MemWrite=>MemWrite,MemtoReg=>MemtoReg,RegWrite=>RegWrite);

ram: MEM port map(RD2=>reg_exe_mem(101 downto 70),MemWrite=>reg_exe_mem(2),ALUResin=>ALURes,
MemData=>MemData,ALUResout=>ALUResout,clk=>clk,en=>en);

exec: EX port map(RD1=>reg_id_exe(72 downto 41),ALUSrc=>reg_ID_EXe(7),RD2=>reg_id_exe(104 downto 73),Ext_Imm=>reg_id_exe(141 downto 110),
sa=>reg_id_exe(109 downto 105),func=>reg_id_exe(147 downto 142),ALUOp=>reg_ID_EXe(6 downto 4),PCplus4=>reg_IF_ID(31 downto 0),Zero1=>Zero1,Zero2=>Zero2,
ALURes=>ALURes,BranchAddress=>BranchAddress,RegDst=>reg_ID_EXE(8),rt=>reg_id_exe(152 downto 148),rd=>reg_id_exe(157 downto 153),rWA=>rWA);

JumpAddress<=reg_IF_ID(31 downto 28)&reg_IF_ID(57 downto 32)&"00";

pcsrc<=( reg_exe_mem(3) and reg_exe_mem(36)) or ( reg_exe_mem(3) and reg_exe_mem(37));
switch <= sw(2 downto 0);
process(switch, instruction, RD1, RD2, PCplus4,ALUResout, MEMData, WD)
begin
case switch is
when "000"=>data<=instruction;
when "001"=>data<=pcplus4;
when "010"=>data<=RD1;
when "011"=>data<=RD2;
--when "010" => data<=X"000000"&"00"&instruction(5 downto 0);
--when "011" => data<=X"000000"&"000"&instruction(20 downto 16);
when "100"=>data<=X"000000"&"00"&func;
when "101"=>data<=ALURes;
when "110"=>data<=Ext_Imm;
when others=>data<=WD;
end case;
end process;
--Memtoreg<=reg_mem_wb(0);
led(2 downto 0)<=ALUOp;led(3)<=RegDst; 
led(4)<=ExtOp; led(5)<=ALUSrc; 
led(6)<=Branch; led(7)<=Zero1;
led(8)<=Zero2;
--led(9)<=Zero3;
 led(10)<=MemWrite; 
led(11)<=reg_mem_wb(0); led(12)<=RegWrite;


WA<=reg_mem_wb(70 downto 66);
process(reg_mem_wb(0))
begin
if reg_mem_wb(0)='1' then WD<=reg_mem_wb(33 downto 2);
else WD<=reg_mem_wb(65 downto 34);
end if;
end process;


end Behavioral;
