function [invest, win, lose] = plot_win_lose(N, alpha, beta, gamma)
%This function produces a plot which shows the different investment
%strategies for different k's using the static baseline model.

%N = size of the population
%alpha = winners payoff
%beta = non-investors payoff
%gamma = losers payoff

x = 0:N;

invest = zeros(1,N+1);
win = zeros(1,N+1);
lose = zeros(1,N+1);

for i = x
    frac = E_investOverall(i, N, alpha, beta, gamma);
    invest(i+1)= frac;
    win(i+1) = min(i/N, frac);
    lose(i+1) = invest(i+1) - win(i+1);
end 

invest = invest.*100;
win = win.*100;
lose = lose.*100;

plot(x,invest,'b-*');
set(gca,'XTick',0:1:N);
title('Proportions of investors, losers and winners');
xlabel('positions');
ylabel('percent of population');
hold on;
plot(x, win,'g-*');
plot(x, lose,'r-*');
legend('investors','winners','losers');
hold off;
end