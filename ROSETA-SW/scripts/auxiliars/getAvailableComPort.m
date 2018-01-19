%#########################################################################
%#	 		 Masters Program in Computer Science - UFLA - 2016/1         #
%#                                                                       #
%# 					      Analysis Implementations                       #
%#                                                                       #
%#           Script responsible to list all available COM ports          #
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
%# File: getAvailableComPort.m                                           #
%#                                                                       #
%# Available in: <goo.gl/RKqYGF>                                         #
%#                                                                       #
%# RETURN                                                                #
%#                                                                       #
%#      lCOM_Port: a Cell Array of COM port names available on computer  #
%#                                                                       #
%# 21/12/17 - Lavras - MG                                                #
%#########################################################################


function lCOM_Port = getAvailableComPort()

    try
        s=serial('IMPOSSIBLE_NAME_ON_PORT');fopen(s); 
    catch
        lErrMsg = lasterr;
    end

    %Start of the COM available port
    lIndex1 = findstr(lErrMsg,'COM');
    %End of COM available port
    lIndex2 = findstr(lErrMsg,'Use')-3;

    lComStr = lErrMsg(lIndex1:lIndex2);

    %Parse the resulting string
    lIndexDot = findstr(lComStr,',');

    % If no Port are available
    if isempty(lIndex1)
        lCOM_Port{1}='';
        return;
    end

    % If only one Port is available
    if isempty(lIndexDot)
        lCOM_Port{1}=lComStr;
        return;
    end

    lCOM_Port{1} = lComStr(1:lIndexDot(1)-1);

    for i=1:numel(lIndexDot)+1
        % First One
        if (i==1)
            lCOM_Port{1,1} = lComStr(1:lIndexDot(i)-1);
        % Last One
        elseif (i==numel(lIndexDot)+1)
            lCOM_Port{i,1} = lComStr(lIndexDot(i-1)+2:end);       
        % Others
        else
            lCOM_Port{i,1} = lComStr(lIndexDot(i-1)+2:lIndexDot(i)-1);
        end
    end    