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
dx = 0.001; %1 mm, distance between bins (4 grain widths wide)
x = (dx/2):dx:xmax-(dx/2); %so that the x value is in the middle of each 'bin'

% set up time array
P = 10000; %input for max time, days
tmax = 3600*24*P; %max time, days
dt = 3600; %seconds
t = 0:dt:tmax;

%define ground profile
N = 10000*ones(size(x)); %each bin N is filled with 10000 grains
zg = pi*N*(dgrain^2)/(4*(1-eta)*dx); %initial ground profile is flat surface

imax = length(t);
tplot = 3600*24*100;

for i = 1:imax
    
    %incoming grain trajectory
    h_traj = 0 + 3*rand; %initial height of grain from 0-3 m
    ang_traj = 10; %angle of trajectory 10 degrees
    x_impact = h_traj/(tand(ang_traj)); %distance at which grain hits the ground
    
    %wrap around grain impact
    if x_impact>10
        x_impact = x_impact-10;
    end
    
    %movement of grain from impact
    ngrain = floor(3 + 4*rand); %number of grains moved on impact from 3-7
    %dx_moved = dx*2 + dx*4*rand; %m distance grains move from 2 to 6 bin widths
    dx_moved = dx*250; %m distance grains move from 2 to 6 bin widths
    x_moved = x_impact + dx_moved; %distance where grains are moved to
    
    %wrap around gran movement
    if x_moved>10
        x_moved = x_moved-10;
    end
  
    %round to numbers that exist in the x array
    x_moved = round(x_moved*1000)/1000+0.0005; 
    x_impact = round(x_impact*1000)/1000+0.0005;
    
    %find indexes for input into ground topography
    tr = find(x==x_impact,1); 
    m = find(x==x_moved,1);

    %update number of grains in each bin
    N(tr) = N(tr) - ngrain; %take grains out of impact bin
    N(m) = N(m) + ngrain; %add grains to moved bin
    
    %update ground topography
    zg = pi*N*(dgrain^2)/(4*(1-eta)*dx); %initial ground profile is flat surface
    
    if(rem(t(i),tplot)==0)
        figure(1)
        plot(x,zg)
        axis([0 10 0.7 0.8])
        xlabel('Distance (m)','fontname','arial','fontsize', 21)
        ylabel('Height (m)', 'fontname', 'arial', 'fontsize', 21)
        set(gca, 'fontsize', 18, 'fontname', 'arial') 
        time=num2str(t(i)/(3600*24)); %convert time of each plot to 'letters'
        timetext=strcat(time,' days'); %add seconds to the time
        text(7,0.78,timetext,'fontsize',14) %shows time on each plot
        pause(0.1)
    end
    
end









