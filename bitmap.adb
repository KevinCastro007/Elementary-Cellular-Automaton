
package body Bitmap is
	
	-- Fills an image 2 X 2T with an specific pixel.
	procedure Fill(Picture : in out Image; Color : Pixel) is
	begin
	    for I in Picture'Range (1) loop
	        for J in Picture'Range (2) loop
	        	Picture (I, J) := Color;
	    	end loop;
	  	end loop;
	end Fill;	

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

 	-- Export the linked list "image" to a Portable Pixel Map (.ppm) image.
	procedure Export_PPM(Height : in INTEGER; Width : in INTEGER; My_Image : in IMAGE) is

		SIZE   	  : constant STRING := Integer'IMAGE(My_Image'LENGTH(2)) & Integer'IMAGE(My_Image'LENGTH(1));		
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
		for I in My_Image'RANGE (1)  loop 			-- Image height.
			Index := Buffer'FIRST;
			for J in My_Image'RANGE (2) loop 		-- Image width.
				Color := My_Image(I, J);			-- Get the pixel in the specific position.
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