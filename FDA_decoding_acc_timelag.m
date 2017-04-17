%% FDA decoding acc result timelag plot

%% timelag

% timelag = -200:25:500;
Fs = 64;

timelag = (-250:500/32:500)/(1000/Fs);
% timelag = (-1000:500/32:1000)/(1000/Fs);

decoding_acc = zeros(1,length(timelag));
Decoding_acc_ttest_result = zeros(1,length(timelag));
% band_name = ' broadband 0.5-40Hz after zscore';
band_name = ' 0.5Hz-40Hz 64Hz r rank 1-10';


%% CCA speaker-listener plot
p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA_speaker_listener\',band_name(2:end));
% category = 'CCA_speaker_listener_EEG';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category,'\',band_name{bandName}(2:end));
    datapath = p;
    dataName = strcat('cca_S-L_EEG_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
    % ttest
    Decoding_acc_ttest_result(j) = ttest(mean(decoding_correct_or_not,2),0.5);
    decoding_acc(j)= mean(mean(decoding_correct_or_not,2));
    
end

figure; plot((1000/Fs)*timelag,decoding_acc*100,'k');
hold on;plot((1000/Fs)*timelag(Decoding_acc_ttest_result>0),decoding_acc(Decoding_acc_ttest_result>0)*100,'r*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Acc across all time-lags using CCA speaker listener method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('CCA feature','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close

%% mTRF plot
p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\mTRF\',band_name(2:end));
% category = 'CCA_speaker_listener_EEG';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category,'\',band_name{bandName}(2:end));
    datapath = p;
    dataName = strcat('mTRF_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
    % ttest
    Decoding_acc_ttest_result(j) = ttest(mean(decoding_correct_or_not,2),0.5);
    decoding_acc(j)= mean(mean(decoding_correct_or_not,2));
    
end

figure; plot((1000/Fs)*timelag,decoding_acc*100,'k');
hold on;plot((1000/Fs)*timelag(Decoding_acc_ttest_result>0),decoding_acc(Decoding_acc_ttest_result>0)*100,'r*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Acc across all time-lags using mTRF method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('mTRF feature','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close

%% CCA
p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA\',band_name(2:end));
% category = 'CCA_speaker_listener_EEG';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category,'\',band_name{bandName}(2:end));
    datapath = p;
    dataName = strcat('CCA_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
    % ttest
    Decoding_acc_ttest_result(j) = ttest(mean(decoding_correct_or_not,2),0.5);
    decoding_acc(j)= mean(mean(decoding_correct_or_not,2));
    
end

figure; plot((1000/Fs)*timelag,decoding_acc*100,'k');
hold on;plot((1000/Fs)*timelag(Decoding_acc_ttest_result>0),decoding_acc(Decoding_acc_ttest_result>0)*100,'r*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Acc across all time-lags using CCA sound EEG method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('CCA sound envelope feature','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close

%% CCA train set
p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA\train_set\',band_name(2:end));
% category = 'CCA_speaker_listener_EEG';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category,'\',band_name{bandName}(2:end));
    datapath = p;
    dataName = strcat('CCA_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
    % ttest
    Decoding_acc_ttest_result(j) = ttest(mean(decoding_correct_or_not_mean,2),0.5);
    decoding_acc(j)= mean(mean(decoding_correct_or_not_mean,2));
    
end

figure; plot((1000/Fs)*timelag,decoding_acc*100,'k');
hold on;plot((1000/Fs)*timelag(Decoding_acc_ttest_result>0),decoding_acc(Decoding_acc_ttest_result>0)*100,'r*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Acc across all time-lags using CCA sound EEG method train_set',band_name,'.jpg');
title(saveName3(1:end-4));
legend('CCA sound envelope feature','significant 』 50%','Location','southeast');ylim([30,100]);
saveas(gcf,saveName3);
close