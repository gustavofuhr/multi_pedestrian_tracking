function m = angle2matrix(phi,theta,psi)

% phi, theta, psi en radian

% convention xyz
    % par colonne
% m(1,1) =  cos(theta)*cos(psi);
% m(2,1) =  cos(theta)*sin(psi);
% m(3,1) = -sin(theta);
% 
% m(1,2) = -cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi);
% m(2,2) =  cos(phi)*cos(psi) + sin(phi)*sin(theta)*sin(psi);
% m(3,2) =  sin(phi)*cos(theta);
% 
% m(1,3) =  sin(phi)*sin(psi) + cos(phi)*sin(theta)*cos(psi);
% m(2,3) = -sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi);
% m(3,3) =  cos(phi)*cos(theta);

Rx = [  1   0           0       ; ...
        0 cos(phi) -sin(phi)    ; ...
        0 sin(phi)  cos(phi)    ];

Ry = [  cos(theta)  0   sin(theta)  ; ...
            0       1       0       ; ...
       -sin(theta)  0   cos(theta)  ];

Rz = [  cos(psi) -sin(psi)  0   ; ...
        sin(psi)  cos(psi)  0   ; ...
            0       0       1   ];
        
m = Rz*Ry*Rx;
        