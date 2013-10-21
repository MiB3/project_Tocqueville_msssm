function p = E_investOverall(k, N, alpha, beta, gamma)

%k = positions
%N = population
%alpha = winners payoff
%beta = non-investors payoff
%gamma = losers payoff

syms pp positive;

g = 0;
for i=0:N-1
  g = g + nchoosek(N-1,i) * (pp^i) * (1-pp)^(N-1-i) * E_invest(k, i+1, alpha, gamma);
end

p = solve(g==beta,pp,'Real', true);

end

