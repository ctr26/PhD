% This function calculates the free space transfer for diffraction

% by a distance d2. Distances are measured in terms of A.

function phi = h2(fx,fy,d2,lam)

dg=1/lam^2 - fx .^2 - fy .^ 2;

if dg>0

phip = exp(- 1i * 2 * pi * d2 .* sqrt(dg));

% for large values of d2, the large phase of this function tends to disrupt Fourier transforms.

% substituting phip = exp(- i * 2 * pi * (d2 .* sqrt(dg)-d2/lam)); seems to correct this problem.

else

phip=0;

end

phi=phip;