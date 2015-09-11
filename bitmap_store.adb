
package body Bitmap_Store is
 
	procedure Fill(Picture : in out IMAGE; Color : PIXEL) is
	begin
		for I in Picture'range (1) loop
			for J in Picture'range (2) loop
				Picture(I, J) := Color;
			end loop;
		end loop;
	end Fill;
 
	procedure Print(Picture : IMAGE) is
	begin
		for I in Picture'range (1) loop
			for J in Picture'range (2) loop
				if Picture(I, J) = WHITE then
				   Put('1');
				else
				   Put('0');
				end if;
			end loop;
			New_Line;
		end loop; 
	end Print;
	
	procedure Generate_Image(N : in INTEGER) is	
	begin
		Temp_Pixel 		 := new IMAGE_REC;
		Temp_Pixel.Color := BLACK;
		First_Pixel 	 := Temp_Pixel;
		Last_Pixel 	 	 := Temp_Pixel;
		for I in 1..(N - 1) loop
			Temp_Pixel       := new IMAGE_REC;
			Temp_Pixel.Color := BLACK;
			Last_Pixel.Next  := Temp_Pixel;
			Last_Pixel       := Temp_Pixel;
		end loop;	
	end Generate_Image;	


	function Generate_Pixel return PIXEL is

		My_Pixel : PIXEL;

	begin
		Reset(CG);
		My_Pixel := (R => LUMINANCE(Random(CG)), G => LUMINANCE(Random(CG)), B => LUMINANCE(Random(CG)));
		return My_Pixel;		
	end;


	procedure Reset_Image is	
	begin
		Temp_Pixel := First_Pixel;
		Temp_Pixel := Temp_Pixel.Next;
		while Temp_Pixel /= null loop
			Temp_Pixel.Color := BLACK;
			Temp_Pixel       := Temp_Pixel.Next;
		end loop;		
	end Reset_Image;		
	
	procedure Get_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : out PIXEL) is
	
		Position : INTEGER;
		Counter  : INTEGER := 0;
	
	begin
		Position   := (Width  * I) + J;
		Temp_Pixel := First_Pixel;
		while Counter /= Position loop			
			Temp_Pixel := Temp_Pixel.Next;
			Counter    := Counter + 1;
		end loop;		
		Color := Temp_Pixel.Color;
	end;
	
	procedure Set_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : in PIXEL) is

		Position : INTEGER;
		Counter  : INTEGER := 0;
	
	begin
		Position   := (Width  * I) + J;
		Temp_Pixel := First_Pixel;
		while Counter /= Position loop			
			Temp_Pixel := Temp_Pixel.Next;
			Counter    := Counter + 1;
		end loop;		
		 Temp_Pixel.Color := Color;
	end;	
 
	procedure Put_PPM(File_Name : in STRING; Height : in INTEGER; Width : in INTEGER) is

		SIZE   	  : constant STRING := Integer'IMAGE(Width) & Integer'IMAGE(Height);
		Buffer 	  : STRING(1..Width * 3);
		Color  	  : PIXEL;
		Index  	  : POSITIVE;
		File 	  : FILE_TYPE;	 

	begin	
		Create(File, Out_File, File_Name);
		STRING'Write(Stream(File), "P6" & LF);
		STRING'Write(Stream(File), SIZE(2..SIZE'LAST) & LF);
		STRING'Write(Stream(File), "255" & LF);
		for I in 0..(Height - 1) loop
			Index := Buffer'FIRST;
			for J in 0..(Width - 1) loop
				Get_Pixel(Width, I, J, Color);
				Buffer(Index)     := CHARACTER'Val(Color.R);
				Buffer(Index + 1) := CHARACTER'Val(Color.G);
				Buffer(Index + 2) := CHARACTER'Val(Color.B);
				Index := Index + 3;
			end loop;
			STRING'Write(Stream(File), Buffer);
		end loop;
		CHARACTER'Write(Stream(File), LF);
		Close(File);		
	end Put_PPM;    
end Bitmap_Store;