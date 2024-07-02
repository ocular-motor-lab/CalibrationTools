function trueGazeDirection = TrueGazeDirection(dotDegreeH,dotDegreeV, display2EyeDistance)
x = display2EyeDistance;
y = display2EyeDistance*tand(dotDegreeH);
z = display2EyeDistance*tand(dotDegreeV);

d = sqrt(x^2 + y^2 + z^2);%make it unit vector

trueGazeDirection = [x,-y,z]./d;

end
