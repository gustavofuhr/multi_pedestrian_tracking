% 
% Converts the supported measurement units
% 
% USAGE
%  out_value = convert_unit(in_unit, out_unit, in_value)
%
% INPUTS
%   in_unit  - in unit ('m', 'cm' or 'mm')
%   out_unit - out unit ('m', 'cm' or 'mm')
%   in_value - original value
% 
function out_value = convert_unit(in_unit, out_unit, in_value)

if strcmp(in_unit, 'm')
    if strcmp(out_unit, 'm')
        out_value = in_value; 
    elseif strcmp(out_unit, 'cm')
        out_value = in_value*100; 
	elseif strcmp(out_unit, 'mm')
        out_value = in_value*1000; 
    end
    
elseif strcmp(in_unit, 'cm')
    if strcmp(out_unit, 'm')
        out_value = in_value/100; 
    elseif strcmp(out_unit, 'cm')
        out_value = in_value; 
	elseif strcmp(out_unit, 'mm')
        out_value = in_value*10; 
    end
    
elseif strcmp(in_unit, 'mm')
    if strcmp(out_unit, 'm')
        out_value = in_value/1000; 
    elseif strcmp(out_unit, 'cm')
        out_value = in_value/10; 
	elseif strcmp(out_unit, 'mm')
        out_value = in_value; 
    end
    
end

