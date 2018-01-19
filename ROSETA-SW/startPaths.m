%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#  Script responsible to add the required paths to system environment.  #
%#                                                                       #
%#                                                                       #
%# STUDENT                                                               #
%#                                                                       #
%#     João Paulo Fernanades de Cerqueira César                          #
%#                                                                       #
%# ADVISOR                                                               #
%#                                                                       #
%#     Wilian Soares Lacerda                                             #
%#                                                                       #
%#-----------------------------------------------------------------------#
%#                                                                       #
%# File: startPaths.m                                                    #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################


%% Add folders containing source codes to path.
addpath(genpath('scripts'));

% Add folder containing the GUI.
addpath(genpath('gui'));

% Add folder containing images to be used.
addpath(genpath('datasets'));

% Add folder containing the resulting statistics.
addpath(genpath('statistics'));

% Add folder with c generators to the system path.
path = getenv('PATH');
path = [path pwd '\scripts\generators\;'];
setenv('PATH', path);

% Clear the prompt.
clc