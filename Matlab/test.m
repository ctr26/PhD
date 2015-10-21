%%[solx,soly] = solve(x^2*y^2 == 1, x-y/2 == alpha)
% 

 l4 = 4;
 l3 = 700;
 l5 = 330;
 beam_width = 0.7;
 slm_chip = 10;
 scan_width = 1.1;
 
syms f_slm f_scan f_laser f_chip

solv = solve([f_slm > 200, f_slm + 2*f_scan == l5 + l4 + l3, f_chip/f_laser == 0.7/10, f_scan/f_laser == 0.7 /1.1],[f_slm,f_laser f_chip f_scan l1 l2 l3 l4 l5])