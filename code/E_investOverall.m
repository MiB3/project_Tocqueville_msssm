function p = E_investOverall(k, N, alpha, beta, gamma)
%This function computes the ideal investment strategy for an agent.
%p = probability with which a single agent should invest.
%k = positions
%N = population < 101 (solve function will otherwise produce nonsense)
%alpha = winners payoff
%beta = non-investors payoff
%gamma = losers payoff


%suppresses warning for not exact calculating the result. This does not
%have any relevant impact on our calculation.
warning('off','MATLAB:nchoosek:LargeCoefficient')


if (alpha <= beta) 
    p = 0;
    return
end

p = 0;

e = E_invest(k, N, alpha, gamma);

if (e >= beta)
    p = 1;
elseif (k ~= 0)
    syms pp positive;
    
    g = 0;
    for i=0:N-1
        g = g + nchoosek(N-1,i) * (pp^i) * (1-pp)^(N-1-i) * E_invest(k, i+1, alpha, gamma);
    end
    
    p = solve(g==beta,pp,'Real', true);
    p = double(p);
    p = (p <= 1)'*p;
end

if (size(p,1) ~= 1 || size(p,2) ~= 1) 
    error('N is probably too high. Use N smaller equals 100.')
end

warning('on','MATLAB:nchoosek:LargeCoefficient');

end

