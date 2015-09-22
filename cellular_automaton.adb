-- This program was created by Kevin Castro @kedac007.
-- Escuela de Ingeniería en Computación.
-- Instituto Tecnológico de Costa Rica.

-- Ada Libraries.
with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;

-- My Libraries
with My_Types, Bitmap; use My_Types, Bitmap;

procedure Cellular_Automaton is

    -- Procedure and functions declaration.
    function Pattern_Result return MY_BIT;
    procedure Set_Configuration; 
    procedure Update_Sequence(I : in INTEGER; Image_Width : in INTEGER; Color : in PIXEL; My_Image : in out IMAGE); 

    -- Variables declaration
    T             : INTEGER;        -- Time T which defines the amount of states and the bitmap dimensions.
    N             : INTEGER;        -- Number N to define the configuration.
    N_Byte        : MY_BYTE;        -- Byte.
    N_Triad       : MY_TRIAD;       -- Triad.

    -- Image properties.
    Image_Height : INTEGER;
    Image_Width  : INTEGER;
    Color : PIXEL;

    -- Useful pointers declaration.                
    -- Configuration patterns.
    First_Pattern : PATTERN_POINTER;
    Last_Pattern  : PATTERN_POINTER;
    Temp_Pattern  : PATTERN_POINTER;

    -- Create the specific pattern's configuration.
    procedure Set_Configuration is
    begin       
        N_To_Byte(N, N_Byte);                           -- Decimal N to Byte.
        for Pattern_Num in 0..7 loop                    -- From 000 to 111.
            Temp_Pattern := new PATTERN_RECORD;         -- New Pattern - Configuration. 
            N_to_Triad(Pattern_Num, N_Triad);           -- Decimal to Binary (Triad).
            Temp_Pattern.Triad := N_Triad;              -- Setting the triad.
            Temp_Pattern.Bit := N_Byte(Pattern_Num);  
            if First_Pattern = null then
                First_Pattern := Temp_Pattern;
                Last_Pattern := Temp_Pattern;
            else                
                Last_Pattern.Next := Temp_Pattern;
                Last_Pattern := Temp_Pattern;  
            end if;            
        end loop;         
    end Set_Configuration;      

    -- Develope the state of the Automatas according to the Configuration.
    procedure Update_Sequence(I : in INTEGER; Image_Width : in INTEGER; Color : in PIXEL; My_Image : in out IMAGE) is
    begin
        for J in 0..(Image_Width - 1)  loop             -- Evaluating Ai-1, Ai, Ai+1. i = 0..(2T - 1).
														-- Special cases: First and Last automata.
            if J = 0 or J = (Image_Width - 1) then
                if First_Pattern.Bit = 1 and Last_Pattern.Bit = 0 then
                    if My_Image(I, J) = BLACK then
                        My_Image(I + 1, J) := Color;
                    end if;
                end if;  
                if Last_Pattern.Bit = 1 then
                    if First_Pattern.Bit /= 0 then   
                        My_Image(I + 1, J) := Color;
                    end if;
                end if;            
            else                                        -- Common cases.
                N_Triad(2) := 0;				        -- Setting the triad.
                N_Triad(1) := 0;
                N_Triad(0) := 0;

                if My_Image(I, J - 1) /= BLACK then
                    N_Triad(2) := 1;                                    
                end if;
                if My_Image(I, J) /= BLACK then
                    N_Triad(1) := 1;                    
                end if;
                if My_Image(I, J + 1) /= BLACK then
                    N_Triad(0) := 1;                    
                end if;

                if Pattern_Result = 1 then              -- Image change.
                    My_Image(I + 1, J) := Color;
                end if;
            end if;			
        end loop;        
    end Update_Sequence;

    -- Returns the bit related to a specific triad that belongs to the configuration.
    function Pattern_Result return MY_BIT is         
    begin
        Temp_Pattern := First_Pattern;   
        while Temp_Pattern.Triad /= N_Triad loop    -- Looking for the equivalet triad.
            Temp_Pattern := Temp_Pattern.Next;
        end loop;
        return Temp_Pattern.Bit;                    -- Returns the result bit.
    end Pattern_Result;      

begin
<<Get_T>>
    Put("Type T: "); Get(T);                        -- Data input: Time T.
    if T < 0 then 
        Put_Line("T should be greater than 0.");
        goto Get_T;
    end if;
<<Get_N>>
    Put("Type N: "); Get(N);                        -- Data input: Number N.
    if N < 0 or N > 255 then
        Put_Line("N should be between 0 and 255.");
        goto Get_N;
    end if; 
   
    Image_Height := T;                              -- Setting the image dimensions.
    Image_Width := 2 * T;
    Color := Generate_Pixel;                        -- Random color.
    Set_Configuration;                              -- Setting the configuration, with the number N.

    declare                                         -- Image declaration.
        My_Image : Image(0..(Image_Height - 1), 0..(Image_Width - 1));
    begin
        Fill(My_Image, (0, 0, 0));                  -- Default image.
        My_Image(0, (Image_Width - 1) / 2) := WHITE;
    Main_Loop:
        for I in 0..(Image_Height - 1) loop         -- Proccesing the times t from T.
            if I + 1 = Image_Height then
                Export_PPM(Image_Height, Image_Width, My_Image);
                Put_Line("PPM generated successfully.");
                exit Main_Loop;
            else
                Update_Sequence(I, Image_Width, Color, My_Image); 
            end if;
        end loop Main_Loop;
    end;    

exception
    when Data_Error => Put_Line("Data Entry - Error");
                     Put("Program execution finished.");     
end Cellular_Automaton;