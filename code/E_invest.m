function e = E_invest(k,n, alpha, gamma)
%n = number of all investors
%k = positions

if (k < n)
    e = k/n * alpha + (n-k)/n * gamma;
else 
    e = alpha;
end

end