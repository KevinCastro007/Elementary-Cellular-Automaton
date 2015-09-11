
package body My_Types is

    -- Convert the N decimal number to a byte.
    procedure N_To_Byte(N : in INTEGER; N_Byte : out MY_BYTE) is

        Counter : INTEGER;        -- Bits counter.
        Number  : INTEGER;

    begin
        Counter := 0;
        Number := N;
        while Number /= 0 loop
            N_Byte(Counter) := MY_BIT(Number mod 2);
            Counter := Counter + 1;
            Number := Number / 2;
        end loop;       
        while Counter <= 7 loop 	-- 8 Bits.
            N_Byte(Counter) := 0;
            Counter := Counter + 1;
        end loop;         
    end N_To_Byte; 

    -- Convert the N decimal number to a binary triad.
    procedure N_to_Triad(N : in INTEGER; N_Triad : out MY_TRIAD) is   

        Counter : INTEGER;        -- Bits counter.
        Number  : INTEGER;        

    begin
        Counter := 0;    
        Number := N;
        while Number /= 0 loop
            N_Triad(Counter) := MY_BIT(Number mod 2);
            Counter := Counter + 1;
            Number := Number / 2;
        end loop;       
        while Counter <= 2 loop 	-- 3 Bits.
            N_Triad(Counter) := 0;
            Counter := Counter + 1;
        end loop;  
    end N_to_Triad;
        
end My_Types;