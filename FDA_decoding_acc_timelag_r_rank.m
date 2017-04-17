%% FDA decoding acc result timelag plot

%% timelag

% timelag = -200:25:500;
Fs = 64;

timelag = (-250:500/32:500)/(1000/Fs);
% timelag = (-1000:500/32:1000)/(1000/Fs);

decoding_acc = zeros(1,length(timelag));
Decoding_acc_ttest_result = zeros(1,length(timelag));

for r = 11:34
    band_name = strcat(' 0.5Hz-40Hz after zscore10 64Hz r rank',num2str(r));
    
    %% CCA speaker-listener plot
            p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA_speaker_listener\',band_name(2:end));
    %     p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA_speaker_listener\train_set\',band_name(2:end));
    %     p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\mTRF_CCA_SL_sound_EEG\',band_name(2:end));
%     p =strcat( 'E:\DataProcessing\FDA_complex_feature\decoding_result\CCA_SL_sound_EEG\',band_name(2:end));
    
    % category = 'CCA_speaker_listener_EEG';
    
    for  j = 1 : length(timelag)
        % load data
        %     datapath = strcat(p,'\',category,'\',band_name{bandName}(2:end));
        datapath = p;
        dataName = strcat('cca_S-L_EEG_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
%          dataName = strcat('cca_S-L_cca_sound_EEG_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        
        %         dataName = strcat('cca_S-L_EEG_decoding_result_train_set+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        
        %         dataName = strcat('Three_method_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        load(strcat(datapath,'\',dataName));
        
        % ttest
        Decoding_acc_ttest_result(j) = ttest(mean(decoding_correct_or_not,2),0.5);
        decoding_acc(j)= mean(mean(decoding_correct_or_not,2));
        
    end
    
    figure; plot((1000/Fs)*timelag,decoding_acc*100,'k');
    hold on;plot((1000/Fs)*timelag(Decoding_acc_ttest_result>0),decoding_acc(Decoding_acc_ttest_result>0)*100,'r*');
    xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
    saveName3 = strcat('Decoding-Acc across all time-lags using CCA-SL method',band_name,'.jpg');
    title(saveName3(1:end-4));
    legend('feature:CCA speaker-listener','significant ¡Ù 50%');ylim([30,100]);
    saveas(gcf,saveName3);
    close
    
end

