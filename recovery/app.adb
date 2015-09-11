
with Ada.Text_IO, Ada.Strings.Unbounded, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random, My_Types, Bitmap_Store, Files; 
use Ada.Text_IO, Ada.Strings.Unbounded, Ada.Integer_Text_IO, My_Types, Bitmap_Store, Files;

-- Sequence of One-dimensional Cellular Automatas.
procedure App is
                                    -- Procedure and functions.
    procedure Create_Configuration; 
    procedure Set_Configuration; 
    procedure Show_Configuration;
    function Pattern_Result return MY_BIT;
    procedure Initialize_Sequence(N : in INTEGER); 
    procedure Update_Sequence(I : in INTEGER; Image_Width : in INTEGER; Color : in PIXEL); 
    procedure Traverse_Sequence; 

    subtype Colors_Indexes is INTEGER range 1..5;
    package Random_Color is new Ada.Numerics.Discrete_Random(Colors_Indexes);
    use Random_Color;
    G : Generator;
    C : Colors_Indexes;    

                                    -- Setting my types IO.
    package Bit_IO is new Ada.Text_IO.Modular_IO(MY_BIT);
    use Bit_IO;     

    T             : INTEGER;        -- Time T which defines the amount of states and the bitmap dimensions.
    N             : INTEGER;        -- Number N to define the configuration.
    N_Byte        : MY_BYTE;        -- Byte.
    N_Triad       : MY_TRIAD;       -- Triad.

                                -- Useful pointers declaration.                
    First_Pattern : PATTERN_POINTER;
    Last_Pattern  : PATTERN_POINTER;
    Temp_Pattern  : PATTERN_POINTER;

    First_Automata : AUTOMATA_POINTER;
    Last_Automata  : AUTOMATA_POINTER;
    Temp_Automata  : AUTOMATA_POINTER;

    --Color        : INTEGER;
    Image_Height : INTEGER;
    Image_Width  : INTEGER;
    --File_Name    : STRING(1..8);

    -- Create the specific pattern's configuration.
    procedure Create_Configuration is
    begin     
        for Pattern_Num in 0..7 loop                    -- From 000 to 111.
            Temp_Pattern := new PATTERN_REC;            -- New Pattern - Configuration. 
            N_to_Triad(Pattern_Num, N_Triad);           -- Decimal to Binary (Triad).
            Temp_Pattern.Triad := N_Triad;              -- Setting the triad.  
            if First_Pattern = null then
                First_Pattern := Temp_Pattern;
                Last_Pattern := Temp_Pattern;
            else                
                Last_Pattern.Next := Temp_Pattern;
                Last_Pattern := Temp_Pattern;  
            end if;            
        end loop;         
    end Create_Configuration;    

    -- Set the specific pattern's configuration.
    procedure Set_Configuration is
    begin     
        Temp_Pattern := First_Pattern;              
        for Pattern_Num in 0..7 loop                    -- From 000 to 111. 
            Temp_Pattern.Bit := N_Byte(Pattern_Num);    -- Getting and setting the specific bit result.
            Temp_Pattern     := Temp_Pattern.Next;         
        end loop;         
    end Set_Configuration;     

    procedure Show_Configuration is 
    begin
        Temp_Pattern := First_Pattern;
        if Temp_Pattern = null then
            Put("No data in list.");
        else
            Put_Line("- Configuration -");
            while Temp_Pattern /= null loop		-- Display the triads and their result bit. (000..111)
                Put(Temp_Pattern.Triad(2));
                Put(Temp_Pattern.Triad(1));
                Put(Temp_Pattern.Triad(0));
                Put(" -> ");
                Put(Temp_Pattern.Bit);
                New_Line;
                Temp_Pattern := Temp_Pattern.Next;
            end loop;
        end if;
    end Show_Configuration;

    -- Returns the bit related to a specific triad that belongs to the configuration.
    function Pattern_Result return MY_BIT is         
    begin
        Temp_Pattern := First_Pattern;   
        while Temp_Pattern.Triad /= N_Triad loop	-- Looking for the equivalet triad.
            Temp_Pattern := Temp_Pattern.Next;
        end loop;
        return Temp_Pattern.Bit;					-- Returns the result bit.
    end Pattern_Result;                 

    -- Output the Automatas Sequence.
    procedure Traverse_Sequence is
    begin
        Temp_Automata := First_Automata;
        if Temp_Automata = null then
            Put("No data in list.");
        else
            loop                    -- Moving around the list and displaying the values.
                Put(Temp_Automata.Bit);
                Temp_Automata := Temp_Automata.Next;
                exit when Temp_Automata = null;
            end loop;
       end if;
       New_Line;
    end Traverse_Sequence;

    -- Initializate the N Automatas sequence, from i = 0..(N - 1).
    procedure Initialize_Sequence(N : in INTEGER) is        
    begin
        for I in 0..(N - 1)  loop               -- Setting the required Automatas.
            Temp_Automata := New AUTOMATA_REC;
            if I = (N - 1) / 2 then
                Temp_Automata.Bit := 1;
                Set_Pixel(Image_Width, 0, I, My_Colors(C));    
            else
                Temp_Automata.Bit := 0;
            end if;

            if First_Automata = null then                    
                First_Automata := Temp_Automata;
                Last_Automata := Temp_Automata;
            else
                Last_Automata.Next := Temp_Automata;
                Temp_Automata.Previous := Last_Automata;
                Last_Automata := Temp_Automata;    
            end if;
        end loop;        
    end Initialize_Sequence;

    -- Develope the state of the Automatas according to the Configuration.
    procedure Update_Sequence(I : in INTEGER; Image_Width : in INTEGER; Color : in PIXEL) is

        Stored_Bit : MY_BIT;							-- Backup bit.

    begin
        Temp_Automata := First_Automata;
        Stored_Bit := Temp_Automata.Bit;
        for J in 0..(Image_Width - 1)  loop
														-- Special cases.
            if Temp_Automata.Previous = null or Temp_Automata.Next = null then
                if First_Pattern.Bit = 1 and Last_Pattern.Bit = 0 then
                    Temp_Automata.Bit := not Temp_Automata.Bit;
                end if; 
            else
                N_Triad(2) := Stored_Bit;				-- Setting the triad.
                N_Triad(1) := Temp_Automata.Bit;
                N_Triad(0) := Temp_Automata.Next.Bit;
                Stored_Bit := Temp_Automata.Bit;
                Temp_Automata.Bit := Pattern_Result;	-- Getting the bit result.
            end if;			
			if Temp_Automata.Bit = 1 then
				Set_Pixel(Image_Width, I, J, Color);			
			end if;			
            Temp_Automata := Temp_Automata.Next;
        end loop;        
    end Update_Sequence;


    Temp_Name : Unbounded_String;   
    Post_Name : STRING(1..11);    

