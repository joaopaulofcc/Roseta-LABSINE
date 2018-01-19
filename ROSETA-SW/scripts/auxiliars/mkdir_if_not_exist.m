%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#   Script responsible for creating a directory if it does not exist    #
%#                                                                       #
%#                                                                       #
%# STUDENT                                                               #
%#                                                                       #
%#     Jo�o Paulo Fernanades de Cerqueira C�sar                          #
%#                                                                       #
%# ADVISOR                                                               #
%#                                                                       #
%#     Wilian Soares Lacerda                                             #
%#                                                                       #
%#-----------------------------------------------------------------------#
%#                                                                       #
%# File: mkdir_if_not_exist.m                                            #
%#                                                                       #
%# INPUTS                                                                #
%#                                                                       #
%#      dirpath: directory path.                                         #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################


function mkdir_if_not_exist(dirpath)

    if ~exist(dirpath,'dir') 
        mkdir(dirpath); 
    end
    
end