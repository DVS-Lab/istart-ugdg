clear all
close all
clc

%% 


maindir = '/data/projects/istart/';
usedir = '/data/projects/istart-data/';
    
% This is the final bids converter used.

% 11-18-21 | This is the code I am using  for the bids converter.

% Plan now is to use the BIDs converter for only the simple regressors. Ie:
% Export the endowments (cue onsets) and the decision phases
% (accept/reject), choices, and missed trials.

% 03-10-21 add decision parametric modulators (demeaned proportions of
% offer).

% 03/15/23: made into a script instead of a function.

subjects = [1003
1004
1006
1009
1010
1011
1012
1013
1015
1016
1019
1021
1242
1243
1244
1245
1247
1248
1249
1251
1253
1255
1276
1282
1286
1294
1300
1301
1302
1303
3101
3116
3122
3125
3140
3143
3152
3164
3166
3167
3170
3173
3175
3176
3189
3190
3199
3200
3206
3210
3212
3218
3220
3223];

for ii = 1:length(subjects)

    try

    subj = subjects(ii)

for r = 0:1
    
   
    % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
    fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,r)); % Psychopy taken out from Logs to make work for now.
    if exist(fname,'file')
        fid = fopen(fname,'r');
    else
        fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
        continue;
    end
    C = textscan(fid,repmat('%f',1,23),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
    fclose(fid);
 
    
    % "Feedback" is the offer value (out of $20)
    
    decision_onset = C{16};
    endowment_onset = C{12};
    endowment_offset = C{13};
    onset = C{11};
    RT = C{18};
    duration = C{21};
    % test
    Block = C{3};
    Block = round(Block);
    Endowment = C{4};
    response = C{17};
    response = round(response);
    L_Option = C{7};
    R_Option = C{8};
    L_Option = round(L_Option);
    R_Option = round(R_Option);
    
   fname = sprintf('sub-%03d_task-ugdg_run-%02d_events.tsv',subj,r+1); % making compatible with bids output
    output = fullfile(usedir,'bids',['sub-' num2str(subj)],'func');
    if ~exist(output,'dir')
        mkdir(output)
    end
    myfile = fullfile(output,fname);
    fid = fopen(myfile,'w');
    fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tEndowment\tEndowment_pmod\tDecision\tDecision_pmod\n');
    
    
    % We need to split up the endowments per the blocks. Then take the
    % mean of those blocks. We do this to generate the parametric
    % regressors, which require the demeaned endowment.
    
    
    Block1Mean = [];
    Block2Mean = [];
    Block3Mean = [];
    
    for ii = 1:length(Block)
        
        if (Block(ii) == 1)
            Block1Mean = [Block1Mean;Endowment(ii)];
            
        elseif (Block(ii) == 2)
            Block2Mean = [Block2Mean;Endowment(ii)];
            
        elseif (Block(ii) == 3)
            Block3Mean = [Block3Mean;Endowment(ii)];
            
        end
        
    end
    
    Block1Mean = mean(Block1Mean);
    Block2Mean = mean(Block2Mean);
    Block3Mean = mean(Block3Mean);

%% Find the means of decision per conditions.

% Make a table that has all the offers split per condition. 

UGR=[];
DGP=[];
UGP=[];


 for t = 1:length(Block)
        
        % 2 is reject
        % 3 is accept
        % 999 is miss
        
        % L_option
        % R_Option
        
        if Block(t) == 3
            save = [];
            if response(t) == 2
                if round(L_Option(t)) > 0
                    save = [Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)];
                else
                    save = [0, L_Option(t)/Endowment(t)];
                end

                UGR= [UGR; save]; 
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0
                    save = [Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)];
                else
                    save = [0, R_Option(t)/Endowment(t)];
                end
                UGR = [UGR; save];
            end
        end
        
        if Block(t) == 2
            save = [];
            if response(t) == 2
                if round(L_Option(t)) > 0
                    save = [Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)];
                else
                    save = [0, L_Option(t)/Endowment(t)];
                end
                
                DGP = [DGP; save];
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0
                    save = [Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)];
                else
                    save = [0, R_Option(t)/Endowment(t)];
                end
                DGP = [DGP; save];
            end
        end
        
        if Block(t) == 1
            save = [];
            if response(t) == 2
                if round(L_Option(t)) > 0
                    save = [Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)];
                else
                    save = [0, L_Option(t)/Endowment(t)];
                end

                UGP = [UGP; save]; 
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0
                    save = [Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)];
                else
                    save = [0, R_Option(t)/Endowment(t)];
                end
                UGP = [UGP; save];
            end
        end
end
        
% Find the means

