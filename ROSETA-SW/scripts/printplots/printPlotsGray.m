 %#########################################################################
 %#	 		 Masters Program in Computer Science - UFLA - 2016/1          #
 %#                                                                       #
 %# 					Analysis Implementations                          #
 %#                                                                       #
 %#     Script responsible for print and export all the plots required.   #
 %#                         of a grayscale image.                         #
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
 %# File: printpPlotsGray.m                                               #
 %#                                                                       #
 %# About: This file describe a script which generate and export the      #
 %#		   following plots for a given grayscale color image informed:    #
 %#                                                                       #
 %#        1) Histograms of the plain, cipher and decipher images in      #
 %#             two sizes (normal and big)                                #
 %#                                                                       #
 %#        2) Plain, cipher and decipher images separately.               #
 %#                                                                       #
 %#        3) A frame with a composition of all the itens listed in topic #
 %#             #2 plus three differents textbox with values of entropy,  #
 %#             diffusion and correlation coeficients.                    #
 %#                                                                       #
 %#        4) Correlation scatter plot for plain and cipher images in     #
 %#             two sizes (normal and big).                               #
 %#                                                                       #
 %#        5) A frame with a composition of all itens listed in topic #5  #
 %#                                                                       #
 %# INPUTS                                                                #
 %#                                                                       #
 %#     images: the matlab image object for plain, cipher and decipher.   #
 %#             besides the images for key sensitivity analysis.          #
 %#                                                                       #
 %#     correlationValue: three slots array containig values of correla   #
 %#         tion coeficient for horizontal, vertical and diagonal directi #
 %#         ons. Is informed to the script six of these arrays, three of  #
 %#         them for each color channel of plain image, and the others    #
 %#         three for each color channel of cipher image                  #
 %#                                                                       #
 %#     paths: string for the folder paths where will be save the outputs.#
 %#                                                                       #
 %#     samples: number of pixels pair sampled in correlation analysis.   #
 %#                                                                       #
 %#     OBS: the remaining parameters represents the correlation arrays   #
 %#         for scatter plot of correlation analysis.                     #
 %#                                                                       #
 %# 21/12/17 - Lavras - MG                                                #
 %#########################################################################


