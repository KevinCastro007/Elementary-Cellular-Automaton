package Files is

    N000 : STRING(1..8) := "N000.ppm";
    N001 : STRING(1..8) := "N001.ppm";
    N002 : STRING(1..8) := "N002.ppm";
    N003 : STRING(1..8) := "N003.ppm";
    N004 : STRING(1..8) := "N004.ppm";
    N005 : STRING(1..8) := "N005.ppm";
    N006 : STRING(1..8) := "N006.ppm";
    N007 : STRING(1..8) := "N007.ppm";
    N008 : STRING(1..8) := "N008.ppm";
    N009 : STRING(1..8) := "N009.ppm";

    N010 : STRING(1..8) := "N010.ppm";
    N011 : STRING(1..8) := "N011.ppm";
    N012 : STRING(1..8) := "N012.ppm";
    N013 : STRING(1..8) := "N013.ppm";
    N014 : STRING(1..8) := "N014.ppm";
    N015 : STRING(1..8) := "N015.ppm";
    N016 : STRING(1..8) := "N016.ppm";
    N017 : STRING(1..8) := "N017.ppm";
    N018 : STRING(1..8) := "N018.ppm";
    N019 : STRING(1..8) := "N019.ppm";

    N020 : STRING(1..8) := "N020.ppm";
    N021 : STRING(1..8) := "N021.ppm";
    N022 : STRING(1..8) := "N022.ppm";
    N023 : STRING(1..8) := "N023.ppm";
    N024 : STRING(1..8) := "N024.ppm";
    N025 : STRING(1..8) := "N025.ppm";
    N026 : STRING(1..8) := "N026.ppm";
    N027 : STRING(1..8) := "N027.ppm";
    N028 : STRING(1..8) := "N028.ppm";
    N029 : STRING(1..8) := "N029.ppm";

    type MY_FILES is array(0..29) of STRING(1..8);
    PPM_Files : constant MY_FILES := (N000,N001,N002,N003,N004,N005,N006,N007,N008,N009,
    									N010,N011,N012,N013,N014,N015,N016,N017,N018,N019,
    									N020,N021,N022,N023,N024,N025,N026,N027,N028,N029);	
end Files;

