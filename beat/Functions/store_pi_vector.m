%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% store_pi_vector.m
%
% Store a vector into yaml file according to Eurobench pi format
%
% Anthony Remazeilles
% Copyright Tecnalia 2021
% Beerware license.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function is_ok = store_pi_vector(filename, precision, unit, labels, data)

  file_id = fopen(filename, "w");
  fprintf(file_id, "type: 'vector'\n");
  fprintf(file_id, "measure_unit: '%s'\n", unit);


  if ~isempty(labels)
    label_str = "label: [";
    nb_label = size(labels, 2);

    for i= 1:nb_label
      if i == nb_label
        label_str = sprintf("%s'%s']\n", label_str, char(labels(i)));
      else
        label_str = sprintf("%s'%s', ", label_str, char(labels(i)));
      endif
    endfor
    fprintf(file_id, label_str);
  endif

  nb_item = size(data, 2);

  str = sprintf("value: [");
  for i = 1:nb_item
    if i == nb_item
      str = sprintf("%s%.*f]", str, precision, data(i));
    else
      str = sprintf("%s%.*f, ", str, precision, data(i));
    endif
  endfor
  str = sprintf("%s\n", str);
  fprintf(file_id, str);

  fclose(file_id);
  is_ok = true;
end