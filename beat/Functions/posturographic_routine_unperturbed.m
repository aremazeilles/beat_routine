function [PL PL_AP PL_ML EA]=posturographic_routine_unperturbed(PlatformData, outFolder)
% posturographic_routine_unperturbed is a function that gives the posturographic parameters related to stepping protocol with uneven surface and static balance protocols.
%Required Octave pkg: signal, statistics, linear-algebra, geometry
%[PL PL_AP PL_ML EA]=posturographic_routine_unperturbed(PlatformData,outFolder)
% INPUT:
%       - PlatformData is a file containing the data extracted by the platform.
%	- outFolder: folder path where result should be stored
% OUTPUT:
%       - PL is the path lenght of the COP during the task. Result is a scalar (unit: m)
%       - PL_AP is the path lenght of the COP during the task in the anterior-posterior direction. Result is a scalar (unit: m)
%       - PL_ML is the path lenght of the COP during the task in the medio-lateral direction. Result is a scalar (unit: m)
%       - EA is the area of confidence ellipse of the COP during the task in the medio-lateral direction. Result is a scalar(unit: m^2)
% $Author: J. TABORRI, v1 - 04/Apr/2020$ (BEAT project)

platformdata=csv2cell(PlatformData, ";");
platformdata_header=platformdata(1,:);
cx=find(strcmpi(platformdata_header, 'cop_x'), 1); %% cop x component column
cy=find(strcmpi(platformdata_header, 'cop_y'), 1); %% cop y component column
cop=fillgaps(cell2mat(platformdata(2:end,cx:cy))); %converted in m
z=chi2inv(0.95,2); %%compute the probability associated with 0.95 confidence level (chi distribution)

p=find(strcmpi(platformdata_header, 'protocol'), 1); %%protocol number column
er=find(strcmpi(platformdata_header, 'right_stride'), 1); %%right stride column
%%understand which is the protocol
if (platformdata{2,p}==2) %%2 represents the stepping protocol with uneven surface
  event_1=cell2mat(platformdata(2:end,er));
  event=find(event_1==1);
  aa=2;
elseif (platformdata{2,p}==3 || platformdata{p,p}==4) %%3 and 4 represent protocols of static balance
  aa=1;
else
  fprintf('You have tried to lunch posturographic_routine_unperturbed with a wrong protocol\n')
  fprintf('Provided protocol %d: only accepts protocols 2, 3 and 4\n', platformdata{1,2})
  return;
endif

if aa==1;
  PL_AP=(sqrt(sum(diff(cop(:,1)).^2))); %%path lenght in AP direction
  PL_ML=(sqrt(sum(diff(cop(:,2)).^2))); %%path lenght in ML direction
  PL=sum(sqrt((diff(cop(:,1)).^2) + (diff(cop(:,2)).^2))); %%path lenght resultant
  %%compute ellipse
  o=mean(cop,1); %%center of the confidence ellipse
  nF=size(cop,1);
  x=cop(:,1)-repmat(o(:,1),nF,1);
  y=cop(:,2)-repmat(o(:,2),nF,1);
  Cxx=(x'*x)/(size(x,1)-1);
  Cyy=(y'*y)/(size(x,1)-1);
  Cxy=(x'*y)/(size(x,1)-1);
  C=[Cxx Cxy;Cxy Cyy];
  [V D W]=svd(C);
  e0=V(:,1);
  e1=V(:,2);
  a=sqrt(z)*D(1,1);
  b=sqrt(z)*D(2,2);
  EA=a*b*pi;  %%ellipse area
elseif (aa==2)
  for e=1:length(event)-1
   COP=cop(event(e):event(e+1),:); %%divide COP into the events (perturbations)
   PL_AP(e)=sum(sqrt(diff(COP(:,1)).^2)); %%path lenght in AP direction
   PL_ML(e)=sum(sqrt(diff(COP(:,2)).^2)); %%path lenght in ML direction
   PL(e)=sum(sqrt((diff(COP(:,1)).^2) + (diff(COP(:,2)).^2))); %%path lenght resultant
   %%compute ellipse
   o(:,:,e)=mean(COP(:,:),1); %%center of the confidence ellipse
   nF=size(COP,1);
   x=COP(:,1)-repmat(o(:,1),nF,1);
   y=COP(:,2)-repmat(o(:,2),nF,1);
   Cxx=(x'*x)/(size(x,1)-1);
   Cyy=(y'*y)/(size(x,1)-1);
   Cxy=(x'*y)/(size(x,1)-1);
   C=[Cxx Cxy;Cxy Cyy];
   [V D W]=svd(C);
   e0=V(:,1);
   e1=V(:,2);
   a=sqrt(z)*D(1,1);
   b=sqrt(z)*D(2,2);
   EA(e)=a*b*pi;  %%ellipse area
   clear COP
  end
  PL_AP=mean(PL_AP,2); %compute mean value across repetitions
  PL_ML=mean(PL_ML,2);
  PL=mean(PL,2);
  EA=mean(EA,2);
else
  fprintf('You have tried to lunch posturographic_routine with a wrong protocol');
  fprintf('Provided protocol %d: only accepts protocols 2,3 andd 4\n', platformdata{2,p});
  return;
endif

%% save files
filename = strcat(outFolder,"/pi_plap.yaml");
store_pi_scalar(filename, 3, 'm', PL_AP);

filename = strcat(outFolder,"/pi_plml.yaml");
store_pi_scalar(filename, 3, 'm', PL_ML);

filename = strcat(outFolder,"/pi_pl.yaml");
store_pi_scalar(filename, 3, 'm', PL);

filename = strcat(outFolder,"/pi_ea.yaml");
store_pi_scalar(filename, 6, 'm^2', EA);
