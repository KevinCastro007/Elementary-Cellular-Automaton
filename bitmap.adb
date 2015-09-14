
package body Bitmap is
	
	-- Generate an image 2 X 2T pixels like a linked list.
	procedure Generate_Image(Size : in INTEGER) is	
	begin
		Temp_Pixel 		 := new PIXEL_RECORD;
		Temp_Pixel.Color := BLACK;					-- Black is the default color.
		First_Pixel 	 := Temp_Pixel;
		Last_Pixel 	 	 := Temp_Pixel;
		for I in 1..(Size - 1) loop
			Temp_Pixel       := new PIXEL_RECORD;
			Temp_Pixel.Color := BLACK;
			Last_Pixel.Next  := Temp_Pixel;
			Last_Pixel       := Temp_Pixel;
		end loop;	
	end Generate_Image;	

	-- Generate a random pixel color.
	function Generate_Pixel return PIXEL is

		My_Pixel : PIXEL;

	begin
		Reset(Color_Generator);
		My_Pixel := (R => LUMINANCE(Random(Color_Generator)), 	-- Random Red amount.
				     G => LUMINANCE(Random(Color_Generator)),   -- Random Green amount.
				 	 B => LUMINANCE(Random(Color_Generator)));  -- Random Blue amount.
		return My_Pixel;		
	end;	

	-- Get a specific pixel in the linked list image.	
	procedure Get_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : out PIXEL) is
	
		Position : INTEGER;
		Counter  : INTEGER := 0;
	
	begin
		Position   := (Width  * I) + J;		-- Calculating the specific position.
		Temp_Pixel := First_Pixel;
		while Counter /= Position loop		-- Looking for the position.	
			Temp_Pixel := Temp_Pixel.Next;
			Counter    := Counter + 1;
		end loop;		
		Color := Temp_Pixel.Color;
	end;
	
	-- Set a specific pixel in the linked list image.		
	procedure Set_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : in PIXEL) is

		Position : INTEGER;
		Counter  : INTEGER := 0;
	
	begin
		Position   := (Width  * I) + J;		-- Calculating the specific position.
		Temp_Pixel := First_Pixel;
		while Counter /= Position loop		-- Looking for the position.			
			Temp_Pixel := Temp_Pixel.Next;
			Counter    := Counter + 1;
		end loop;		
		 Temp_Pixel.Color := Color;
	end;	
 
 	-- Export the linked list "image" to a Portable Pixel Map (.ppm) image.
	procedure Export_PPM(Height : in INTEGER; Width : in INTEGER) is

		SIZE   	  : constant STRING := Integer'IMAGE(Width) & Integer'IMAGE(Height);
		Buffer 	  : STRING(1..Width * 3);	-- Buffer to each line: RGB pixels.
		Color  	  : PIXEL;
		Index  	  : POSITIVE;
		File 	  : FILE_TYPE;

	begin	
		Create(File, Out_File, "Output.ppm");		-- Creating the output file.
													-- Setting the image configuration.
		STRING'Write(Stream(File), "P6" & LF);
		STRING'Write(Stream(File), SIZE(2..SIZE'LAST) & LF);
		STRING'Write(Stream(File), "255" & LF);
		for I in 0..(Height - 1) loop 				-- Image height.
			Index := Buffer'FIRST;
			for J in 0..(Width - 1) loop 			-- Image width.
				Get_Pixel(Width, I, J, Color);		-- Get the pixel in the specific position.
				Buffer(Index)     := CHARACTER'Val(Color.R);	-- Red value.
				Buffer(Index + 1) := CHARACTER'Val(Color.G);	-- Green value.
				Buffer(Index + 2) := CHARACTER'Val(Color.B);	-- Blue value.
				Index := Index + 3;								-- Moving 3 spaces.	
			end loop;
			STRING'Write(Stream(File), Buffer);					-- Writting the pixel.
		end loop;
		CHARACTER'Write(Stream(File), LF);
		Close(File);											-- Close the generated file.
	end Export_PPM;    
end Bitmap;