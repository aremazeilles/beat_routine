#!/usr/bin/octave -qf
printf ("current directory: %s\n", pwd())
addpath("beat/Functions") %%beat is the folder containing all the functions needed for the BEAT project PI algos
addpath("beat/AdditionalFunctions")
arg_list = argv ();
if nargin != 3
  printf ("ERROR: Provided %d parameters, but expecting 3\n", nargin)
  printf ("Usage:\n")
  printf ("\t run_kinematic_perturbation jointAngle.csv platformData.csv out_folder\n")
  exit(1)
endif

printf ("csv file: %s\n", arg_list{1});
printf ("platform data: %s\n", arg_list{2});


[ROM_p]=kinematic_routine_perturbation(arg_list{1}, arg_list{2}, arg_list{3})