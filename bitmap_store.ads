
with Ada.Text_IO;              use Ada.Text_IO; 
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Characters.Latin_1;   use Ada.Characters.Latin_1;
with Ada.Numerics.Discrete_Random;

package Bitmap_Store is

	type LUMINANCE is mod 2**8;
   
	type PIXEL is record
		R, G, B : LUMINANCE;
	end record;

	type COLORS is array(0..5) of PIXEL;

	type IMAGE is array (NATURAL range <>, NATURAL range <>) of PIXEL;
	
	type IMAGE_REC;
	type PIXEL_POINTER is access IMAGE_REC;
	
	type IMAGE_REC is record
		Color 	: PIXEL;
		Next 	: PIXEL_POINTER;
	end record;

	BLACK  : constant PIXEL := (others => 0);
	WHITE  : constant PIXEL := (others => 255);
	
	subtype COLOR_RANGE is INTEGER range 0..255;
    package Random_Color is new Ada.Numerics.Discrete_Random(COLOR_RANGE);
    use Random_Color;
    CG : GENERATOR;
	
	First_Pixel : PIXEL_POINTER;
	Last_Pixel 	: PIXEL_POINTER;
	Temp_Pixel 	: PIXEL_POINTER;

	procedure Fill(Picture : in out IMAGE; Color : PIXEL);

	procedure Print(Picture : IMAGE);
	
	procedure Generate_Image(N : in INTEGER);

	function Generate_Pixel return PIXEL;

	procedure Reset_Image;
	
	procedure Get_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : out PIXEL);
	
	procedure Set_Pixel(Width : in INTEGER; I : in INTEGER; J : in INTEGER; Color : in PIXEL);
	
	procedure Put_PPM(File_Name : in STRING; Height : in INTEGER; Width : in INTEGER);	

end Bitmap_Store;