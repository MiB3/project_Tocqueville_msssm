function e = E_invest(k, n, alpha, gamma)
%This function computes the expected payoff if a agent invests.
%e = expected payoff
%n = number of all investors
%k = number positions
%alpha = winners payoff
%gamma = losers payoff

if (k < n)
    e = k/n * alpha + (n-k)/n * gamma;
else 
    e = alpha;
end

end