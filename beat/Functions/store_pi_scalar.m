%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% store_pi_scalar.m
%
% Store a scalar into yaml file
%
% Anthony Remazeilles
% Copyright Tecnalia 2021
% Beerware license.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function is_ok = store_pi_scalar(filename, precision, unit, data)

    file_id = fopen(filename, "w");
    fprintf(file_id, "type: \'scalar\'\n");
    fprintf(file_id, "measure_unit: '%s'\n", unit);

    fprintf(file_id, "value: %.*f\n",precision, data);

    fclose(file_id);
    is_ok = true;
end