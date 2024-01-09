function crosses = GenerateDisplayDots(distanceDispEye, rows, columns, distRows, distColumns, crossSize)
if (~exist('crossSize','var')) 
    crossSize = 30;
end

n = rows*columns;
dots = zeros(n, 3);
c = 0; 
for i = 1:distRows:rows * distRows
    for j = 1:distColumns:columns * distColumns
        c = c + 1;
        dots(c,:) = [distanceDispEye,i,j]; 
    end
end
% make the center dot to be 0,0 on y,z plane
dots(:,2) = dots(:,2) - dots(round(n/2),2);
dots(:,3) = dots(:,3) - dots(round(n/2),3);

% draw a cross around each dot to demo the torsion in the camera view

for i = 1:size(dots,1)
    c = 1;
    cross(c,:) = dots(i,:);
    for h = 1:crossSize
        c = c + 1;
        cross(c,:) = [dots(i,1) dots(i,2) dots(i,3)+h/10];
        
        c = c + 1;
        cross(c,:) = [dots(i,1) dots(i,2) dots(i,3)-h/10 ];
    end

    for h = 1:crossSize
        c = c + 1;
        cross(c,:) = [dots(i,1) dots(i,2)+h/10 dots(i,3)];
        
        c = c + 1;
        cross(c,:) = [dots(i,1) dots(i,2)-h/10 dots(i,3)];
    end
    crosses{i} = cross;
end

end
