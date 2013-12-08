%This is a script, which produces multiple society simulation and compares them.

clear; close all; clc;

%The values below can be changed to your needs.
alpha = 9/6.5-1;
beta = 0;
gamma = 5/6.5-1;
it = 40;
popu_start = zeros(7,7);
N = size(popu_start,1) * size(popu_start,2);

c_values = [-0.2, 0, 0.2];
k_values = [5, 20, 35];


%Do not modify anythin below this line.
numberOfPlots = size(c_values,2) * size(k_values, 2);

tile = 1;

popu = zeros(numberOfPlots, size(popu_start,1), size(popu_start,2));
me = zeros(numberOfPlots,1,it+1);
va = zeros(numberOfPlots,1,it+1);
gi = zeros(numberOfPlots,1,it+1);
ha = zeros(numberOfPlots,1,it+1);

fig1 = figure;%for me, gi and ha
fig2 = figure;%for the population after the last iteration

path = sprintf('Testcases/%s/',date);
[~, ~, ~] = rmdir(path);
mkdir(path);

for c = c_values
    for k = k_values
        [popu(tile,:,:), me(tile,:,:), gi(tile,:,:), ha(tile,:,:)] = plot_society_sim(k,N,alpha,beta,gamma,c,it,popu_start);
        
        movefile('society_sim.mp4',sprintf('%sk%dN%dc%1.2f.mp4',path, k, N, c));
        
        
        
        figure(fig1);
        subplot(size(c_values,2),size(k_values,2),tile);
        x = 0:it;
        plot(x,reshape(me(tile,1,:),1,it+1),'r-*');%./max(abs(me(tile,1,:))),'r-*');
        %set(gca,'XTick',0:it);
        set(gca,'YTick',-1:1);
        ylim([-1 1]);
        title(sprintf('k = %d c = %1.1f', k, c));
        xlabel('Timesteps');
        ylabel('Respective Values');
        hold on
        plot(x,reshape(ha(tile,1,:),1,it+1),'b-*');%./max(abs(ha(tile,1,:))),'b-*');
        plot(x,reshape(gi(tile,1,:),1,it+1),'k-*');
        %legend('Mean', 'Happiness','Gini-Coefficient');
        hold off
        
        figure(fig2);
        subplot(size(c_values,2),size(k_values,2),tile)
        subimage(reshape(popu(tile,:,:),size(popu,2), size(popu,3)), [-1 1]);
        title(sprintf('Me:%1.2f Gi:%1.2f Ha:%1.2f', me(tile,end,end), gi(tile,end,end), ha(tile,end,end)));
        ylabel('');
        xlabel(sprintf('k: %d c: %1.2f', k, c));
        
        
        tile = tile + 1;
    end
end

saveas(fig1,sprintf('%svalues.jpg',path));
saveas(fig2,sprintf('%spopus.jpg',path));
close all;
