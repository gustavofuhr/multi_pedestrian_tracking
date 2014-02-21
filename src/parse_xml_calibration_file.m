% this function extracts the the projection matrix of an xml containing
% the parameters of calibration.
% WARNING: it does not take into account the distortion

function [K, Rt] = parse_xml_calibration_file(filename)

% this is a hack because the parseXML does not work
% with relative paths.
filename = get_fullpath(filename);


tree = parseXML(filename);

focal = 0;
sx    = 0;
cx    = 0; cy    = 0;
dpx   = 0; dpy   = 0;

t        = [0; 0; 0];
r_angles = [0; 0; 0];


for c = tree.Children
    %% geometry
    if strcmp(c.Name, 'Geometry')                
        for a = c.Attributes
            if strcmp(a.Name, 'dpx');
                dpx = str2num(a.Value);
            elseif strcmp(a.Name, 'dpy');
                dpy = str2num(a.Value);
            end
        end        
    %% intrinsic
    elseif strcmp(c.Name, 'Intrinsic')                
        % look the attributes to find the parameters
        for a = c.Attributes
            if strcmp(a.Name, 'focal');
                focal = str2num(a.Value);                
            elseif strcmp(a.Name, 'cx');
                cx = str2num(a.Value);
            elseif strcmp(a.Name, 'cy');
                cy = str2num(a.Value);
            elseif strcmp(a.Name, 'sx');
                sx = str2num(a.Value);
            end
        end
    %% extrinsic        
    elseif strcmp(c.Name, 'Extrinsic')
        for a = c.Attributes
            if strcmp(a.Name, 'tx')
                t(1) = str2num(a.Value);                
            elseif strcmp(a.Name, 'ty')
                t(2) = str2num(a.Value);                
            elseif strcmp(a.Name, 'tz')
                t(3) = str2num(a.Value);                
            elseif strcmp(a.Name, 'rx')
                r_angles(1) = str2num(a.Value);                
            elseif strcmp(a.Name, 'ry')
                r_angles(2) = str2num(a.Value);                
            elseif strcmp(a.Name, 'rz')
                r_angles(3) = str2num(a.Value);
            end
        end
    end
end
    

R = angle2matrix(r_angles(1), r_angles(2), r_angles(3));
Rt = [R t];

% for the intrinsic parameters we have some conversion to do
K = [(focal*sx)/dpx             0     cx; ...
                  0     focal/dpy     cy; ...
                  0             0      1];





