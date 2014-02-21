%
% This is a simple function that extracts the absolute path of 
% files given their relative paths.
%
function [filename] = get_fullpath(filename)

if filename(1) == '.' || (filename(1) ~= '/' && filename(1) ~= '~')
    if filename(1) == '.'
        filename = [pwd, '/', filename(3:end)];
    else
        filename = [pwd, '/', filename(1:end)];
    end
elseif filename(1) == '~'
    
    if ispc, userdir= getenv('USERPROFILE'); 
    else userdir= getenv('HOME');  end
   
    filename = [userdir, '/' filename(3:end)];
end

