%%
clear
clc

Kg=1;
lb=2;
N=1;
Newton=3;
lbf=4;
ft=5;
feet=5;
C=6;
celcius=6;
minutes=7;
amperes=1;
amps=1;
cm=9;
centimeters=9;
mm=10;
millimeters=10;
liter=11;
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
%%
       


% total time burning fuel and lox
Burn_time = 10; % seconds





% radius of beer keg is 11.125 inches height is 23.325 in 
rocket_diameter = unitconversion(12.5, inches); % cm = 12.5 in 
% 
%width of rocket is 12.5 inches
nose_cone_area= 0.4249501178; % m^2   = 658.674; %in^2

%for a tangent ogave nose cone
Cd_Rocket=0.154;
Air_Density_launch= 1.24462; % kg/m^3

Force_Drag_rocket=0;
Force_Drag_rocket(2,1)=1;







% starting point meters
z_0 = 0;
% final altitude meters = 25000 feet
Z_F = 7620; % meters
% acceleration due to gravity 
g = -9.80665; % meters/second^2
% mass start
M_Rocket_empty = 1000; %kg
% mass fuel




Volume_fuel = unitconversion(7.75, gallons); %gallons
Volume_lox  = unitconversion(7.75, gallons); %gallons

density_fuel = unitconversion(814.819724, kg_m_3);
density_lox  = unitconversion(1141, kg_m_3);





M_Fuel = Volume_fuel*density_fuel; %kg
M_lox =Volume_lox*density_lox; %kg
% mass at launch
Mass_Launch = M_lox+M_Fuel+M_Rocket_empty; %kg
Mass_Final = M_Rocket_empty; %kg
% difference between mass at launch and mass final
Mass_burned = M_lox+M_Fuel;
M_dot_burn = ((M_lox+M_Fuel)/Burn_time); % burn_rate
i=1; %interval
exhaust_exit_velocity = 2050; %m/s








Force_Thrust = M_dot_burn * exhaust_exit_velocity;

Rocket_momentary_mass(1,1) = Mass_Launch; %initializes Momentary rocket mass
Momentary_gravity_Force(1,1)= Mass_Launch*g;

Force_balance(1,1)= (Momentary_gravity_Force(1,1)) + Force_Thrust;

Momentary_Position_Z(1,1)=0;
Momentary_Velocity_Z(1,1) = 0;
Momentary_acceleration(1,1)=(Force_balance(1,1))/(Rocket_momentary_mass(1,1));
Momentary_Position_Z(2,1)=Momentary_Position_Z(1,1) + Momentary_Velocity_Z(1,1) +((1/2)*(Momentary_acceleration(1,1))^2);


for time=1:Burn_time
Rocket_momentary_mass((time+1),1)=Rocket_momentary_mass(time,1)-M_dot_burn;
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g); %

Force_Drag_rocket((time+1),1) = (1/2)*(Air_Density_launch)*((Momentary_Velocity_Z(time,1))^2)*(Cd_Rocket)*(nose_cone_area);

Force_balance((time+1),1)= (Momentary_gravity_Force(time,1)) + Force_Thrust - Force_Drag_rocket(time,1);
Momentary_acceleration((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_Velocity_Z((time+1),1)= Momentary_Velocity_Z(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_Velocity_Z((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));



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
while Momentary_Velocity_Z(time,1)>0
    disp("time")
    disp(time)
Rocket_momentary_mass(time+1,1)=(Mass_Final);
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g); 
% force of drag is calculated based on previous second's velocity
Force_Drag_rocket((time+1),1) = (1/2)*(Air_Density_launch)*((Momentary_Velocity_Z(time,1))^2)*(Cd_Rocket)*(nose_cone_area);

% this piece of code adds terminal velocity 
% if -(Momentary_gravity_Force(time,1)) > Force_Drag_rocket(time,1)
%     Force_balance((time+1),1)= (Momentary_gravity_Force(time,1))  Force_Drag_rocket(time,1);
% else
%     Force_balance((time+1),1)=0;
% end

Force_balance((time+1),1)= (Momentary_gravity_Force(time,1)); % Force_Drag_rocket(time,1);
Momentary_acceleration_Z((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_Velocity_Z((time+1),1)= Momentary_Velocity_Z(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_Velocity_Z((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));
time=time+1;





end








%%
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

%%


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
        otherwise 
            SI=number;
    end
end





