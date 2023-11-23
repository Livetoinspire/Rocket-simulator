clear
clc
% radius of beer keg is 11.125 inches height is 23.325 in 

%width of rocket is 12.5 inches


%for nose_z=1:1:20
%nose_x= 
%nose_y= 
%end













% starting point meters
z_0 = 0;
% final altitude meters = 25000 feet
Z_F = 7620; % meters
% acceleration due to gravity 
g = -9.80665; % meters/second^2
% mass start
M_Rocket_empty = 200; %kg
% mass fuel
M_Fuel = 50; %kg
% mass lox
M_lox = 50; %kg
% mass at launch
Mass_Launch = M_lox+M_Fuel+M_Rocket_empty; %kg
Mass_Final = M_Rocket_empty; %kg
% total time burning fuel and lox
Burn_time = 20; % seconds
% difference between mass at launch and mass final
Mass_burned = M_lox+M_Fuel;
M_dot_burn = ((M_lox+M_Fuel)/Burn_time); % burn_rate
i=1; %interval
exhaust_exit_velocity = 2050; %m/s


Force_drag= -0; %Newtons
Force_Thrust = M_dot_burn * exhaust_exit_velocity;

Rocket_momentary_mass(1,1) = Mass_Launch; %initializes Momentary rocket mass
Momentary_gravity_Force(1,1)= Mass_Launch*g;

Force_balance(1,1)= (Momentary_gravity_Force(1,1)) + Force_Thrust + Force_drag;

Momentary_Position_Z(1,1)=0;
Momentary_velocity(1,1) = 0;
Momentary_acceleration(1,1)=(Force_balance(1,1))/(Rocket_momentary_mass(1,1));
Momentary_Position_Z(2,1)=Momentary_Position_Z(1,1) + Momentary_velocity(1,1) +((1/2)*(Momentary_acceleration(1,1))^2);


for time=1:Burn_time
Rocket_momentary_mass((time+1),1)=Rocket_momentary_mass(time,1)-M_dot_burn;
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g); %(
Force_balance((time+1),1)= (Momentary_gravity_Force(time,1)) + Force_Thrust + Force_drag;
Momentary_acceleration((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_velocity((time+1),1)= Momentary_velocity(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_velocity((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));
end
%%





total_time=length(Momentary_velocity);
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
plot((time_graph_start:1:total_time),Momentary_velocity)
xlabel time(s)
ylabel velocity-m/s 

subplot(2,3,6)
plot((1:1:total_time+1),Momentary_Position_Z)
xlabel time(s)
ylabel Z-axis-displacement(m)
%%
while Momentary_Position_Z(time,1)>0
Rocket_momentary_mass(time+1,1)=(Mass_Final);
Momentary_gravity_Force((time+1),1)=(Rocket_momentary_mass(time,1))*(g); 
Force_balance((time+1),1)= (Momentary_gravity_Force(time,1))+ Force_drag;
Momentary_acceleration((time+1),1) = (Force_balance(time+1,1))/(Rocket_momentary_mass(time+1,1));
Momentary_velocity((time+1),1)= Momentary_velocity(time,1)+ Momentary_acceleration((time+1),1);
Momentary_Position_Z((time+2),1) = Momentary_Position_Z((time+1),1) + Momentary_velocity((time+1),1) +((1/2)*(Momentary_acceleration((time),1)^2));
time=time+1;


%Force_Drag_rocket=(1/2)*(Air_Density_launch)*((Momentary_velocity((time+1),1))^2)*(Cd_Rocket)*(Area_Rocket);



end








%%
total_time=length(Momentary_velocity);
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
plot((time_graph_start:1:total_time),Momentary_velocity)
xlabel time(s)
ylabel velocity-m/s 

subplot(2,3,6)
plot((1:1:total_time+1),Momentary_Position_Z)
xlabel time(s)
ylabel Z-axis-displacement(m)
