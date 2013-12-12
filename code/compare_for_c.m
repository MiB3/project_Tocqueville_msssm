%This script creates a plot which compares the happiness of societies with
%different c values.

%We need to rund this to get the happiness which will be stored in 'ha'.
%create_all_plots();

%Could be changed to 'me' for mean or 'gi' for the Gini Coefficient.
compare_value = ha;
it = size(compare_value,3);


set(gca, 'FontSize', 16);
plot(1:it,squeeze(compare_value(2,1,1:it)), 'g-*');
title('Comparisen for different c. k = 20; N = 49;');
ylim([min(compare_value(2,1,1:it))-0.1 max(compare_value(2,1,1:it))+0.1]);
xti = 0:5:it;
set(gca,'XTick',xti);
xlim([1 it]);
xlabel('Timesteps');
if (compare_value == ha)
    ylabel('Respective hapiness values');
elseif (compare_value == me)
    ylabel('Respective mean wealth values');
elseif (compare_value == gi)
    ylabel('Respective gini coefficient values');
end
hold on;
plot(1:it,squeeze(compare_value(5,1,1:it)), 'c-*');
plot(1:it,squeeze(compare_value(8,1,1:it)), 'm-*');
legend('c = -0.2','c = 0','c = 0.2');
hold off;
