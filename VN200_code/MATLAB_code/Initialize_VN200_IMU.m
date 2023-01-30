function [s, SN] = Initialize_VN200_IMU( Fs )
% Function Description:
%   Initializes the VN200 IMU and configures the serial port to run from
%   the VN200's internal clock (async mode) at a freq of Fs Hz.
%
% INPUTS:
%   Fs = VN200 sample rate (Hz)  Must be <= 100
%   
% OUTPUTS:
%   s = Serial port object
%   SN = Device serial number
%
% NOTES:
%   The default BaudRate of the VN200 is 115200.
%
% Reference: VN-200 User Manual
%   https://www.vectornav.com/support/documentation
%
% Author: S. Bruder

if Fs > 100     % Limit the sample rate to <= 100 Hz
   error('The sample freq must be <= 100 Hz!!'); 
end

% Define a few VN200 commands
VN200_cmds.Diasble_Async = 'VNWRG,06,0';        % Disable asynchronous data output
VN200_cmds.Get_SN        = 'VNRRG,03';          % Request the IMU's serial number
VN200_cmds.Set_Fs        = ['VNWRG,07,',num2str(Fs)]; % Set the asynchronous data output freq to Fs Hz
VN200_cmds.Enable_IMU    = 'VNWRG,06,19';       % Enable async IMU Measurements on VN200
VN200_cmds.Write_Settings= 'VNWNV';             % Write current settings to FLASH 

% Configure serial port
BaudRate = 115200;                              % BaudRate: 115200, 128000, 230400, 460800, or 921600
ComPorts = serialportlist("available");         % Determine available serial ports

s = serialport(ComPorts(end), BaudRate);        % Create a serial port object
configureTerminator(s,"CR/LF");                 % Set both the read and write terminators to "CR/LF"

%% Configure the VN200 to output IMU data at Fs Hz
Send_VN200_cmd(s, VN200_cmds.Diasble_Async);    % Disable asynchronous data output
pause(0.1);                                     % A "small" delay
[ret, N] = Send_VN200_cmd(s, VN200_cmds.Diasble_Async);    % Disable asynchronous data output
pause(0.1);                                     % A "small" delay
if ~strcmp(ret(2:N+1), VN200_cmds.Diasble_Async)
   error('Failed to obtain Disable Async data output. Please try again.'); 
end

%% Request the IMU's serial number 
[ret, N] = Send_VN200_cmd(s, VN200_cmds.Get_SN);    
if ~strcmp(ret(2:N+1), VN200_cmds.Get_SN)
   error('Failed to obtain valid SN. Please try again.'); 
end
SN = ret(11:end-3);                                 % Extract the Serial Number

%% Set the asynchronous data output freq to Fs Hz
[ret, N] = Send_VN200_cmd(s, VN200_cmds.Set_Fs);
if ~strcmp(ret(2:N+1), VN200_cmds.Set_Fs)
   error('Failed to set the sample Freq to Fs. Please try again.'); 
end

%% Enable async IMU Measurements on VN200
[ret, N] = Send_VN200_cmd(s, VN200_cmds.Enable_IMU);
if ~strcmp(ret(2:N+1), VN200_cmds.Enable_IMU)
   error('Failed to enable async IMU Measurements. Please try again.'); 
end

%% Write current settings to FLASH - Do not need to do this every time
% This command takes ~500 ms to complete
% [ret, N] = Send_VN200_cmd(s, VN200_cmds.Write_Settings);
% while ~strcmp(ret(2:N+1), VN200_cmds.Write_Settings)
%    disp('Failed to Write current settings to FLASH. Trying again.'); 
%    pause(0.1)
%    [ret, N] = Send_VN200_cmd(s, VN200_cmds.Write_Settings);
%    pause(0.1)
% end

end     % End of function "Initialize_VN200_IMU"

function [ret, N] = Send_VN200_cmd(s, cmd)
% Description:
%   A function to issue commands to the VN200
%
% Inputs:
%   s       The serial port object
%   cmd     The command as a char array
%
%  Output:
%   ret     The confirmed response returned from the VN200
%
% Reference: VN-200 User Manual
%   https://www.vectornav.com/support/documentation
%
% Author: S. Bruder

N = length(cmd);                        % Length of the cmd string

%   Compute the 8-bit checksum (i.e., XOR) of the command bytes
checksum = uint8(cmd(1));               % Convert to type unsigned 8-bit integer
for i = 2:length(cmd)
    checksum = bitxor(checksum, uint8(cmd(i)), 'uint8');
end
checksum = dec2hex(checksum, 2);        % Convert to type ASCII - Must have 2-bytes

flush(s);                               % Flush beffers in the serial port
writeline(s, ['$',cmd,'*',checksum]);   % Issue the cmd with checksum
ret = char(readline(s));                % Read "echo" of command
    
end     % End function "send_VN200_cmd"