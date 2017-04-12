%% comparison of r-values
clear;
close all;

%re-organize into A and B based definition
load('ListenA_Or_Not.mat');
load('[r÷µ≈–∂œ]cca_S-L_EEG_result+375ms 0.5Hz-40Hz 64Hz r rank1.mat');
% load('E:\DataProcessing\correlation_cca_mTRF\CCA\broadband 0.1-40Hz\cca_sound_EEG_result+296.875ms broadband 0.1-40Hz.mat')

%prediction within training & across to testing
R_A_AttendDecoder = zeros(15,15,12);
R_A_UnattendDecoder = zeros(15,15,12);
R_B_AttendDecoder = zeros(15,15,12);
R_B_UnattendDecoder = zeros(15,15,12);

for i = 1:12 %subject
    for j = 1:15 %story to be tested
        story_sel = setdiff(1:15,j);
        if(ListenA_Or_Not(j,i)==1)%attending A
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_cca_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_cca(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_cca_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_cca(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_cca_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_cca(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_cca_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_cca(i,j);
        else%attending B
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_cca_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_cca(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_cca_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_cca(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_cca_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_cca(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_cca_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_cca(i,j);            
        end
        
    end
end

mean_acc_AttendDecoder_train = mean(acc_AttendDecoder_train./14,2);
mean_acc_UnattendDecoder_train = mean(acc_UnattendDecoder_train./14,2);
mean_acc_AttendDecoder_test = sum(acc_AttendDecoder_test,2)./15;
mean_acc_UnattendDecoder_test = sum(acc_UnattendDecoder_test,2)./15;

%% comparison of r-values modification
clear;
close all;

%re-organize into A and B based definition
load('ListenA_Or_Not.mat');
load('[r÷µ≈–∂œ]cca_S-L_EEG_result+375ms 0.5Hz-40Hz 64Hz r rank1.mat');
% load('E:\DataProcessing\correlation_cca_mTRF\CCA\broadband 0.1-40Hz\cca_sound_EEG_result+296.875ms broadband 0.1-40Hz.mat')

%prediction within training & across to testing
R_A_AttendDecoder = zeros(15,15,12);
R_A_UnattendDecoder = zeros(15,15,12);
R_B_AttendDecoder = zeros(15,15,12);
R_B_UnattendDecoder = zeros(15,15,12);

for i = 1:12 %subject
    for j = 1:15 %story to be tested
        story_sel = setdiff(1:15,j);
        if(ListenA_Or_Not(j,i)==1)%attending A
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_cca_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_cca(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_cca_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_cca(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_cca_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_cca(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_cca_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_cca(i,j);
        else%attending B
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_cca_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_cca(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_cca_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_cca(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_cca_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_cca(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_cca_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_cca(i,j);            
        end
        
    end
end

