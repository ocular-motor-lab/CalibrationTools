function [dots, crosses] = GenerateDisplayDots(rows, columns, distRows, distColumns, crossSize)
if (~exist('crossSize','var')) 
    crossSize = 30;
end

n = rows*columns;
dots = zeros(n, 2);
c = 0; 
for i = 1:distRows:rows * distRows
    for j = 1:distColumns:columns * distColumns
        c = c + 1;
        dots(c,:) = [i,j]; 
    end
end
% make the center dot to be 0,0
dots = dots - dots(round(n/2),:);

% draw a cross around each dot to demo the torsion in the camera view
c = 0;
for i = 1:size(dots,1)
    c = c + 1;
    crosses(c,:) = dots(i,:);
    for h = 1:crossSize
        c = c + 1;
        crosses(c,:) = [dots(i,1) dots(i,2)+h/10];
        
        c = c + 1;
        crosses(c,:) = [dots(i,1) dots(i,2)-h/10];
        
        
        
    end

    for h = 1:crossSize
        c = c + 1;
        crosses(c,:) = [dots(i,1)+h/10 dots(i,2)];
        
        c = c + 1;
        crosses(c,:) = [dots(i,1)-h/10 dots(i,2)];
    end


end

end
