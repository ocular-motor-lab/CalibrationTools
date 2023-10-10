function out = Cam2Display_simulation_OpenIrisWay(inputPosition, eyeModelCenter, eyeModelRadius )
% input position and eye model center are two dim array [x,y] showing the
% position on the image
diffC = inputPosition - eyeModelCenter;

rr = sqrt(sum(diffC.^2)) /eyeModelRadius;

angle = atan2(diffC(2),diffC(1));
ecc = asin( rr );

q1 = Math.Cos(ecc / 2);
q2 = -Math.Sin(angle) * Math.Sin(ecc / 2);
q3 = Math.Cos(angle) * Math.Sin(ecc / 2);
q4 = 0;

t2 = q1 * q2;
t3 = q1 * q3;
t4 = q1 * q4;
t5 = -q2 * q2;
t6 = q3 * q3;
t7 = q2 * q4;
t8 = -q3 * q3;
t9 = q3 * q4;
t10 = -q4 * q4;



z = Math.Sqrt(1 - rr * rr) * eyeModelRadius;
x = 2.0 * ((t8 + t10) * x + (t6 - t4) * y + (t3 + t7) * z) + x;
y = 2.0 * ((t4 + t6) * x + (t5 + t10) * y + (t9 - t2) * z) + y;




end