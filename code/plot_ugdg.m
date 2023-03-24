function plot_ugdg(name, roidir, rois, models, cope_DGP, cope_UGP, cope_UGR, type, ID_Measure_1, ID_Measure_2, ID_Measure_1_name, ID_Measure_2_name)
    
% This function plots results in the ISTART ugdg task. It employs DVS
% plotting tool barweb_dvs2.m. This code generates the inputs to make the
% plots and scatter plots for this project.

% Daniel Sahin
% 03/31/2022
% Temple University
% DVS Lab

close all
clc

% import mlreportgen.ppt.* 
% 
% ppt = Presentation(name '.pptx');
% titleSlide = add(ppt, 'Title Slide');
% replace(titleslide, 'Title', name);
% pictureslide = add(ppt, 'Title and Picture');

    output = [roidir '/results/' name];
    
    if exist(output) == 7
        rmdir(output, 's');
        mkdir(output);
    else 
        mkdir(output); % set name
    end
    
    % Make a file for test results
    outputdir = [roidir '/results/' name '/'];
    file = ([roidir '/results/' name '/' name]);
    [L] = isfile(file);
    if L == 1
        delete(file)
    end
    
    diary(file)
    
    % loop through rois
  
    diary on
    
    for r = 1:length(rois)
        roi = rois{r} ;
        for m = 1:length(models)
            model = models{m};
           
            DGP = load(strjoin([roidir,roi,model,cope_DGP], ''));
            UGP= load(strjoin([roidir,roi,model,cope_UGP], ''));
            UGR= load(strjoin([roidir,roi,model,cope_UGR], ''));

            figure, barweb_dvs2([mean(DGP); mean(UGP); mean(UGR)], [std(DGP)/sqrt(length(DGP)); std(UGP)/sqrt(length(UGP)); std(UGR)/sqrt(length(UGR))]);
            xlabel('Task Condition');
            xticks([0.75, 1, 1.25]);
            xticklabels({'DGP','UGP','UGR'});
            ylabel('BOLD Response');
            %legend({'DGP', 'UGP', 'UGR'},'Location','northeast');
            axis square;
            title([roi type]);
            outname = fullfile([outputdir roi model]);
            cmd = ['print -depsc ' outname];
            eval(cmd);
            saveas(gca, fullfile(outname), 'svg');
            
            % different from zero?
            disp([roi ' DGP different from zero?'])
            [h,p,ci,stats] = ttest(DGP)
            disp([roi ' UGP different from zero?'])
            [h,p,ci,stats] = ttest(UGP)
            disp([roi ' UGR different from zero?'])
            [h,p,ci,stats] = ttest(UGR)
            
            % Different from each other (DGP and UGP only)?
            disp([roi ' DGP > UGP?'])
            [h,p,ci,stats] = ttest(DGP, UGP)
            
             % Different from each other (UGR and UGP only)?
            disp([roi ' DGP > UGR?'])
            [h,p,ci,stats] = ttest(DGP, UGR)
            
            % Different from each other (DGP, UGP, and UGR)? 
            disp([roi ' DGP, UGP, and/or UGR different?'])
            [p,tb1,stats]=anova1([DGP,UGP,UGR])
         
            figure
            
            subplot(2,3,1)
            [R,P] = corrcoef(ID_Measure_1, DGP);
            scatter(ID_Measure_1, DGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ylabel (['DGP ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_1_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            
            subplot(2,3,2)
            [R,P] = corrcoef(ID_Measure_1, UGP);
            scatter(ID_Measure_1, UGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ylabel (['UGP ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_1_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            
            subplot(2,3,3)
            [R,P] = corrcoef(ID_Measure_1, UGR);
            scatter(ID_Measure_1, UGR, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ylabel (['UGR ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_1_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            
            subplot(2,3,4)
            [R,P] = corrcoef(ID_Measure_2, DGP);
            scatter(ID_Measure_2, DGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ax = gca;
            ax.FontSize = 12;
            ylabel (['DGP ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_2_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            set(gcf,'color','w');
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            
            subplot(2,3,5)
            [R,P] = corrcoef(ID_Measure_2, UGP);
            scatter(ID_Measure_2, UGP, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ylabel (['UGP ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_2_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            
            subplot(2,3,6)
            [R,P] = corrcoef(ID_Measure_2, UGR);
            scatter(ID_Measure_2, UGR, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
            ylabel (['UGR ' roi type], 'FontSize', 12);
            xlabel  (ID_Measure_2_name, 'FontSize', 12);
            i = lsline;
            i.LineWidth = 3.5;
            i.Color = [0 0 0];
            str=sprintf([' R=%1.2f' ' P=%1.2f'], [R(1,2) P(1,2)]);
            T = text(min(get(gca, 'xlim')), max(get(gca, 'ylim')), str);
            T.FontSize = 8;
            outname2= fullfile([outputdir roi model 'scatterplots']);
            saveas(gca, fullfile(outname2), 'svg');
            
        end  
    end
    
diary off
end
