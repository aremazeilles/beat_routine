
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% store_pi_matrix.m
%
% Store a matrix into a yaml file, following Eurobench format
%
% Anthony Remazeilles
% Copyright Tecnalia 2021
% Beerware license.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function is_ok = store_pi_labelled_matrix(filename, precision, unit, row_label, col_label, data)

file_id=fopen(filename,'w');
fprintf(file_id, "type: 'matrix'\n");
fprintf(file_id, "measure_unit: '%s'\n", unit);

if ~isempty(row_label)
  label_str = "row_label: [";
  nb_label = size(row_label, 2);

  for i= 1:nb_label
    if i == nb_label
      label_str = sprintf("%s'%s']\n", label_str, char(row_label(i)));
    else
      label_str = sprintf("%s'%s', ", label_str, char(row_label(i)));
    endif
  endfor
  fprintf(file_id, label_str);
endif

if ~isempty(col_label)

  label_str = "col_label: [";
  nb_label = size(col_label, 2);

  for i= 1:nb_label
    if i == nb_label
      label_str = sprintf("%s'%s']\n", label_str, char(col_label(i)));
    else
      label_str = sprintf("%s'%s', ", label_str, char(col_label(i)));
    endif
  endfor
  fprintf(file_id, label_str);
endif

nb_i = size(data, 1);
nb_j = size(data, 2);

str = "value: [[";

for i = 1:nb_i
  for j = 1:nb_j
    if j == nb_j
      str = sprintf("%s%.*f]", str, precision, data(i, j));
    else
      str = sprintf("%s%.*f, ", str, precision, data(i, j));
    endif
  endfor
  if i == nb_i
    str = sprintf("%s]\n", str);
  else
    str = sprintf("%s,\n        [", str);
  endif
endfor
fprintf(file_id,str);
fclose(file_id);