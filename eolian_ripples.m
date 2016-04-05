% model to generate eolian sand ripples
% written by AGT 3/31/2016

clear all
figure(1)
clf

%% initialize

%define grain size
dgrain = 0.01; %test size for now
%dgrain = .25/1000; %.25 mm diameter for grains

% create distance array
xmax = 10; %m, max distance
dx = 0.001; %1 mm, distance between bins
x = (dx/2):dx:xmax-(dx/2); %so that the x value is in the middle of each 'bin'
N = length(x); %number of 'bins'

% set up time array
P = 100; %input for max time, days
tmax = 3600*24*P; %max time, days
dt = 3600; %seconds
t = 0:dt:tmax;

%define ground profile
zg = zeros(size(x)); %initial ground profile is flat surface

imax = length(t);
tplot = 3600*24;

for i = 1:imax
    
    %incoming grain trajectory
    h_traj = 0.5 + 1*rand; %initial height of grain from 0.5-1.5 m
    ang_traj = 7 + 6*rand; %angle of trajectory from 7-13 degrees
    x_impact = h_traj/(tand(ang_traj)); %distance at which grain hits the ground
    
    %movement of grain from impact
    ngrain = floor(3 + 4*rand); %number of grains moved on impact from 3-7
    dx_moved = 1 + 3*rand; %m distance grains move from 1 to 4
    x_moved = x_impact + dx_moved; %distance where grains are moved to
  
    %round to numbers that exist in the x array
    x_moved = round(x_moved*1000)/1000+0.0005; 
    x_impact = round(x_impact*1000)/1000+0.0005;
    
    %find indexes for input into ground topography
    tr = find(x==x_impact,1); 
    m = find(x==x_moved,1);

    %update ground topography
    zg(tr) = zg(tr) - dgrain*ngrain; %ground where the grain hits lowers
    zg(m) = zg(m) + dgrain*ngrain; %ground where the grains are moved increases
    
    if(rem(t(i),tplot)==0)
        figure(1)
        plot(x,zg)
        axis([0 10 -0.5 0.5])
        xlabel('Distance (m)','fontname','arial','fontsize', 21)
        ylabel('Height (m)', 'fontname', 'arial', 'fontsize', 21)
        set(gca, 'fontsize', 18, 'fontname', 'arial') 
        time=num2str(t(i)/(3600*24)); %convert time of each plot to 'letters'
        timetext=strcat(time,' days'); %add seconds to the time
        text(7,0.3,timetext,'fontsize',14) %shows time on each plot
        pause(0.1)
    end
    
end









