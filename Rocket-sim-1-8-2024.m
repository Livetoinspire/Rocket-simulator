%%
clear
clc
%Variable initialization
[Kg,kg,lb,N,Newton,lbf,ft,feet,C,celcius,minutes,seconds,amperes,amps,cm,...
    centimeters,mm,millimeters,liters,L, kg_m_3,kilogram_per_meter_cubed,...
    g_cm_3,gram_per_meter_cubed,Fahrenheit,F,K,Kelvin,Bar,bar,atm,gal,...
    gallons,inches,in,cm_cubed,psi,Pounds_Per_Square_Inch,meter,Meter...
    ,M,m,kilometers,km,Km,Kilometers,g0,R,Molar_Mass_Air] = myvariables();


% total time burning fuel and lox
Burn_time = 20; % seconds
time=1 ;
RelativeHumidity= 0.10; % put in terms of decimals instead of percentage i.e. 10 percent is .10
Vapor_Pressure=14.4;

% Actual_Vapor_Pressure = Vapor_Pressure * Relative_Humidity;
% Pressure_Dry_Air = Total_Air_Pressure - Actual_Vapor_Pressure;
% Air_density = (Pressure_Dry_Air/(R_Dry_Air*Air_Temperature));

% radius of beer keg is 11.125 inches height is 23.325 in 
rocket_diameter = unitconversion(12.5, inches); % cm = 12.5 in 
% 
%width of rocket is 12.5 inches
nose_cone_area= 0.4249501178; % m^2   = 658.674; %in^2

%for a tangent ogave nose cone
Tangent_Ogave= 0.154; % Coefficient of Drag for a tangent ogave nose cone
CD_rocket_side_profile =0.583; % found on Nasa Foilsim https://www1.grc.nasa.gov/beginners-guide-to-aeronautics/foilsimstudent/


%Initializing Coefficient of Drag 
Cd_Rocket=Tangent_Ogave;
Air_Density_launch= 1.24462; % kg/m^3 
M_Rocket_empty = 1000; %kg
exhaust_exit_velocity = 2050; %m/s
Volume_fuel = unitconversion(7.75, gallons); %gallons
Volume_lox  = unitconversion(7.75, gallons); %gallons
density_fuel = unitconversion(814.819724, kg_m_3);
density_lox  = unitconversion(1141, kg_m_3);
M_Fuel = Volume_fuel*density_fuel; %kg % mass fuel
M_lox =Volume_lox*density_lox; %kg
Mass_Launch = M_lox+M_Fuel+M_Rocket_empty; %kg % mass at launch
Mass_Final = M_Rocket_empty; %kg % difference between mass at launch and mass final
Mass_burned = M_lox+M_Fuel;
M_dot_burn = ((M_lox+M_Fuel)/Burn_time); % burn_rate
Force_Thrust = M_dot_burn * exhaust_exit_velocity;

Rocket_momentary_mass(1,1) = Mass_Launch; %initializes Momentary rocket mass
Momentary_gravity_Force(1,1)= Mass_Launch*g0;
Force_balance(1,1)= (Momentary_gravity_Force(1,1)) + Force_Thrust;
Momentary_Position_Z(1,1)=0;
Momentary_Velocity_Z(1,1) = 0;
Momentary_acceleration(1,1)=(Force_balance(1,1))/(Rocket_momentary_mass(1,1));
Momentary_Position_Z(2,1)=Momentary_Position_Z(1,1) + Momentary_Velocity_Z(1,1) +((1/2)*(Momentary_acceleration(1,1))^2);


while time<Burn_time
Rocket_momentary_mass((time+1),1)=Rocket_momentary_mass(time,1)-M_dot_burn;
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g0); %

Force_Drag_rocket((time+1),1) = (1/2)*(Air_Density_launch)*((Momentary_Velocity_Z(time,1))^2)*(Cd_Rocket)*(nose_cone_area);

