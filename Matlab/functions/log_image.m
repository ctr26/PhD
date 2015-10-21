function  out = log_image(in, decades)
%
%  out = log_image(in, decades)
%

out = 1+log10(in)/decades;
out = out.*(out>0.0);