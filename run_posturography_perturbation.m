#!/usr/bin/octave -qf
printf ("current directory: %s\n", pwd())
addpath("beat/Functions") %%beat is the folder containing all the functions needed for the BEAT project PI algos
addpath("beat/AdditionalFunctions")
arg_list = argv ();
if nargin != 2
  printf ("ERROR: Provided %d parameters, but expecting 2\n", nargin)
  printf ("Usage:\n")
  printf ("\t run_posturography_perturbation platformData.csv out_folder\n")
  exit(1)
endif

printf ("platform data: %s\n", arg_list{1});


[PL_p EA_p]=posturographic_routine_perturbation(arg_list{1},arg_list{2})