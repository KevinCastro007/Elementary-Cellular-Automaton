
package My_Types is

    type MY_BIT is mod 2;                       
    type MY_TRIAD is array(0..2) of MY_BIT;     
    type MY_BYTE is array(0..7) of MY_BIT;          
    type PATTERN_RECORD;
    type PATTERN_POINTER is access PATTERN_RECORD;

    -- Configuration of each triad patterns and its result (bit).
    type PATTERN_RECORD is
        record
            Triad   : MY_TRIAD;
            Bit     : MY_BIT;
            Next    : PATTERN_POINTER;
        end record;

    procedure N_To_Byte(N : in INTEGER; N_Byte : out MY_BYTE); 
    procedure N_to_Triad(N : in INTEGER; N_Triad : out MY_TRIAD);        

end My_Types;