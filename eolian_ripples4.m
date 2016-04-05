% model to generate eolian sand ripples
% written by AGT 3/31/2016

clear all
figure(1)
clf

%% initialize

%define grain size
dgrain = .25/1000; %.25 mm diameter for grains
eta = 0.35; %porosity

% create distance array
xmax = 10; %m, max distance
dx = 0.01; %1 mm, distance between bins (4 grain widths wide)
x = (dx/2):dx:xmax-(dx/2); %so that the x value is in the middle of each 'bin'

% set up time array
P = 100000; %input for max time, days
tmax = 3600*24*P; %max time, days
dt = 3600; %seconds
t = 0:dt:tmax;

%define ground profile
N = 10000*ones(size(x)); %each bin N is filled with 10000 grains
zg = pi*N*(dgrain^2)/(4*(1-eta)*dx); %initial ground profile is flat surface

imax = length(t);
tplot = 3600*24*1000;

for i = 1:imax
    
    %incoming grain trajectory
    ang_traj = 15; %angle of trajectory 10 degrees
    h_traj_min = zg(1); %minimum height of incoming grain
    h_traj_max = max(x*tand(ang_traj)+zg); %max height of incoming grain
    h_range = h_traj_max - h_traj_min; %range of heights
    h_traj = h_range*rand +zg(1); %height of incoming grain
    z_incoming = h_traj - x*tand(ang_traj); %height of the grain along its trajectory
    
    %find where the grain impacts
    potential_impacts = find(zg>z_incoming); %find all places where the grain and the ground intersect
    x_impact = potential_impacts(1); %first potential impact is where the grain lands
    
     %wrap around grain impact
     if x_impact>length(x)
         x_impact = x_impact-length(x);
     end
    
    %movement of grain from impact
    ngrain = 10; %number of grains moved on each impact
    dx_moved = 10; %number of bins the grain moves
    x_moved = x_impact + dx_moved; %distance in the array where grains are moved to
    
     %wrap around grain movement
     if x_moved>length(x)
         x_moved = x_moved-length(x);
     end

    %update number of grains in each bin
    N(x_impact) = N(x_impact) - ngrain; %take grains out of impact bin
    N(x_moved) = N(x_moved) + ngrain; %add grains to moved bin
    
    %update ground topography
    zg = pi*N*(dgrain^2)/(4*(1-eta)*dx); 
    
    if(rem(t(i),tplot)==0)
        figure(1)
        plot(x,zg)
        axis([0 10 -0.1 0.6])
        xlabel('Distance (m)','fontname','arial','fontsize', 21)
        ylabel('Height (m)', 'fontname', 'arial', 'fontsize', 21)
        set(gca, 'fontsize', 18, 'fontname', 'arial') 
        time=num2str(t(i)/(3600*24)); %convert time of each plot to 'letters'
        timetext=strcat(time,' days'); %add days to the time
        text(6,0.5,timetext,'fontsize',14) %shows time on each plot
        pause(0.1)
    end
    
end









