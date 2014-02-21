% verigy if the point is inside the boundaries
function is_inside = in_boundaries(h, w, p)

if p(1) <= h && p(1) >= 1 ...
        && p(2) <= w && p(2) >= 1 
    is_inside = true;
else
    is_inside = false;
end
    