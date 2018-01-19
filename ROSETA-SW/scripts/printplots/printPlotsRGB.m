 %#########################################################################
 %#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
 %#                                                                       #
 %# 					Analysis Implementations                          #
 %#                                                                       #
 %#     Script responsible for print and export all the plots required.   #
 %#                           of a RGB image.                             #
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
 %# File: printpPlotsRGB.m                                                #
 %#                                                                       #
 %# About: This file describe a script which generate and export the      #
 %#		   following plots for a given RGB color image informed:          #
 %#                                                                       #
 %#        1) RED, GREEN and BLUE channels histograms of the plain,       #
 %#            cipher and decipher images in two sizes (normal and big)   #
 %#                                                                       #
 %#        2) Plain, cipher and decipher images separately.               #
 %#                                                                       #
 %#        3) A frame with a composition of all the itens listed in topic #
 %#             #2 plus three differents textbox with values of entropy,  #
 %#             diffusion and correlation coeficients.                    #
 %#                                                                       #
 %#        4) Correlation scatter plot for each color channel of plain,   #
 %#             and cipher images in two sizes (normal and big).          #
 %#                                                                       #
 %#        5) Three frames with a composition of all the itens listed in  #
 %#             topic #5 for each color channel.                          #
 %#                                                                       #
 %# INPUTS                                                                #
 %#                                                                       #
 %#     images: the matlab image object for plain, cipher and decipher.   #
 %#                                                                       #
 %#     entropyValues: four variables: entropy for all color channels     # 
 %#         together, entropy for plain image, cipher image and other for #
 %#         decipher. The RGB variable is composed by entropy values of   # 
 %#         plain, cipher and decipher images. The others variables are   #
 %#         3 positions arrays: entropy for the Red, Green and Blue image #
 %#         entropy.                                                      #
 %#                                                                       #
 %#     diffusionValues: four variables: diffusion analysis for all color #
 %#         channels, diffusion for each isolate color channels.          #
 %#                                                                       #
 %#     correlationValues: three slots array containig values of correla  #
 %#         tion coeficient for horizontal, vertical and diagonal directi #
 %#         ons. Is informed to the script six of these arrays, three of  #
 %#         them for each color channel of plain image, and the others    #
 %#         three for each color channel of cipher image.                 #
 %#                                                                       #
 %#     paths: string for the folder paths where will be save the outputs.#
 %#                                                                       #
 %#     samples: number of pixels pair sampled in correlation analysis.   #
 %#                                                                       #
 %#     OBS: the remaining parameters represents the correlation arrays   #
 %#         for scatter plot of correlation analysis.                     #
 %#                                                                       #
 %# 17/02/17 - Lavras - MG                                                #
 %#########################################################################

