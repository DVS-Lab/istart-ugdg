
clear all
close all
clc

% This code takes the EVfiles and divides the files into 3 separate EVs. 
% This is for plotting purposes only, to be run through L1/L2 and then to
% help visualize the parametric modulators.

% Daniel Sazhin
% 03/03/2023
% Neuroeconomics Lab
% Temple University

% UG- Receipient was added for experimental purposes. Note that some files
% contain less than 2 events, so this needs to be debugged further before
% plotting.

%% Set directories

Maindir = '/data/projects/istart-ugdg/';
EVdir = string([Maindir 'derivatives/fsl/EVfiles/']);
Sub_list = readtable([Maindir 'code/newsubs.txt']); % Import Subject list.

%% Loop through the subjects in DG

Missing = [];

for ii = 1:length(Sub_list.Var1)
    subj = string(Sub_list.Var1(ii));

    % Find EV directory for subject

    sub_evdir = EVdir + 'sub-' + subj + '/ugdg_GLM3/';

    % Open run file

    for run = 1:2

        saveBin1 = [];
        saveBin2 = [];
        saveBin3 = [];

        openfile = readtable(sub_evdir + 'run-01_dec_dg-prop_pmod_choice_pmod.txt');
        %Bins = quantile(openfile.Var3, 4);
        Bins = prctile(openfile.Var3, [33.3,66.67]);

        Bin1 = Bins(1);
        Bin2 = Bins(2);

        for jj = 1:length(openfile.Var3)
            allcols= [openfile.Var1(jj), openfile.Var2(jj), 1];
            row = openfile.Var3(jj);
            if row <= Bin1
                saveBin1 = [saveBin1; allcols];
            end
            if row >= Bin1 && row < Bin2
                saveBin2 = [saveBin2; allcols];
            end
            if row >= Bin2
                saveBin3 = [saveBin3; allcols];
            end
        end

        % Flag empty bins for debugging

        [N,~] = size(saveBin1);
        if round(N) < 2
            Missing = [Missing; ['saveBin1'  subj  run]];
        end

        [N,~] = size(saveBin2);
        if round(N) < 2
            Missing = [Missing; ['saveBin2'  subj  run]];
        end

        [N,~] = size(saveBin3);
        if round(N) < 2
            Missing = [Missing; ['saveBin3'  subj  run]];
        end

        % Save Bins as Categorical EV files.

        run = string(run);

        fname = sprintf('run-0' + run + '_dec_dg-prop_pmod_choice_pmod_bin1.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin1,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_dg-prop_pmod_choice_pmod_bin2.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin2,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_dg-prop_pmod_choice_pmod_bin3.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin3,'delimiter','\t');

    end
end

Missing

%% Loop through the subjects in UGP

Missing = [];

for ii = 1:length(Sub_list.Var1)
    subj = string(Sub_list.Var1(ii));

    % Find EV directory for subject

    sub_evdir = EVdir + 'sub-' + subj + '/ugdg_GLM3/';

    % Open run file

    for run = 1:2

        saveBin1 = [];
        saveBin2 = [];
        saveBin3 = [];

        openfile = readtable(sub_evdir + 'run-01_dec_ug-prop_pmod_choice_pmod.txt');
        %Bins = quantile(openfile.Var3, 4);
        Bins = prctile(openfile.Var3, [33.3,66.67]);

        Bin1 = Bins(1);
        Bin2 = Bins(2);

        for jj = 1:length(openfile.Var3)
            allcols= [openfile.Var1(jj), openfile.Var2(jj), 1];
            row = openfile.Var3(jj);
            if row <= Bin1
                saveBin1 = [saveBin1; allcols];
            end
            if row >= Bin1 && row < Bin2
                saveBin2 = [saveBin2; allcols];
            end
            if row >= Bin2
                saveBin3 = [saveBin3; allcols];
            end
        end

        % Flag empty bins for debugging

        [N,~] = size(saveBin1);
        if round(N) < 2
            Missing = [Missing; ['saveBin1'  subj  run]];
        end

        [N,~] = size(saveBin2);
        if round(N) < 2
            Missing = [Missing; ['saveBin2'  subj  run]];
        end

        [N,~] = size(saveBin3);
        if round(N) < 2
            Missing = [Missing; ['saveBin3'  subj  run]];
        end

        % Save Bins as Categorical EV files.

        run = string(run);

        fname = sprintf('run-0' + run + '_dec_ug-prop_pmod_choice_pmod_bin1.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin1,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_ug-prop_pmod_choice_pmod_bin2.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin2,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_ug-prop_pmod_choice_pmod_bin3.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin3,'delimiter','\t');

    end
end

Missing

%% Loop through the subjects in UGR

Missing = [];

for ii = 1:length(Sub_list.Var1)
    subj = string(Sub_list.Var1(ii));

    % Find EV directory for subject

    sub_evdir = EVdir + 'sub-' + subj + '/ugdg_GLM3/';

    % Open run file

    for run = 1:2

        saveBin1 = [];
        saveBin2 = [];
        saveBin3 = [];

        openfile = readtable(sub_evdir + 'run-01_dec_ug-resp_pmod_choice_pmod.txt');
        %Bins = quantile(openfile.Var3, 4);
        Bins = prctile(openfile.Var3, [33.3,66.67]);

        Bin1 = Bins(1);
        Bin2 = Bins(2);

        for jj = 1:length(openfile.Var3)
            allcols= [openfile.Var1(jj), openfile.Var2(jj), 1];
            row = openfile.Var3(jj);
            if row <= Bin1
                saveBin1 = [saveBin1; allcols];
            end
            if row >= Bin1 && row < Bin2
                saveBin2 = [saveBin2; allcols];
            end
            if row >= Bin2
                saveBin3 = [saveBin3; allcols];
            end
        end

        % Flag empty bins for debugging

        [N,~] = size(saveBin1);
        if round(N) < 2
            Missing = [Missing; ['saveBin1'  subj  run]];
        end

        [N,~] = size(saveBin2);
        if round(N) < 2
            Missing = [Missing; ['saveBin2'  subj  run]];
        end

        [N,~] = size(saveBin3);
        if round(N) < 2
            Missing = [Missing; ['saveBin3'  subj  run]];
        end

        % Save Bins as Categorical EV files.

        run = string(run);

        fname = sprintf('run-0' + run + '_dec_ug-resp_pmod_choice_pmod_bin1.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin1,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_ug-resp_pmod_choice_pmod_bin2.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin2,'delimiter','\t');

        fname = sprintf('run-0' + run + '_dec_ug-resp_pmod_choice_pmod_bin3.txt');
        output = fullfile(sub_evdir,fname);
        dlmwrite(output, saveBin3,'delimiter','\t');

    end
end

Missing