Force_balance((time+1),1)= (Momentary_gravity_Force(time,1)) + Force_Thrust - Force_Drag_rocket(time,1);
Momentary_acceleration((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_Velocity_Z((time+1),1)= Momentary_Velocity_Z(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_Velocity_Z((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));

i=i+1;
time=time+1;
end


total_time=length(Momentary_Velocity_Z);
time_graph_start=1;
figure 
subplot(3,3,1)
plot((time_graph_start:1:total_time),Rocket_momentary_mass)
xlabel time(s)
ylabel mass(kg)
subplot(3,3,2)
plot((time_graph_start:1:total_time),Momentary_gravity_Force)
xlabel time(s)
ylabel force-due-to-gravity(N)
subplot(3,3,3)
plot((time_graph_start:1:total_time),Force_balance)
xlabel time(s)
ylabel force-balance-in-Z-direction(N)

subplot(3,3,4)
plot((time_graph_start:1:total_time),Momentary_acceleration)
xlabel time(s)
ylabel accelleration-(m/s^2)

subplot(3,3,5)
plot((time_graph_start:1:total_time),Momentary_Velocity_Z)
xlabel time(s)
ylabel velocity-m/s 

subplot(3,3,6)
plot((1:1:total_time+1),Momentary_Position_Z)
xlabel time(s)
ylabel Z-axis-displacement(m)

subplot(3,3,7)
plot((1:1:total_time),Force_Drag_rocket)
xlabel time(s)
ylabel Force-Drag-rocket

%%
while Momentary_Position_Z(time,1)>0
Rocket_momentary_mass(time+1,1)=(Mass_Final);
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g0); 
% force of drag is calculated based on previous second's velocity
Force_Drag_rocket((time+1),1) = (1/2)*(Air_Density_launch)*((Momentary_Velocity_Z(time,1))^2)*(Cd_Rocket)*(nose_cone_area);
Force_balance((time+1),1)= (Momentary_gravity_Force(time,1))+ Force_Drag_rocket(time,1);
Momentary_acceleration((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_Velocity_Z((time+1),1)= Momentary_Velocity_Z(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_Velocity_Z((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));
time=time+1;
end

%%
Grapher(Momentary_Velocity_Z,Rocket_momentary_mass,Momentary_gravity_Force,Force_balance,Momentary_acceleration,Momentary_Velocity_Z,Momentary_Position_Z)
%     disp("time")
%     disp(time)
% total_time=length(Momentary_Velocity_Z);
% time_graph_start=1;
% figure 
% subplot(2,3,1)
% plot((time_graph_start:1:total_time),Rocket_momentary_mass)
% xlabel time(s)
% ylabel mass(kg)
% subplot(2,3,2)
% plot((time_graph_start:1:total_time),Momentary_gravity_Force)
% xlabel time(s)
% ylabel force-due-to-gravity(N)
% subplot(2,3,3)
% plot((time_graph_start:1:total_time),Force_balance)
% xlabel time(s)
% ylabel force-balance-in-Z-direction(N)
% 
% subplot(2,3,4)
% plot((time_graph_start:1:total_time),Momentary_acceleration)
% xlabel time(s)
% ylabel accelleration-(m/s^2)
% subplot(2,3,5)
% plot((time_graph_start:1:total_time),Momentary_Velocity_Z)
% xlabel time(s)
% ylabel velocity-m/s 
% 
% subplot(2,3,6)
% plot((1:1:total_time+1),Momentary_Position_Z)
% xlabel time(s)
% ylabel Z-axis-displacement(m)

%%

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
            SI = 6894.76;
        otherwise 
            SI=number;
    end
end
function [interpolated_Value] = Linear_interpolator(X1,X2,X3,Y1,Y3)
interpolated_Value=(((X2-X1)/(X3-X1))*(Y3-Y1)+Y1);
end

function [i]=Grapher(Momentary_Velocity_Z,Rocket_momentary_mass,Momentary_gravity_Force,Force_balance,Momentary_acceleration,Momentary_Velocity_Z,Momentary_Position_Z)
    disp("time")
    disp(time)
total_time=length(Momentary_Velocity_Z);
time_graph_start=1;
figure 
subplot(2,3,1)
plot((time_graph_start:1:total_time),Rocket_momentary_mass)
xlabel time(s)
ylabel mass(kg)
subplot(2,3,2)
plot((time_graph_start:1:total_time),Momentary_gravity_Force)
xlabel time(s)
ylabel force-due-to-gravity(N)
subplot(2,3,3)
plot((time_graph_start:1:total_time),Force_balance)
xlabel time(s)
ylabel force-balance-in-Z-direction(N)

subplot(2,3,4)
plot((time_graph_start:1:total_time),Momentary_acceleration)
xlabel time(s)
ylabel accelleration-(m/s^2)
subplot(2,3,5)
plot((time_graph_start:1:total_time),Momentary_Velocity_Z)
xlabel time(s)
ylabel velocity-m/s 

subplot(2,3,6)
plot((1:1:total_time+1),Momentary_Position_Z)
xlabel time(s)
ylabel Z-axis-displacement(m)
i=1;
end