function printPlotsRGB(imgPlain, imgCipher, imgDecipher, ...
                  imgCipherSensitivity, imgDecipherSensitivity, ...
                  ...
                  corrKeySensitivityCipher, corrKeySensitivityDecipher, ...
                  ...    
                  entropyValueRGB,    entropyValuePlain, ...
                  entropyValueCipher, entropyValueDecipher, ...
                  ...
                  diffusionValueRGB,   diffusionValueRed, ...
                  diffusionValueGreen, diffusionValueBlue, ...
                  ....
                  correlationValueRGBPlain, correlationValueRGBCipher, ...
                  correlationValueRGBDecipher, ...
                  correlationValueRPlain, correlationValueRCipher, ...
                  correlationValueGPlain, correlationValueGCipher, ...
                  correlationValueBPlain, correlationValueBCipher, ...
                  xHorzRPlain,  yHorzRPlain,  xVertRPlain,  yVertRPlain, ...
                  xDiagRPlain,  yDiagRPlain,  xHorzGPlain,  yHorzGPlain, ...
                  xVertGPlain,  yVertGPlain,  xDiagGPlain,  yDiagGPlain, ...
                  xHorzBPlain,  yHorzBPlain,  xVertBPlain,  yVertBPlain, ...
                  xDiagBPlain,  yDiagBPlain,  xHorzRCipher, yHorzRCipher, ...
                  xVertRCipher, yVertRCipher, xDiagRCipher, yDiagRCipher, ...
                  xHorzGCipher, yHorzGCipher, xVertGCipher, yVertGCipher, ...
                  xDiagGCipher, yDiagGCipher, xHorzBCipher, yHorzBCipher, ...
                  xVertBCipher, yVertBCipher, xDiagBCipher, yDiagBCipher, ...
                  ...
                  paths, samples)
              

              
    % -------------------------- Save the images -------------------------- 
                
    imwrite(imgPlain,[paths{1} '/images/imgPlainFull.bmp']);
    imwrite(imgCipher,[paths{1} '/images/imgCipherFull.bmp']);
    imwrite(imgDecipher,[paths{1} '/images/imgDecipherFull.bmp']);
    imwrite(imgCipherSensitivity,[paths{4} '/imgCipherSensitivity.bmp']);
    imwrite(imgDecipherSensitivity,[paths{4} '/imgDecipherSensitivity.bmp']);
    
    % Turn off the plots exibition while execution is on progress.
    set(0, 'DefaultFigureVisible', 'off');
                
    
    
    %% -----------------------------------------------------------------
    % --------------------------- TEXTBOXS ----------------------------- 
    % ------------------------------------------------------------------
        
        % Create a unique figure to comport all tables.
        figTables = figure;
        %set(figTables,'visible','off');
        
        % ROW #01 | COLUMN #01 - Show the ENTROPY values.
        
            % Create and place the subplot.
            spFigure = figure;
            set(spFigure,'visible','off');
            spTXT1 = subplot(4,4,14,'Parent', spFigure);
            
            
            % Columns and rows names.
            cnames = {'RGB','Red','Green','Blue'};
            rnames = {'Plain','Cipher','Decipher'};
            
            % Data to be write on table cells.
            data   = {num2str(entropyValueRGB(1),'%.4f')      num2str(entropyValuePlain(1),'%.4f')    ...
                      num2str(entropyValuePlain(2),'%.4f')    num2str(entropyValuePlain(3),'%.4f');   ...
                      ...
                      num2str(entropyValueRGB(2),'%.4f')      num2str(entropyValueCipher(1),'%.4f')   ...
                      num2str(entropyValueCipher(2),'%.4f')   num2str(entropyValueCipher(3),'%.4f');  ...
                      ...
                      num2str(entropyValueRGB(3),'%.4f')      num2str(entropyValueDecipher(1),'%.4f') ...
                      num2str(entropyValueDecipher(2),'%.4f') num2str(entropyValueDecipher(3),'%.4f');...
                      ...
                      '' '' '' ''; ...
                      '' '' '' ''; ...
                      '' '' '' ''; ...
                      '' '' '' ''};
            
            % Create the uitable.
            t = uitable(spFigure, 'Data',  data,   ...
                            'ColumnName',   cnames, ... 
                            'RowName',      rnames, ...
                            'ColumnWidth',  {30},   ...
                            'FontSize',     10);   
                        
            % Hide the scrollbar.           
            jtable = findjobj(t);
            policy = javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER;
            set(jtable, 'VerticalScrollBarPolicy', policy)
                        
            % Get the subplot position and set the table figura to that position.
            pos = get(spTXT1,'position');
            set(t,'units','normalized')
            set(t,'position',pos)
            
            % Auto-resize the table to subplot width.
            jScroll = findjobj(t);
            jTable  = jScroll.getViewport.getView;
            jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
            drawnow;
            
            % Delete the subplot.
            delete(spTXT1);
            
            % Remove the axis of the figure.
            axis off;

            
            
        %% ROW #02 | COLUMN #01 - Show the DIFFUSION values.
        
            % Create and place the subplot.
            spTXT2 = subplot(4,4,15,'Parent', spFigure);
            
            % Columns and rows names.
            cnames = {'NPCRs','NPCRp','UACIs','UACIp'};
            rnames = {'RGB', 'Red','Green','Blue'};
            
            % Data to be write on table cells.
            data   = {num2str(diffusionValueRGB.npcr_score,'%.6f')   num2str(diffusionValueRGB.npcr_pVal,'%.6f')      ...
                      num2str(diffusionValueRGB.uaci_score,'%.6f')   num2str(diffusionValueRGB.uaci_pVal,'%.6f');     ...
                      ...
                      num2str(diffusionValueRed.npcr_score,'%.6f')   num2str(diffusionValueRed.npcr_pVal,'%.6f')      ...
                      num2str(diffusionValueRed.uaci_score,'%.6f')   num2str(diffusionValueRed.uaci_pVal,'%.6f');     ...
                      ...
                      num2str(diffusionValueGreen.npcr_score,'%.6f') num2str(diffusionValueGreen.npcr_pVal,'%.6f')    ...
                      num2str(diffusionValueGreen.uaci_score,'%.6f') num2str(diffusionValueGreen.uaci_pVal,'%.6f');   ...
                      ...
                      num2str(diffusionValueBlue.npcr_score,'%.6f')  num2str(diffusionValueBlue.npcr_pVal,'%.6f')     ...
                      num2str(diffusionValueBlue.uaci_score,'%.6f')  num2str(diffusionValueBlue.uaci_pVal,'%.6f');    ...
                      ...
                      '' '' '' ''; ...
                      '' '' '' ''; ...
                      '' '' '' ''; ...
                      '' '' '' ''};
            
            % Create the uitable
            t = uitable(spFigure, 'Data',  data,   ...
                            'ColumnName',   cnames, ... 
                            'RowName',      rnames, ...
                            'ColumnWidth',  {40},   ...
                            'FontSize',     10);   
            
            % Hide the scrollbar.    
            jtable = findjobj(t);
            policy = javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER;
            set(jtable, 'VerticalScrollBarPolicy', policy)

            % Get the subplot position and set the table figura to that position.
            pos = get(spTXT2,'position');
            set(t,'units','normalized')
            set(t,'position',pos)
            
            % Auto-resize the table to subplot width.
            jScroll = findjobj(t);
            jTable  = jScroll.getViewport.getView;
            jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
            drawnow;
            
            % Delete the subplot.
            delete(spTXT2);
            
            % Remove the axis of the figure.
            axis off;

            
        
        %% ROW #03 | COLUMN #05 - Show the CORRELATION values.
        
            % Create and place the subplot.
            spTXT3 = subplot(4,4,16,'Parent', spFigure);
            
            % Columns and rows names.
            cnames = {'Horz','Vert','Diag'};
            rnames = {'Plain','Cipher','Decipher'};
            data   = {num2str(correlationValueRGBPlain(1),'%.6f')    num2str(correlationValueRGBPlain(2),'%.6f')    ...
                      num2str(correlationValueRGBPlain(3),'%.6f');      ...
                      ...
                      num2str(correlationValueRGBCipher(1),'%.6f')   num2str(correlationValueRGBCipher(2),'%.6f')   ...
                      num2str(correlationValueRGBCipher(3),'%.6f');     ...
                      ...
                      num2str(correlationValueRGBDecipher(1),'%.6f') num2str(correlationValueRGBDecipher(2),'%.6f') ... 
                      num2str(correlationValueRGBDecipher(3),'%.6f');   ...
                      ...
                      '' '' ''; ...
                      '' '' ''; ...
                      '' '' ''; ...
                      '' '' ''};
            
            % Create the uitable
            t = uitable(spFigure, 'Data', data,   ...
                            'ColumnName',   cnames, ... 
                            'RowName',      rnames, ...
                            'ColumnWidth',  {30},   ...
                            'FontSize',     10);   
            
            % Hide the scrollbar.
            jtable = findjobj(t);
            policy = javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER;
            set(jtable, 'VerticalScrollBarPolicy', policy)

            % Get the subplot position and set the table figura to that position.
            pos = get(spTXT3,'position');
            set(t,'units','normalized')
            set(t,'position',pos)
            
            % Auto-resize the table to subplot width.
            jScroll = findjobj(t);
            jTable  = jScroll.getViewport.getView;
            jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
            drawnow;
            
            % Delete the subplot.
            delete(spTXT3);
            
            % Remove the axis of the figure.
            axis off;
    
    
    
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #01 ----------------------------- 
    % ------------------------------------------------------------------
    
    
        % ROW #01 | COLUMN #01 - Show the PLAIN image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            imshow(imgPlain,'InitialMagnification',100);
            title('Plain');
            export_fig(fig, [paths{1} '/imgPlain.png'])
            close(fig);   

            % Show the image in subplot.
            subplot(4,4,1,'Parent', spFigure);
            imshow(imgPlain,'InitialMagnification',100);
            title('Plain');

            
            
            
        %% ROW #01 | COLUMN #02 - Histogram for RED channel of PLAIN image.
            
            % Show the image in subplot.
            sp2 = subplot(4,4,2,'Parent', spFigure);
            [yRed, xRed] = imhist(imgPlain(:,:,1));
            bar(xRed, yRed, 'Red');
            xlim([0 255]);
            title('Red');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp2, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/plain/histPlainRed.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/plain/histPlainRedBig.png'])
            close(hfig)
            
            
            
            
        %% ROW #01 | COLUMN #03 - Histogram for GREEN channel of PLAIN image.
        
            % Show the image in subplot.
            sp3 = subplot(4,4,3,'Parent', spFigure);
            [yGreen, xGreen] = imhist(imgPlain(:,:,2));
            bar(xGreen, yGreen, 'Green');
            xlim([0 255]);
            title('Green');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp3, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/plain/histPlainGreen.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/plain/histPlainGreenBig.png'])
            close(hfig)

            
            
            
        %% ROW #01 | COLUMN #04 - Histogram for BLUE channel of PLAIN image.
        
            % Show the image in subplot.
            sp4 = subplot(4,4,4,'Parent', spFigure);
            [yBlue, xBlue] = imhist(imgPlain(:,:,3));
            bar(xBlue, yBlue, 'Blue');
            xlim([0 255]);
            title('Blue');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp4, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/plain/histPlainBlue.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/plain/histPlainBlueBig.png'])
            close(hfig)

            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------
    
    
        % ROW #02 | COLUMN #01 - Show the CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            imshow(imgCipher,'InitialMagnification',100);
            title('Cipher');
            export_fig(fig, [paths{1} '/imgCipher.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(4,4,5,'Parent', spFigure);
            imshow(imgCipher,'InitialMagnification',100);
            title('Cipher');

            
            
            
        %% ROW #02 | COLUMN #02 - Histogram for RED channel of CIPHER image.
        
            % Show the image in subplot.
            sp6 = subplot(4,4,6,'Parent', spFigure);
            [yRed, xRed] = imhist(imgCipher(:,:,1));
            bar(xRed, yRed, 'Red');
            xlim([0 255]);
            title('Red');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp6, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/cipher/histCipherRed.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/cipher/histCipherRedBig.png'])
            close(hfig)

            
            
            
        %% ROW #02 | COLUMN #03 - Histogram for GREEN channel of CIPHER image.
        
            % Show the image in subplot.
            sp7  = subplot(4,4,7,'Parent', spFigure);
            [yGreen, xGreen] = imhist(imgCipher(:,:,2));
            bar(xGreen, yGreen, 'Green');
            xlim([0 255]);
            title('Green');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp7, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/cipher/histCipherGreen.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/cipher/histCipherGreenBig.png'])
            close(hfig)

            
            
            
        %% ROW #02 | COLUMN #04 - Histogram for GREEN channel of CIPHER image.
        
            % Show the image in subplot.
            sp8 = subplot(4,4,8,'Parent', spFigure);
            [yBlue, xBlue] = imhist(imgCipher(:,:,3));
            bar(xBlue, yBlue, 'Blue');
            xlim([0 255]);
            title('Blue');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp8, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/cipher/histCipherBlue.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/cipher/histCipherBlueBig.png'])
            close(hfig)

            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #03 ----------------------------- 
    % ------------------------------------------------------------------
    
    
        % ROW #03 | COLUMN #01 - Show the DECIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            imshow(imgDecipher,'InitialMagnification',100);
            title('Decipher');
            export_fig(fig, [paths{1} '/imgDecipher.png'])
            close(fig);        
            
            % Show the image in subplot.
            subplot(4,4,9,'Parent', spFigure);
            imshow(imgDecipher,'InitialMagnification',100);
            title('Decipher');

        
        
        
        %% ROW #03 | COLUMN #02 - Histogram for RED channel of DECIPHER image.
        
            % Show the image in subplot.
            sp10 = subplot(4,4,10,'Parent', spFigure);
            [yRed, xRed] = imhist(imgDecipher(:,:,1));
            bar(xRed, yRed, 'Red');
            xlim([0 255]);
            title('Red');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp10, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/decipher/histDecipherRed.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/decipher/histDecipherRedBig.png'])
            close(hfig)

            
            
            
        %% ROW #03 | COLUMN #03 - Histogram for GREEN channel of DECIPHER image.
        
            % Show the image in subplot.
            sp11 = subplot(4,4,11,'Parent', spFigure);
            [yGreen, xGreen] = imhist(imgDecipher(:,:,2));
            bar(xGreen, yGreen, 'Green');
            xlim([0 255]);
            title('Green');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp11, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/decipher/histDecipherGreen.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/decipher/histDecipherGreenBig.png'])
            close(hfig)

            
            
            
        %% ROW #03 | COLUMN #04 - Histogram for BLUE channel of DECIPHER image.
        
            % Show the image in subplot.
            sp12 = subplot(4,4,12,'Parent', spFigure);
            [yBlue, xBlue] = imhist(imgDecipher(:,:,3));
            bar(xBlue, yBlue, 'Blue');
            xlim([0 255]);
            title('Blue');
            
            % Clone the subplot image to save the plot alone.
            hfig = figure;
            set(hfig,'visible','off');
            hax_new = copyobj(sp12, hfig);
            set(hax_new, 'Position', get(0, 'DefaultAxesPosition'));
            
            % Normal window size.
            export_fig(hfig, [paths{2} '/decipher/histDecipherBlue.png'])
            
            % Window size scale to screen size.
            set(hfig, 'Position', get(0, 'Screensize'));
            export_fig(hfig, [paths{2} '/decipher/histDecipherBlueBig.png'])
            close(hfig)
            

            
        %% Set the window size scale to screen size.
        set(spFigure, 'Position', get(0, 'Screensize'));
        %pos = get(gcf,'pos');
        %set(gcf,'pos',[pos(1) pos(2) 1920 1080])
        
        % Save all the subplots in the same frame.
        export_fig(spFigure, [paths{1} '/analysis.png'], '-m2')        
        
        % Close the window of frame plot.
        close(spFigure);
                    
        
        
    %% -----------------------------------------------------------------
    % --------------------- CORRELATION PLOTS RED ---------------------- 
    % ------------------------------------------------------------------

    
        % ROW #01 | COLUMN #01 - HORIZONTAL correlation of PLAIN image RED.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xHorzRPlain(:), yHorzRPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueRPlain(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xHorzRPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xHorzRPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            spFigure = figure;
            set(spFigure,'visible','off');
            subplot(2,3,1,'Parent', spFigure);
            scatter(xHorzRPlain(:), yHorzRPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueRPlain(1),'%.6f')));

            
            
            
        %% ROW #01 | COLUMN #02 - VERTICAL correlation of PLAIN image RED.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertRPlain(:), yVertRPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueRPlain(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xVertRPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xVertRPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,2,'Parent', spFigure);
            scatter(xVertRPlain(:), yVertRPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueRPlain(2),'%.6f')));

            
            
            
        %% ROW #01 | COLUMN #03 - DIAGONAL correlation of PLAIN image RED.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagRPlain(:), yDiagRPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueRPlain(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xDiagRPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xDiagRPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,3,'Parent', spFigure);
            scatter(xDiagRPlain(:), yDiagRPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueRPlain(3),'%.6f')));
        
            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------    
            
            
        % ROW #02 | COLUMN #01 - HORIZONTAL correlation of CIPHER image RED.
            
            % Show the image only for save in a file.
            fig = figure; 
            set(fig,'visible','off');
            scatter(xHorzRCipher(:), yHorzRCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueRCipher(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xHorzRCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xHorzRCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,4,'Parent', spFigure);
            scatter(xHorzRCipher(:), yHorzRCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueRCipher(1),'%.6f')));

            
            
            
        %% ROW #02 | COLUMN #02 - VERTICAL correlation of CIPHER image RED.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertRCipher(:), yVertRCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueRCipher(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xVertRCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xVertRCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,5,'Parent', spFigure);
            scatter(xVertRCipher(:), yVertRCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueRCipher(2),'%.6f')));
            
            
            

        %% ROW #02 | COLUMN #03 - DIAGONAL correlation of CIPHER image RED.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagRCipher(:), yDiagRCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueRCipher(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/red/xDiagRCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/red/xDiagRCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,6,'Parent', spFigure);
            scatter(xDiagRCipher(:), yDiagRCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueRCipher(3),'%.6f')));

            
            
            
        %% Write a header title in over all subplots.
        suptitle(['RED CHANNEL - ' num2str(samples) ' samples']);

        % Set the window size scale to screen size.
        set(spFigure, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(spFigure, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        saveas(spFigure, [paths{3} '/red/plotsCorrelationRed.png'])
        
        % Close the window of frame plot.
        close(spFigure);
        
        
        
        
    %% -----------------------------------------------------------------
    % -------------------- CORRELATION PLOTS GREEN --------------------- 
    % ------------------------------------------------------------------

    
        % ROW #01 | COLUMN #01 - HORIZONTAL correlation of PLAIN image GREEN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xHorzGPlain(:), yHorzGPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueGPlain(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xHorzGPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xHorzGPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            spFigure = figure;
            set(spFigure,'visible','off');
            subplot(2,3,1,'Parent', spFigure);
            scatter(xHorzGPlain(:), yHorzGPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueGPlain(1),'%.6f')));

            
            
            
        %% ROW #01 | COLUMN #02 - VERTICAL correlation of PLAIN image GREEN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertGPlain(:), yVertGPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueGPlain(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xVertGPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xVertGPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,2,'Parent', spFigure);
            scatter(xVertGPlain(:), yVertGPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueGPlain(2),'%.6f')));

            
            
            
        %% ROW #01 | COLUMN #03 - DIAGONAL correlation of PLAIN image GREEN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagGPlain(:), yDiagGPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueGPlain(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xDiagGPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xDiagGPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,3,'Parent', spFigure);
            scatter(xDiagGPlain(:), yDiagGPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueGPlain(3),'%.6f')));
        
            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------    
            
            
        % ROW #02 | COLUMN #01 - HORIZONTAL correlation of CIPHER image GREEN.
            
            % Show the image only for save in a file.
            fig = figure; 
            set(fig,'visible','off');
            scatter(xHorzGCipher(:), yHorzGCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueGCipher(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xHorzGCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xHorzGCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,4,'Parent', spFigure);
            scatter(xHorzGCipher(:), yHorzGCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueGCipher(1),'%.6f')));

            
            
            
        %% ROW #02 | COLUMN #02 - VERTICAL correlation of CIPHER image GREEN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertGCipher(:), yVertGCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueGCipher(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xVertGCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xVertGCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,5,'Parent', spFigure);
            scatter(xVertGCipher(:), yVertGCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueGCipher(2),'%.6f')));
            
            
            

        %% ROW #02 | COLUMN #03 - DIAGONAL correlation of CIPHER image GREEN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagGCipher(:), yDiagGCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueGCipher(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/green/xDiagGCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/green/xDiagGCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,6,'Parent', spFigure);
            scatter(xDiagGCipher(:), yDiagGCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueGCipher(3),'%.6f')));

            
            
            
        %% Write a header title in over all subplots.
        suptitle(['GRREN CHANNEL - ' num2str(samples) ' samples']);

        % Set the window size scale to screen size.
        set(spFigure, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(spFigure, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        saveas(spFigure, [paths{3} '/green/plotsCorrelationGreen.png'])
        
        % Close the window of frame plot.
        close(spFigure);
        
        
        
        
    %% -----------------------------------------------------------------
    % --------------------- CORRELATION PLOTS BLUE --------------------- 
    % ------------------------------------------------------------------

    
        % ROW #01 | COLUMN #01 - HORIZONTAL correlation of PLAIN image BLUE.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xHorzBPlain(:), yHorzBPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueBPlain(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xHorzBPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xHorzBPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            spFigure = figure;
            set(spFigure,'visible','off');
            subplot(2,3,1,'Parent', spFigure);
            scatter(xHorzBPlain(:), yHorzBPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValueBPlain(1),'%.6f')));

            
            
        %% ROW #01 | COLUMN #02 - VERTICAL correlation of PLAIN image BLUE.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertBPlain(:), yVertBPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueBPlain(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xVertBPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xVertBPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,2,'Parent', spFigure);
            scatter(xVertBPlain(:), yVertBPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValueBPlain(2),'%.6f')));

            
            
            
        %% ROW #01 | COLUMN #03 - DIAGONAL correlation of PLAIN image BLUE.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagBPlain(:), yDiagBPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueBPlain(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xDiagBPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xDiagBPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,3,'Parent', spFigure);
            scatter(xDiagBPlain(:), yDiagBPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValueBPlain(3),'%.6f')));
        
            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------    
            
            
        % ROW #02 | COLUMN #01 - HORIZONTAL correlation of CIPHER image BLUE.
            
            % Show the image only for save in a file.
            fig = figure; 
            set(fig,'visible','off');
            scatter(xHorzBCipher(:), yHorzBCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueBCipher(1),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xHorzBCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xHorzBCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,4,'Parent', spFigure);
            scatter(xHorzBCipher(:), yHorzBCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueBCipher(1),'%.6f')));

            
            
            
        %% ROW #02 | COLUMN #02 - VERTICAL correlation of CIPHER image BLUE.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xVertBCipher(:), yVertBCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueBCipher(2),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xVertBCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xVertBCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,5,'Parent', spFigure);
            scatter(xVertBCipher(:), yVertBCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueBCipher(2),'%.6f')));
            
            
            

        %% ROW #02 | COLUMN #03 - DIAGONAL correlation of CIPHER image BLUE.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off');
            scatter(xDiagBCipher(:), yDiagBCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueBCipher(3),'%.6f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/blue/xDiagBCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/blue/xDiagBCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,6,'Parent', spFigure);
            scatter(xDiagBCipher(:), yDiagBCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueBCipher(3),'%.6f')));

            
            
            
        %% Write a header title in over all subplots.
        suptitle(['BLUE CHANNEL - ' num2str(samples) ' samples']);

        % Set the window size scale to screen size.
        set(spFigure, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(spFigure, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        saveas(spFigure, [paths{3} '/blue/plotsCorrelationBlue.png'])
        
        % Close the window of frame plot.
        close(spFigure);
        
        
        
        
    %% -----------------------------------------------------------------
    % ------------------ KEY SENSITIVITY PLOTS CIPHER ------------------
    % ------------------------------------------------------------------
    
        %% ROW #01 | COLUMN #01 - CIPHER image using K1.
    
        % Show the cipher image with K1 key in subplot.
        spFigure = figure;
        set(spFigure,'visible','off');
        subplot(2,2,1,'Parent', spFigure);
        imshow(imgCipher);
        title('Cipher K1');
        

        %% ROW #01 | COLUMN #02 - CIPHER image using K2.
        
        % Show the cipher image with K2 key in subplot.
        subplot(2,2,2,'Parent', spFigure);
        imshow(imgCipherSensitivity);
        title('Cipher K2');

        
        %% ROW #02 | COLUMN #01 - CIPHER image using K1 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgCipherZoom = imgCipher(1:5,1:5,:);
        dims = size(imgCipherZoom);
        fig = figure; 
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Cipher K1');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedCipherK1.png'])
        close(fig);  
        
        % ---------

        fig = figure; 
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.4, j - 0.09, num2str(imgCipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 17);
                
            end
            
        end
        
        title('Zoomed Cipher K1');
        
        % Window size scale to screen size.
        set(gcf, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedCipherK1Big.png'])
        close(fig);  
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,3,'Parent', spFigure);
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Cipher K1');
        
        
        %% ROW #02 | COLUMN #02 - CIPHER image using K2 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgCipherSensitivityZoom = imgCipherSensitivity(1:5, 1:5, :);
        dims = size(imgCipherSensitivityZoom);
        fig = figure; 
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Cipher K2');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedCipherK2.png'])
        close(fig); 

        % ---------
        
        fig = figure; 
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.4, j - 0.09, num2str(imgCipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 17);
                
            end
            
        end
        
        title('Zoomed Cipher K2');
        
        % Window size scale to screen size.
        set(gcf, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedCipherK2Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,4,'Parent', spFigure);
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Cipher K2');
        
        
        
        %% Write a header title in over all subplots.
        suptitle(['KEY SENSITIVITY ANALYSIS (CIPHER) - Correlation: (' num2str(corrKeySensitivityCipher, ' %.6f') ')']);

        % Set the window size scale to screen size.
        set(gcf, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(gcf, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        export_fig(fig, [paths{4} '/plotsSensitivityCipher.png'], '-p0.05')
        
        % Close the window of frame plot.
        close(spFigure);
        
        
        
    
    %% -----------------------------------------------------------------
    % ----------------- KEY SENSITIVITY PLOTS DECIPHER -----------------
    % ------------------------------------------------------------------
        
        %% ROW #01 | COLUMN #01 - DECIPHER image using K1.
    
        % Show the decipher image with K1 key in subplot.
        spFigure = figure;
        subplot(2,2,1,'Parent', spFigure);
        imshow(imgDecipher);
        title('Decipher K1');

        
        %% ROW #01 | COLUMN #02 - DECIPHER image using K2.
        
        % Show the decipher image with K2 key in subplot.
        subplot(2,2,2,'Parent', spFigure);
        imshow(imgDecipherSensitivity);
        title('Decipher K2');
        
        
        %% ROW #02 | COLUMN #01 - DECIPHER image using K1 - zoomed region 5x5.

        % Show the image only for save in a file.
        imgDecipherZoom = imgDecipher(1:5, 1:5, :);
        dims = size(imgDecipherZoom);
        fig = figure; 
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Decipher K1');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedDecipherK1.png'])
        close(fig);

        % ---------
        
        fig = figure; 
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.4, j - 0.09, num2str(imgDecipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 17);
                
            end
            
        end
        
        title('Zoomed Decipher K1');
        
        % Window size scale to screen size.
        set(gcf, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedDecipherK1Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,3,'Parent', spFigure);
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Decipher K1');
        
        
        %% ROW #02 | COLUMN #02 - DECIPHER image using K2 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgDecipherSensitivityZoom = imgDecipherSensitivity(1:5, 1:5, :);
        dims = size(imgDecipherSensitivityZoom);
        fig = figure; 
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Decipher K2');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedDecipherK2.png'])
        close(fig);

        % ---------
        
        % Window size scale to screen size.
        fig = figure; 
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.4, j - 0.09, num2str(imgDecipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 17);
                
            end
            
        end
        
        title('Zoomed Decipher K2');
        
        set(gcf, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedDecipherK2Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,4,'Parent', spFigure);
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        title('Zoomed Decipher K2');
        
        
        
        %% Write a header title in over all subplots.
        suptitle(['KEY SENSITIVITY ANALYSIS (DECIPHER) - Correlation: (' num2str(corrKeySensitivityDecipher, ' %.6f') ')']);

        % Set the window size scale to screen size.
        set(gcf, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(gcf, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        export_fig(fig, [paths{4} '/plotsSensitivityDecipher.png'], '-p0.05')

        % Close the window of frame plot.
        close(spFigure);
end