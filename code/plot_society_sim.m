function [popu, me, gi, ha, investers, winners, losers] = plot_society_sim(k, N, alpha, beta, gamma, c, it, popu)
%This function produces a simulation of a soociety given the different
%parameters.

%k: Numbers of (upgrade) positions.
%N: size of the population. If popu is provided we ignore N.
%alpha, beta, gamma between -1 and 1
%N should be quadratic
%c: + for rich - for poor (0 <= c <= 1)
%it: Number of iterations performed for this simulation
%popu: Society matrix. size(soc) == N. Values between -1 and 1.

show_output = 0;%removes all 'pause'

%Add the path for the gini coefficient calculation
addpath ginicoeff

%Ability to use less input variables. Default values.
if (nargin < 2)
    N = 25;
end
if (nargin < 8)
    m = round(sqrt(N));
    popu = zeros(m);%This is the population. at the beginning everyone is 0
end
if (nargin < 7)
    it = 10;
end
if (nargin < 6)
    c = 0;
end
if (nargin < 5)
    gamma = -0.5;
end
if (nargin < 4)
    beta = 0;
end
if (nargin < 3)
    alpha = 1;
end
if (nargin < 1)
    k = 3;
end

fps = 2;
h = figure;
N = size(popu,1)*size(popu,2);

%values which are calculated for every frame
me = zeros(1,it+1);
ha = zeros(1,it+1);
gi = zeros(1,it+1);
investers = zeros(1,it+1);
winners = zeros(1,it+1);
losers = zeros(1,it+1);

reshaped = reshape(popu,N,1);
me(1) = mean(reshaped);
ha(1) = 0;
gi(1) = ginicoeff(reshaped+1);
investers(1) = 0;
winners(1) = 0;
losers(1) = 0;

%First plot/frame iteration: 0
imshow(popu,[-1 1],'InitialMagnification','fit');
colorbar;% show a legend for the color of the pixels. 0 = poor, 1 = rich.
title(sprintf('Iteration: %d   Mean: %1.2f  Gini: %1.2f   Happiness: %1.2f',0, me(1), gi(1), ha(1)));
    

%add first frame to the movie.
movName = 'society_sim.mp4';
mov = VideoWriter(movName,'MPEG-4');
mov.FrameRate = fps;
M(1:it+1) = getframe(h);

if (show_output)
    pause(1/fps);
end
p = E_investOverall(k, N, alpha, beta, gamma);%stays the same over time.

for iter = 1:it
    pop = rand(size(popu));%Do you invest or not?
    
    %set investors
    for i = 1:size(pop,1)
        for j = 1:size(pop,2)
            pop(i,j) = pop(i,j) <= p * (1 + c*popu(i,j));
        end
    end
   
    %set k winners randomly
    [x,y] = find(pop);
    sizeX = size(x,1);
    rp = randperm(sizeX);
    en = min(k,sizeX);%problem if there are less investors than positions
    pop(sub2ind(size(pop), x(rp(1:en)), y(rp(1:en)))) = 2;
    
    %set the losers
    pop(pop == 1) = 3;
    
    %assign the payoffs
    popu(pop == 2) = popu(pop == 2) + alpha;
    popu(pop == 0) = popu(pop == 0) + beta;
    popu(pop == 3) = popu(pop == 3) + gamma;
    
    %reset max values
    popu(popu > 1) = 1;
    popu(popu < -1) = -1;
    
    %display population white is rich, black is poor
    imshow(popu, [-1 1],'InitialMagnification','fit');
    colorbar;% show a legend for the color of the pixels. 0 = poor, 1 = rich.
    reshaped = reshape(popu,N,1);
    me(iter+1) = mean(reshaped);
    winners(iter+1) = nnz(pop == 2);
    losers(iter+1) = nnz(pop == 3);
    investers(iter+1) = winners(iter+1) + losers(iter+1);
    ha(iter+1) = (winners(iter+1) - losers(iter+1))/N;
    gi(iter+1) = ginicoeff(reshaped+1);
    title(sprintf('Iteration: %d   Mean: %1.2f   Gini: %1.2f   Happiness: %1.2f',iter, me(iter+1), gi(iter+1), ha(iter+1)));
    
    %add a frame to the movie.
    M(iter+1) = getframe(h);
    if (show_output)
        pause(1/fps);
    end
end

%show graph for mean, gini and happiness
j = figure;
x = 0:it;
plot(x,me, 'r-*');%./max(abs(me)),'r-*');
set(gca,'XTick',0:iter);
xlim([0 it]);
ylim([-1 1]);
title('Society situation over time');
xlabel('Timesteps');
ylabel('Respective Values (Mean and happiness are scaled to [-1, 1])');
hold on
plot(x,ha, 'b-*');%/max(abs(ha)),'b-*');
plot(x,gi,'k-*');
legend('Mean','Happiness','Gini-Coefficient');
hold off

open(mov);
writeVideo(mov,M);
close(mov);

rmpath ginicoeff
end

