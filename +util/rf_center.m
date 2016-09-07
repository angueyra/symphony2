function [cx,cy] = rf_center(x,y,z)
	% function [cx,cy] = rf_center(x,y,z)
	% Calculates center of receptive field as a mass centre (weigthed mean of measurements with coordinates x,y and magnitude z)
	Surface=[x,y,z];
    [rc,cc] = ndgrid(x,y);
    cx = sum(Surface(:) .* rc(:)) / sum(Surface(:));
    cy = sum(Surface(:) .* cc(:)) / sum(Surface(:));
end