UGP_mean = mean(UGP(:,2));
DGP_mean = mean(DGP(:,2));
UGR_mean = mean(UGR(:,2));
       
    
    
 %% Adding in the cue onsets for parametric model
    
    for t = 1:length(Block)
        if (Block(t) == 1)
            trial_type = 'cue_dict_pmod';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\t%s\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),round(Endowment(t)-Block1Mean),'n/a','n/a');
        elseif (Block(t) == 2)
            trial_type = 'cue_ug-resp_pmod';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\t%s\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),round(Endowment(t)-Block2Mean),'n/a','n/a');
        elseif (Block(t) == 3)
            trial_type = 'cue_ug-prop_pmod';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\t%s\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),round(Endowment(t)-Block3Mean),'n/a','n/a');
        else
            keyboard
        end
        
        
    end
    
   
    
    
    %% Populate the parametric regressors.
    
    % Block 1 = DG-P
    % Block 2 = UG-P
    % Block 3 = UG-R
    
    for t = 1:length(onset)
        
        
        if (Block(t) == 1)
            trial_type = 'dec_ug-prop_pmod';
        elseif (Block(t) == 2)
            trial_type = 'dec_dg-prop_pmod';
            
        elseif (Block(t) == 3)
            trial_type = 'dec_ug-resp_pmod';
        else
            keyboard
        end
        
        % 2 is reject
        % 3 is accept
        % 999 is miss
        
        % L_option
        % R_Option
        
        if response(t) == 999
            fprintf(fid,'%f\t%f\t%s\t%s\t%d\t%s\t%s\t%s\n',decision_onset(t),4,'missed_trial','n/a',Endowment(t),'n/a','n/a','n/a');
        end
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_accept'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGR_mean);
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_reject'],RT(t),Endowment(t),'n/a',0, R_Option(t)/Endowment(t)- UGR_mean);
                end
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_accept'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGR_mean);
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_reject'],RT(t),Endowment(t),'n/a',0, R_Option(t)/Endowment(t)- UGR_mean);
                end
            end
        end
%         
%         if Block(t) == 2
%             if response(t) == 2
%                 if L_Option(t) > R_Option(t);
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%dt%d\n',decision_onset(t),RT(t),[trial_type '_more'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGP_mean);
%                 else
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%dt%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGP_mean);
%                 end
%             end
%             
%             
%             if response(t) == 3
%                 if L_Option(t) > R_Option(t);
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGP_mean);
%                 else
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_more' ],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGP_mean);
%                 end
%             end
%         end
%         
%         if Block(t) == 1
%             if response(t) == 2
%                 if L_Option(t) > R_Option(t);
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_more' ],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- DGP_mean);
%                 else
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- DGP_mean);
%                 end
%             end
%             
%             if response(t) == 3
%                 if L_Option(t) > R_Option(t);
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- DGP_mean);
%                 else
%                     fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_more'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- DGP_mean);
%                 end
%             end
       
        
        %% Add choice only regessors
        
        % These regressors collapse the decision phase into simply "choice". It
        % eliminates More/Less or Accept/Reject. This is to deal with the ceiling
        % effect associated with "perfectly rational" behavior, if subjects always
        % choose a given option.
        
          if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_option_presented'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGR_mean); % accepted offer
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_option_presented'],RT(t),Endowment(t),'n/a',0, R_Option(t)/Endowment(t)- UGR_mean); % rejected offer
                end
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_option_presented'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGR_mean); % accepted offer
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_option_presented'],RT(t),Endowment(t),'n/a',0, L_Option(t)/Endowment(t)- UGR_mean); % rejected offer
                end
            end
        end
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGR_mean);
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',0, L_Option(t)/Endowment(t)- UGR_mean);
                end
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGR_mean);
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',0, R_Option(t)/Endowment(t)- UGR_mean);
                end
            end
        end
        
        
        if Block(t) == 2
            
            if response(t) == 2
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- UGP_mean);
            end
            
            
            if response(t) == 3
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- UGP_mean);
            end
        end
        
        if Block(t) == 1
            if response(t) == 2
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice' ],RT(t),Endowment(t),'n/a',Endowment(t) - L_Option(t), L_Option(t)/Endowment(t)- DGP_mean);
            end
            
            if response(t) == 3
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\t%d\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a',Endowment(t) - R_Option(t), R_Option(t)/Endowment(t)- DGP_mean);
            end
            
        end
        
        
    end
end
    
    

    % for t = 1:length(onset);
    %
    %     if Block(t) == 1
    
    % catch ME
    %     disp(ME.message)
    %     msg = sprintf('check line %d', ME.stack.line);
    %     disp(msg);
    %     keyboard
    
    fopen(fid); % Changed from fclose
    
    catch
        ('Debug')
end
    
end
