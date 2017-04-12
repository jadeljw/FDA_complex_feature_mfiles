%% comparison of r-values
clear;
close all;

%re-organize into A and B based definition
load('ListenA_Or_Not.mat');
% load('[rÖµÅÐ¶Ï]corr_S-L_EEG_result+375ms 0.5Hz-40Hz 64Hz r rank1.mat');
% load('E:\DataProcessing\correlation_cca_mTRF\mTRF\64Hz 0.1-40Hz lambda 4096\mTRF_sound_EEG_result+312.5ms 64Hz 0.1-40Hz lambda 4096.mat');
load('E:\DataProcessing\correlation_cca_mTRF\mfiles\mTRF_sound_EEG_result+250ms 64Hz 0.5-40Hz lambda 4096.mat');

%prediction within training & across to testing
R_A_AttendDecoder = zeros(15,15,12);
R_A_UnattendDecoder = zeros(15,15,12);
R_B_AttendDecoder = zeros(15,15,12);
R_B_UnattendDecoder = zeros(15,15,12);

for i = 1:12 %subject
    for j = 1:15 %story to be tested
        story_sel = setdiff(1:15,j);
        if(ListenA_Or_Not(j,i)==1)%attending A
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_corr_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_corr(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_corr_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_corr(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_corr_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_corr(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_corr_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_corr(i,j);
        else%attending B
            R_A_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_unattend_corr_train(:,i,j);
            R_A_AttendDecoder(j,j,i) = recon_AttendDecoder_unattend_corr(i,j);
            R_A_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_unattend_corr_train(:,i,j);
            R_A_UnattendDecoder(j,j,i) = recon_UnattendDecoder_unattend_corr(i,j);
            R_B_AttendDecoder(story_sel,j,i) = recon_AttendDecoder_attend_corr_train(:,i,j);
            R_B_AttendDecoder(j,j,i) = recon_AttendDecoder_attend_corr(i,j);
            R_B_UnattendDecoder(story_sel,j,i) = recon_UnattendDecoder_attend_corr_train(:,i,j);
            R_B_UnattendDecoder(j,j,i) = recon_UnattendDecoder_attend_corr(i,j);            
        end
        
        acc_AttendDecoder_train(i,j) = length(find(squeeze(recon_AttendDecoder_attend_corr_train(:,i,j))>squeeze(recon_AttendDecoder_unattend_corr_train(:,i,j))));
        acc_AttendDecoder_test(i,j) = recon_AttendDecoder_attend_corr(i,j)>recon_AttendDecoder_unattend_corr(i,j);
        acc_UnattendDecoder_train(i,j) = length(find(squeeze(recon_UnattendDecoder_unattend_corr_train(:,i,j))>squeeze(recon_UnattendDecoder_attend_corr_train(:,i,j))));
        acc_UnattendDecoder_test(i,j) = recon_UnattendDecoder_unattend_corr(i,j)>recon_UnattendDecoder_attend_corr(i,j);
    end
end

mean_acc_AttendDecoder_train = mean(acc_AttendDecoder_train./14,2);
mean_acc_UnattendDecoder_train = mean(acc_UnattendDecoder_train./14,2);
mean_acc_AttendDecoder_test = sum(acc_AttendDecoder_test,2)./15;
mean_acc_UnattendDecoder_test = sum(acc_UnattendDecoder_test,2)./15;

%% classification

