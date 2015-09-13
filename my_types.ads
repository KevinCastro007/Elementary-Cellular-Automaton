
package My_Types is

    type MY_BIT is mod 2;                       
    type MY_TRIAD is array(0..2) of MY_BIT;     
    type MY_BYTE is array(0..7) of MY_BIT;          
    type PATTERN_REC;
    type PATTERN_POINTER is access PATTERN_REC;
    type AUTOMATA_REC;                             
    type AUTOMATA_POINTER is access AUTOMATA_REC;

    -- Configuration of each triad patterns and its result (bit).
    type PATTERN_REC is
        record
            Triad   : MY_TRIAD;
            Bit     : MY_BIT;
            Next    : PATTERN_POINTER;
        end record;

    -- One-dimensional Cellular Automaton.
    type AUTOMATA_REC is               
        record
            Bit      : MY_BIT;
            Next     : AUTOMATA_POINTER;
            Previous : AUTOMATA_POINTER;
        end record;  

    -- Convert the N decimal number to a byte.
    procedure N_To_Byte(N : in INTEGER; N_Byte : out MY_BYTE); 

    -- Convert the N decimal number to a binary triad.
    procedure N_to_Triad(N : in INTEGER; N_Triad : out MY_TRIAD);        

end My_Types;