function hg = plot_frame(C, org, label, colorx, colory, colorz)

% Description:
%   Function that plots an orthonormal x/y/z coordinate frame
%
% Inputs:
%   C:      A 3X3 rotation matrix (i.e., DCM)
%   org:    The [x,y,z] location of the origin of the coordinate frame 
%   label:  Axis label string (becomes a sub to axis names)
%   colorx,y,z: Choice of colors for the x, y, and z axes
%
% Outputs:
%   hg:     Handle to the cordinate frame graphic object
%
% Example: 
%   plot_frame(eye(3), [0,0,0], '\alpha', 'r', 'g', 'b');

% If no colors provided use the default: x -> red, y -> green, & z -> blue
if isempty(colorx)
    colorx = 'r'; colory = 'g'; colorz = 'b';
end

% If no label is provided set to a blank char
if isempty(label)
    label = ' ';
end

labloc = 1.1;       % Scale factor to locate the axis labels

x_axis = C(:,1);    % Extract the x-axis from the DCM
y_axis = C(:,2);    % Extract the y-axis from the DCM
z_axis = C(:,3);    % Extract the z-axis from the DCM

%   Now plot and label the three axes
hg = hggroup;           % Create a group object and a handle to that parent

% Plot a line and label for the x-axis
quiver3(org(1),org(2),org(3),x_axis(1), x_axis(2), x_axis(3), 'Color', colorx, 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
text(labloc*x_axis(1)+org(1), labloc*x_axis(2)+org(2), labloc*x_axis(3)+org(3), ['$\vec {x}_{', label, '}$'], ...
      'Color', colorx, 'Interpreter', 'latex', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

% Plot a line and label for the y-axis
quiver3(org(1),org(2),org(3),y_axis(1), y_axis(2), y_axis(3), 'Color', colory, 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
text(labloc*y_axis(1)+org(1), labloc*y_axis(2)+org(2), labloc*y_axis(3)+org(3), ['$\vec {y}_{', label, '}$'], ...
     'Color', colory, 'Interpreter', 'latex', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

% Plot a line and label for the z-axis
quiver3(org(1),org(2),org(3),z_axis(1), z_axis(2), z_axis(3), 'Color', colorz, 'autoscale', 'off', 'LineWidth', 2, 'AlignVertexCenters', 'on', 'Parent', hg);
text(labloc*z_axis(1)+org(1), labloc*z_axis(2)+org(2), labloc*z_axis(3)+org(3), ['$\vec {z}_{', label, '}$'] , ...
    'Color', colorz, 'Interpreter', 'latex',  'HorizontalAlignment', 'center', 'FontSize', 14, 'Parent',hg);

% Label the origin {?} if a label is provided
% if label ~= ' '
%     text(-0.2*z_axis(1)+org(1), -0.2*z_axis(2)+org(2), -0.2*z_axis(3)+org(3), ['\{', label, '\}'] , 'Color', 'k', 'Parent',hg);
% end

end % Close the Function