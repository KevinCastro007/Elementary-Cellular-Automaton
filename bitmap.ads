
-- Ada libraries.
with Ada.Text_IO;              use Ada.Text_IO; 
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Characters.Latin_1;   use Ada.Characters.Latin_1;
with Ada.Numerics.Discrete_Random;

package Bitmap is

	type LUMINANCE is mod 2 ** 8;		-- Luminance define: from 0 to 255.
   
	type PIXEL is record
		R, G, B : LUMINANCE;			-- RGB Colors.
	end record;

    type IMAGE is array(NATURAL range <>, NATURAL range <>) of PIXEL;

	-- Colors declarations.
	BLACK  : constant PIXEL := (others => 0);
	WHITE  : constant PIXEL := (others => 255);	
	subtype COLOR_RANGE is INTEGER range 0..255;
    package Random_Color is new Ada.Numerics.Discrete_Random(COLOR_RANGE);
    use Random_Color;
    Color_Generator : GENERATOR;

	procedure Fill(Picture : in out Image; Color : Pixel);
	procedure Export_PPM(Height : in INTEGER; Width : in INTEGER; My_Image : in IMAGE);	
	function Generate_Pixel return PIXEL;

end Bitmap;