begin
-- <<Get_T>>
--     Put("Type T: "); Get(T);                        -- Data input: Time T.
--     if T < 0 then 
--         Put_Line("T should be greater than 0.");
--         goto Get_T;
--     end if;
-- <<Get_N>>
--     Put("Type N: "); Get(N);                        -- Data input: Number N.
--     if N < 0 or N > 255 then
--         Put_Line("N should be between 0 and 255.");
--         goto Get_N;
--     end if;
-- <<Get_Colors>>
--     Put_Line("Available colors -> Black:0, White:1, Red:2, Green:3, Blue:4, Yellow:5.");
--     Put("#Color: "); Get(Color);
--     if Color < 0 or Color > 5 then
--         Put_Line("Entry error. 0 <= #Color <= 5");
--         goto Get_Colors;
--     end if;  

--     Put("Output file name: ");
--     Get(File_Name);
       

    T := 256;        
    Image_Height := T;
    Image_Width := 2 * T;
    C := 1;
    Generate_Image(Image_Height * Image_Width);     
    Initialize_Sequence(Image_Width);    
    Create_Configuration;
    for N in 0..3 loop
        Reset(G);     -- Start the generator in a unique state in each run.
        C := Random(G);
        Temp_Name := To_Unbounded_String("N");
        Append(Temp_Name, To_Unbounded_String(Integer'Image(N / 100)));
        Append(Temp_Name, To_Unbounded_String(Integer'Image((N mod 100) / 10)));
        Append(Temp_Name, To_Unbounded_String(Integer'Image((N mod 100) mod 10)));
        Append(Temp_Name, To_Unbounded_String(".ppm"));
        Post_Name := To_String(Temp_Name);
        Put_Line(Post_Name);

        N_To_Byte(N, N_Byte);
        Set_Configuration;  
    Main_Loop:
        for I in 0..(Image_Height - 1) loop
            if I + 1 > (Image_Height - 1) then
                Put_PPM(Post_Name, Image_Height, Image_Width);
                Put_Line("PPM generated successfully.");
                Reset_Image;
                exit Main_Loop;
            else
                Update_Sequence(I, Image_Width, My_Colors(C)); 
            end if;
        end loop Main_Loop;
    end loop;

exception
  when Data_Error => Put_Line("Data Entry - Error");
                     Put("Program execution finished.");   
  when Constraint_Error => Put_Line("There was a problem");
                     Put("-> Problem");     
end App;