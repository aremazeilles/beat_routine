function [OS, theta_f, delta_theta] =step_perturbation(PlatformData,outFolder)
% step_perturbation is a function that gives information on how subject reacts under step perturbation with uneven surface. It can be used only with Protocol6
%[OS, theta_f, delta_theta] =step_perturbation(PlatformData,outFolder)
% INPUT:
%       - PlatformData is a file containing the data extracted from the platform.
%	- outFolder: folder path where results should be stored
% OUTPUT:
%       - OS is the overshoot of the platform angle for each direction. It is a labelled matrix 2xN where N is the number directions (8). First row: direction label, second row: index values.
%       - theta_f is the final angular position of the platform for each direction. It is a labelled matrix 2xN where N is the number directions (8). First row: direction label, second row: index values.
%       - delta_theta is the range of the excursion of the angle platform during the last 1.5 s of the task for each direction. It is a labelled matrix 2xN where N is the number directions (8). First row: direction label, second row: index values.

% $Author: J. TABORRI, v1 - 03/Apr/2020$ (BEAT project)


platformdata=csv2cell(PlatformData, ";");
platformdata_header=platformdata(1,:);
time_vector_platform=cell2mat(platformdata(2:end,1)); %%extract time vector from platformdata

ax=find(strcmpi(platformdata_header, 'alfa'), 1); %% angle in x direction (alfa) column
ay=find(strcmpi(platformdata_header, 'beta'), 1); %% angle in y direction (beta) column
per_value=find(strcmpi(platformdata_header, 'pert_value'), 1); %% imposed perturbation column

platform_angle=fillgaps(cell2mat(platformdata(2:end,[ax,ay])));
imposed_angle=fillgaps(cell2mat(platformdata(2:end,per_value)));
delta_t_platform=diff(time_vector_platform,1);
fs_platform=round(1.0/mean(delta_t_platform));
t=round(1.5*fs_platform); %variable need to cut the last 1.5 s of the angle for computation of delta_theta

p=find(strcmpi(platformdata_header, 'protocol_number'), 1); %%protocol number column
per_dir=find(strcmpi(platformdata_header, 'pert_direction'), 1); %% perturbation direction column

if platformdata{2,p} ==6 %%6 represents the step perturbation protocol with uneven surface
  dir_1=cell2mat(platformdata(2:end,per_dir));
  dir=find(diff(dir_1)==1);
else
  fprintf('You have tried to lunch step_perturbation with a wrong protocol\n')
  fprintf('Provided protocol %d: only accepts protocol 6\n', platformdata{2,p})
  return;
endif

for d=1:length(dir)-1
  angle_platform=acos(cos(platform_angle(dir(d):dir(d+1),1)).*cos(platform_angle(dir(d):dir(d+1),2)))*57.3;
  OS(d)= max(angle_platform)-max(imposed_angle(dir(d):dir(d+1),1)); %%compute overshoot for each direction with respect the imposed perturbation
  theta_f(d)=mean(angle_platform(length(angle_platform)-50:end));
  delta_theta(d)=abs(max(angle_platform(length(angle_platform)-t:end))-min(angle_platform(length(angle_platform)-t:end)));
endfor
direction={'N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'}; %%direction label

%save file
filename = strcat(outFolder,"/pi_os.yaml");
store_pi_vector(filename, 3, '°', direction, OS);

filename = strcat(outFolder,"/pi_thetaf.yaml");
store_pi_vector(filename, 3, '°', direction, theta_f);

filename = strcat(outFolder,"/pi_deltatheta.yaml");
store_pi_vector(filename, 3, '°', direction, delta_theta);
