clear
clc

[Kg,kg,lb,N,Newton,lbf,ft,feet,C,celcius,minutes,seconds,amperes,amps,cm,...
    centimeters,mm,millimeters,liters,L, kg_m_3,kilogram_per_meter_cubed,...
    g_cm_3,gram_per_meter_cubed,Fahrenheit,F,K,Kelvin,Bar,bar,atm,gal,...
    gallons,inches,in,cm_cubed,psi,Pounds_Per_Square_Inch,meter,Meter...
    ,M,m,kilometers,km,Km,Kilometers,g0,R,Molar_Mass_Air] = myvariables();


%% issue with this code due to possible changing values down the line



% in the simulation I will use height values given through 
% calculation to calculate pressure wheras in the navigation telemetry we 
% will calculate this with pressures.
Relative_Humidity= 0.10; % put in terms of decimals instead of percentage i.e. 10 percent is .10
Pressure_Sea_level = 14.4;

Std_temp_Sea_Level=unitconversion(67,Fahrenheit);
Std_Temp_Lapse_Rate = -0.0065;
Height_From_Sea_Level = unitconversion(60, Kilometers);
Troposphere_Ceiling = unitconversion(11,Km);
Stratosphere_Ceiling =unitconversion(50,Km);
Mesosphere_Ceiling =unitconversion(80,Km);
Karman_Line = unitconversion(100,Km);
Height_Layer=60000;
if Height_From_Sea_Level < Troposphere_Ceiling
Height_Layer= 0;
end
if (Troposphere_Ceiling < Height_From_Sea_Level)
Height_Layer = Troposphere_Ceiling;
end
if (Stratosphere_Ceiling < Height_From_Sea_Level)
Height_Layer= Stratosphere_Ceiling;
end
if (Mesosphere_Ceiling < Height_From_Sea_Level)
Height_Layer= Mesosphere_Ceiling;
end
if Karman_Line< Height_From_Sea_Level
disp("No Air escaped to space!")
end
% else
%     disp("atmosphere function failed defaulted to 14.4 psi")
%     atmfunctionfailed=1;
% end
disp("Height_Layer")
disp(Height_Layer)


Vapor_Pressure= Pressure_Sea_level*(1+((Std_Temp_Lapse_Rate)/Std_temp_Sea_Level)...
    *(Height_From_Sea_Level-Height_Layer))^((g0*Molar_Mass_Air)/(R*Std_Temp_Lapse_Rate));
%Vapor_Pressure = unitconversion(14.4, psi);
Temperature_Air = (unitconversion(30, Fahrenheit));
R_Vapor = 461.495; % J/(Kg*K)
R_Dry_Air = 287.058; % J/(Kg*K)
Total_Air_Pressure= 6.1078*10^((7.5*Temperature_Air)/(Temperature_Air+237.3));

Actual_Vapor_Pressure = Vapor_Pressure * Relative_Humidity;
Pressure_Dry_Air = Total_Air_Pressure - Actual_Vapor_Pressure;
Air_density = (Pressure_Dry_Air/(R_Dry_Air*Temperature_Air))+...
    (Actual_Vapor_Pressure/(R_Vapor*Temperature_Air));
disp("Pressure_Dry_Air")
disp(Pressure_Dry_Air)
disp("Actual_Vapor_Pressure")
disp(Actual_Vapor_Pressure)
disp("Air_density")
disp(Air_density)

function [Kg,kg,lb,N,Newton,lbf,ft,feet,C,celcius,minutes,seconds,amperes,...
    amps,cm,centimeters,mm,millimeters,liters,L, kg_m_3,...
    kilogram_per_meter_cubed,g_cm_3,gram_per_meter_cubed,Fahrenheit,...
    F,K,Kelvin,Bar,bar,atm,gal,gallons,inches,in,cm_cubed,psi,...
    Pounds_Per_Square_Inch,meter,Meter,M,m,kilometers,km,Km,Kilometers,...
    g0,R,Molar_Mass_Air] = myvariables()
kg=1;
Kg=1;
lb=2;
N=1;
Newton=1;
lbf=4;
ft=5;
feet=5;
C=6;
celcius=6;
minutes=7;
seconds=1;
amperes=1;
amps=1;
meter=1;
Meter=1;
M=1;
m=1;
cm=9;
centimeters=9;
mm=10;
millimeters=10;
liters=11;
L=11;
kg_m_3=1;
kilogram_per_meter_cubed=1;
g_cm_3=13;
gram_per_meter_cubed=13;
Fahrenheit=14;
F=14;
K=1;
Kelvin = 1;
Bar=17;
bar=17;
atm=18;
gal = 19;
gallons = 19;
inches=20 ;
in=20;
cm_cubed=21;
psi=22;
Pounds_Per_Square_Inch=22;
Kilometers= 23;
kilometers= 23;
km=23;
Km=23;
g0=9.80665; %m/s gravity constant
R=8.314; %J/mol Real gas constant
Molar_Mass_Air= 0.0289644; %[kg/mol]
end
function SI = unitconversion(number, Unit)
    switch Unit 
        case 1 % KG to KG
            SI = number;
        case 2 % lbs to KG
            SI = number * 0.45359237; 
        case 4 % lbf to N
            SI = number * 4.44822162;
        case 5 % feet to M
            SI = number / 3.28084;
        case 6 % Celsius to Kelvin
            SI = number + 273.15;
        case 7 % minutes to seconds
            SI = number * 60;
        case 9 % cm to meters
            SI = number / 100;
        case 10 % mm to meters
            SI = number / 1000;
        case 11 % liter to cubic meters
            SI = number / 1000;
        case 13 % density g/cm^3 to kg/m^3
            SI = number * 1000;
        case 14 % Fahrenheit to Kelvin
            SI = (number - 32) * 5/9 + 273.15;
        case 16 % Pascal to Pascal
            SI = number;
        case 17 % bar to Pascal
            SI = number * 1e5;
        case 18 % atmosphere to Pascal
            SI = number * 101325;
        case 19 %gal to m^3
            SI = number*0.02933694;
        case 20 % inches to m
            SI = number*0.0254;
        case 21 % cm^3 to m^3
            SI = number*0.000001;
        case 22 % PSI to N/(M^2)
            SI = Number*6895;
        case 23 %Kilometers to meters
            SI=number*1000;
        otherwise 
            SI=number;
    end
end
function [interpolated_Value] = Linear_interpolator(X1,X2,X3,Y1,Y3)
interpolated_Value=(((X2-X1)/(X3-X1))*(Y3-Y1)+Y1);
end