function printPlotsGray(imgPlain, imgCipher, imgDecipher, imgCipherSensitivity, ...
                    imgDecipherSensitivity, corrKeySensitivityCipher, ...
                    corrKeySensitivityDecipher, entropyValue, ...
                    diffusionValue, correlationValuePlain, ...
                    correlationValueCipher, xHorzPlain,  yHorzPlain,  ...
                    xVertPlain,  yVertPlain,  xDiagPlain,  yDiagPlain, ...
                    xHorzCipher, yHorzCipher, xVertCipher, yVertCipher, ...
                    xDiagCipher, yDiagCipher, paths, samples)

                
    % -------------------------- Save the images -------------------------- 
                
    imwrite(imgPlain,[paths{1} '/images/imgPlainFull.bmp']);
    imwrite(imgCipher,[paths{1} '/images/imgCipherFull.bmp']);
    imwrite(imgDecipher,[paths{1} '/images/imgDecipherFull.bmp']);
    imwrite(imgCipherSensitivity,[paths{4} '/imgCipherSensitivity.bmp']);
    imwrite(imgDecipherSensitivity,[paths{4} '/imgDecipherSensitivity.bmp']);
    
    
    % Turn off the plots exibition while execution is on progress.
     set(0,'DefaultFigureVisible','off');
                    
                
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #01 ----------------------------- 
    % ------------------------------------------------------------------
              
   
        % ROW #01 | COLUMN #01 - Show the PLAIN image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imshow(imgPlain, 'InitialMagnification',100);
            title('Plain');
            export_fig(fig, [paths{1} '/imgPlain.png'])
            close(fig);                     
            
            % Show the image in subplot.
            sp = figure;
            set(sp,'visible','off');
            subplot(3,3,1, 'Parent', sp);
            imshow(imgPlain);
            title('Plain');

            
            
            
        %% ROW #01 | COLUMN #02 - Show the CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imshow(imgCipher, 'InitialMagnification',100);
            title('Cipher');
            export_fig(fig, [paths{1} '/imgCipher.png'])
            close(fig);   
            
            % Show the image in subplot.
            subplot(3,3,2, 'Parent', sp);
            imshow(imgCipher);
            title('Cipher');
            
            
            

        %% ROW #01 | COLUMN #03 - Show the DECIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imshow(imgDecipher, 'InitialMagnification',100);
            title('Decipher');
            export_fig(fig, [paths{1} '/imgDecipher.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(3,3,3, 'Parent', sp);
            imshow(imgDecipher);
            title('Decipher');
            
            
            

    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------
    
    
        %% ROW #02 | COLUMN #01 - Histogram of PLAIN image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imhist(imgPlain);
            
            % Normal window size.
            export_fig(fig, [paths{2} '/histPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{2} '/histPlainBig.png'])
            close(fig);         
            
            % Show the image in subplot.
            subplot(3,3,4, 'Parent', sp);
            imhist(imgPlain);

            
            
            
        % ROW #02 | COLUMN #02 - Histogram of CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imhist(imgCipher);
            
            % Normal window size.
            export_fig(fig, [paths{2} '/histCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{2} '/histCipherBig.png'])
            close(fig);
            
            % Show the image in subplot.
            subplot(3,3,5, 'Parent', sp);
            imhist(imgCipher);

    
            
            
        % ROW #02 | COLUMN #03 - Histogram of DECIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            imhist(imgDecipher);
            
            % Normal window size.
            export_fig(fig, [paths{2} '/histDecipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{2} '/histDecipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(3,3,6, 'Parent', sp);
            imhist(imgDecipher);

            
            
            
    %% -----------------------------------------------------------------
    % --------------------------- TEXTBOXS ----------------------------- 
    % ------------------------------------------------------------------
    
    
        % ROW #03 | COLUMN #01 - Show the ENTROPY values.
        
            % Create and place the subplot.
            handle = subplot(3,3,7, 'Parent', sp);

            % Calculates the vertical center position.
            yl      = ylim(handle); 
            yPos    = yl(1) + diff(yl) / 2; 

            % Set the strings to be showed.
            line1Str = sprintf('         Entropy\n');
            
            line2Str = sprintf('Plain:        %s', ...
                num2str(entropyValue(1),'%.4f')); % Entropy value of PLAIN
            
            line3Str = sprintf('Cipher:      %s', ...
                num2str(entropyValue(2),'%.4f')); % Entropy value of CIPHER
            
            line4Str = sprintf('Decipher:  %s', ...
                num2str(entropyValue(3),'%.4f')); % Entropy value of DECIPHER

            % Create a text obeject with the strings.
            t = text(0.3, yPos, sprintf('%s\n%s\n%s\n%s', line1Str, line2Str, line3Str, line4Str), 'Parent', handle);
            
            % Change the text properties.
            set(t, 'FontSize', 12);
            set(t, 'EdgeColor', 'black');
            set(t, 'LineWidth', 1);
            set(t, 'HorizontalAlignment', 'left');
            
            % Remove the axis of the figure.
            axis off;

            
            
            
        %% ROW #03 | COLUMN #02 - Show the DIFFUSION values.
        
            % Create and place the subplot.
            handle = subplot(3,3,8, 'Parent', sp);

            % Calculates the vertical center position.
            yl      = ylim(handle); 
            yPos    = yl(1) + diff(yl) / 2; 

            % Set the strings to be showed.
            line1Str = sprintf('           Diffusion\n');
            
            line2Str = sprintf('NPCR Score:     %s', ...
                num2str(diffusionValue.npcr_score,'%.4f')); % NPCR Score value.
            
            line3Str = sprintf('NPCR pValue:   %s', ...
                num2str(diffusionValue.npcr_pVal,'%.4f'));  % NPCR P value
            
            line4Str = sprintf('');
            
            line5Str = sprintf('UACI Score:       %s', ...
                num2str(diffusionValue.uaci_score,'%.4f')); % UACI Score value.
            
            line6Str = sprintf('UACI pValue:     %s', ...
                num2str(diffusionValue.uaci_pVal,'%.4f'));  % UACI P value.

            % Create a text obeject with the strings.
            t = text(0.27, yPos, sprintf('%s\n%s\n%s\n%s\n%s\n%s', line1Str, line2Str, line3Str, line4Str, line5Str, line6Str), 'Parent', handle);
           
            % Change the text properties.
            set(t, 'FontSize', 12);
            set(t, 'EdgeColor', 'black');
            set(t, 'LineWidth', 1);
            set(t, 'HorizontalAlignment', 'left');
            
            % Remove the axis of the figure.
            axis off;   

            
            
            
        %% ROW #03 | COLUMN #03 - Show the CORRELATION values.
        
            % Create and place the subplot.
            handle = subplot(3,3,9, 'Parent', sp);

            % Calculates the vertical center position.
            yl      = ylim(handle); 
            yPos    = yl(1) + diff(yl) / 2; 

            % Set the strings to be showed.
            line1Str = sprintf('      Correlation\n');
            
            line2Str = sprintf('Horizontal:    %s', ...
                num2str(correlationValueCipher(1),'%.4f')); % Horizontal 
            
            
            line3Str = sprintf('Vertical:      %s', ...
                num2str(correlationValueCipher(2),'%.4f')); % Vertical
            
            
            line4Str = sprintf('Diagonal:     %s', ...
                num2str(correlationValueCipher(3),'%.4f')); % Diagonal

            % Create a text obeject with the strings.
            t = text(0.3, yPos, sprintf('%s\n%s\n%s\n%s', line1Str, line2Str, line3Str, line4Str), 'Parent', handle);
            
            % Change the text properties.
            set(t, 'FontSize', 12);
            set(t, 'EdgeColor', 'black');
            set(t, 'LineWidth', 1);
            set(t, 'HorizontalAlignment', 'left');
            
            % Remove the axis of the figure.
            axis off;
            
            
            
            
        %% Set the window size scale to screen size.
        set(sp, 'Position', get(0, 'Screensize'));

        % Save all the subplots in the same frame.
        export_fig(sp, [paths{1} '/analysis.png'], '-m2')

        % Close the window of frame plot.
        close(sp);
        
    
    
    
    %% -----------------------------------------------------------------
    % ----------------------- CORRELATION PLOTS ------------------------ 
    % ------------------------------------------------------------------
    
    
        % ROW #01 | COLUMN #01 - HORIZONTAL correlation of PLAIN image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            scatter(xHorzPlain(:), yHorzPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValuePlain(1),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xHorzPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xHorzPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            sp = figure;
            set(sp,'visible','off');
            subplot(2,3,1, 'Parent', sp);
            scatter(xHorzPlain(:), yHorzPlain(:));
            title(sprintf('Horizontal Plain: %s', ...
                num2str(correlationValuePlain(1),'%.4f')));
            
            
            

        %% ROW #01 | COLUMN #02 - VERTICAL correlation of PLAIN.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            scatter(xVertPlain(:), yVertPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValuePlain(2),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xVertPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xVertPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,2, 'Parent', sp);
            scatter(xVertPlain(:), yVertPlain(:));
            title(sprintf('Vertical Plain: %s', ...
                num2str(correlationValuePlain(2),'%.4f')));

            
            
            
        %% ROW #01 | COLUMN #03 - DIAGONAL correlation of PLAIN.
        
            % Show the image only for save in a file.
            fig = figure; 
            set(fig,'visible','off')
            scatter(xDiagPlain(:), yDiagPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValuePlain(3),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xDiagPlain.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xDiagPlainBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,3, 'Parent', sp);
            scatter(xDiagPlain(:), yDiagPlain(:));
            title(sprintf('Diagonal Plain: %s', ...
                num2str(correlationValuePlain(3),'%.4f')));

            
            
            
    %% -----------------------------------------------------------------
    % ---------------------------- ROW #02 ----------------------------- 
    % ------------------------------------------------------------------
    
    
        % ROW #02 | COLUMN #01 - HORIZONTAL correlation of CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            scatter(xHorzCipher(:), yHorzCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueCipher(1),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xHorzCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xHorzCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,4, 'Parent', sp);
            scatter(xHorzCipher(:), yHorzCipher(:));
            title(sprintf('Horizontal Cipher: %s', ...
                num2str(correlationValueCipher(1),'%.4f')));

            
            
            
        %% ROW #02 | COLUMN #02 - VERTICAL correlation of CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            scatter(xVertCipher(:), yVertCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueCipher(2),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xVertCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xVertCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,5, 'Parent', sp);
            scatter(xVertCipher(:), yVertCipher(:));
            title(sprintf('Vertical Cipher: %s', ...
                num2str(correlationValueCipher(2),'%.4f')));


        %% ROW #02 | COLUMN #03 - DIAGONAL correlation of CIPHER image.
        
            % Show the image only for save in a file.
            fig = figure;
            set(fig,'visible','off')
            scatter(xDiagCipher(:), yDiagCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueCipher(3),'%.4f')));
            
            % Normal window size.
            export_fig(fig, [paths{3} '/xDiagCipher.png'])
            
            % Window size scale to screen size.
            set(fig, 'Position', get(0, 'Screensize'));
            export_fig(fig, [paths{3} '/xDiagCipherBig.png'])
            close(fig);  
            
            % Show the image in subplot.
            subplot(2,3,6, 'Parent', sp);
            scatter(xDiagCipher(:), yDiagCipher(:));
            title(sprintf('Diagonal Cipher: %s', ...
                num2str(correlationValueCipher(3),'%.4f')));

            
            
        %% Write a header title in over all subplots.
        suptitle(['CORRELATION ANALYSIS - ' num2str(samples) ' samples']);

        % Set the window size scale to screen size.
        set(sp, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(sp, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        export_fig(fig, [paths{3} '/plotsCorrelation.png'])

        % Close the window of frame plot.
        close(sp);
        
        
        
    %% -----------------------------------------------------------------
    % ------------------ KEY SENSITIVITY PLOTS CIPHER ------------------
    % ------------------------------------------------------------------
    
    %% ROW #01 | COLUMN #01 - CIPHER image using K1.
        
        % Show the cipher image with K1 key in subplot.
        sp = figure;
        set(sp,'visible','off');
        subplot(2,2,1, 'Parent', sp);
        imshow(imgCipher);
        title('Cipher K1');
        

    %% ROW #01 | COLUMN #02 - CIPHER image using K2.
        
        % Show the cipher image with K2 key in subplot.
        subplot(2,2,2, 'Parent', sp);
        imshow(imgCipherSensitivity);
        title('Cipher K2');

        
    %% ROW #02 | COLUMN #01 - CIPHER image using K1 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgCipherZoom = imgCipher(1:5,1:5,:);
        dims = size(imgCipherZoom);
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Cipher K1');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedCipherK1.png'])
        close(fig);  
        
        % ---------

        fig = figure;
        set(fig,'visible','off')
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 28);
                
            end
            
        end
        
        title('Zoomed Cipher K1');
        
        % Window size scale to screen size.
        set(fig, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedCipherK1Big.png'])
        close(fig);  
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,3, 'Parent', sp);
        imagesc(imgCipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
            end
    
        end
        
        title('Zoomed Cipher K1');
        
        
    %% ROW #02 | COLUMN #02 - CIPHER image using K2 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgCipherSensitivityZoom = imgCipherSensitivity(1:5, 1:5, :);
        dims = size(imgCipherSensitivityZoom);
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Cipher K2');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedCipherK2.png'])
        close(fig); 

        % ---------
        
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 28);
                
            end
            
        end
        
        title('Zoomed Cipher K2');
        
        % Window size scale to screen size.
        set(fig, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedCipherK2Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,4, 'Parent', sp);
        imagesc(imgCipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgCipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Cipher K2');
        
        
        
        %% Write a header title in over all subplots.
        suptitle(['KEY SENSITIVITY ANALYSIS (CIPHER) - Correlation: ' num2str(corrKeySensitivityCipher, '%.4f')]);

        % Set the window size scale to screen size.
        set(sp, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(sp, 'Visible', 'Off');

        % Save all the subplots in the same frame.
        export_fig(fig, [paths{4} '/plotsSensitivityCipher.png'], '-p0.05')

        % Close the window of frame plot.
        close(sp);
        
        
        
    %% -----------------------------------------------------------------
    % ----------------- KEY SENSITIVITY PLOTS DECIPHER -----------------
    % ------------------------------------------------------------------
        
    %% ROW #01 | COLUMN #01 - DECIPHER image using K1.
        
        % Show the decipher image with K1 key in subplot.
        sp = figure;
        set(sp,'visible','off');
        subplot(2,2,1, 'Parent', sp);
        imshow(imgDecipher);
        title('Decipher K1');

        
    %% ROW #01 | COLUMN #02 - DECIPHER image using K2.
        
        % Show the decipher image with K2 key in subplot.
        subplot(2,2,2, 'Parent', sp);
        imshow(imgDecipherSensitivity);
        title('Decipher K2');
        
        
    %% ROW #02 | COLUMN #01 - DECIPHER image using K1 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgDecipherZoom = imgDecipher(1:5, 1:5, :);
        dims = size(imgDecipherZoom);
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgDecipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Decipher K1');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedDecipherK1.png'])
        close(fig);

        % ---------
        
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgDecipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 28);
                
            end
            
        end
        
        title('Zoomed Decipher K1');
        
        % Window size scale to screen size.
        set(fig, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedDecipherK1Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,3, 'Parent', sp);
        imagesc(imgDecipherZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgDecipherZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Decipher K1');
        
        
    %% ROW #02 | COLUMN #02 - DECIPHER image using K2 - zoomed region 5x5.
        
        % Show the image only for save in a file.
        imgDecipherSensitivityZoom = imgDecipherSensitivity(1:5, 1:5, :);
        dims = size(imgDecipherSensitivityZoom);
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgDecipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Decipher K2');

        % Normal window size.
        export_fig(fig, [paths{4} '/zoomedDecipherK2.png'])
        close(fig);

        % ---------
        
        % Window size scale to screen size.
        fig = figure; 
        set(fig,'visible','off')
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        colormap gray;
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.13, j - 0.05, num2str(imgDecipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold', 'FontSize', 28);
                
            end
            
        end
        
        title('Zoomed Decipher K2');
        
        set(fig, 'Position', get(0, 'Screensize'));
        export_fig(fig, [paths{4} '/zoomedDecipherK2Big.png'])
        close(fig); 
        
        % ---------
        
        % Show the image in subplot.
        subplot(2,2,4, 'Parent', sp);
        imagesc(imgDecipherSensitivityZoom), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]);
        
        for i = 1:dims(1)
           
            for j = 1:dims(2)
            
                text(i - 0.17, j - 0.09, num2str(imgDecipherSensitivityZoom(j, i, :)), 'Color', 'red', ...
                    'BackgroundColor', 'cyan', 'FontWeight', 'bold');
                
            end
            
        end
        
        title('Zoomed Decipher K2');
        
        
        
        %% Write a header title in over all subplots.
        suptitle(['KEY SENSITIVITY ANALYSIS (DECIPHER) - Correlation: ' num2str(corrKeySensitivityDecipher, '%.4f')]);

        % Set the window size scale to screen size.
        set(sp, 'Position', get(0, 'Screensize'));
        
        % Turn off the plot visibility
        set(sp, 'Visible', 'Off');
        
        % Save all the subplots in the same frame.
        export_fig(sp, [paths{4} '/plotsSensitivityDecipher.png'], '-p0.05')

        % Close the window of frame plot.
        close(sp);
        
end