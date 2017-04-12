% FDA for CCA speaker-listener result
% 2017.1.9
% LJW : jx_ljw@163.com
% for speaker-listener experiment

%% timelag
Fs = 64;
% timelag = (-3000:500/32:3000)/(1000/Fs);
timelag = (-250:500/32:500)/(1000/Fs);
% timelag = 0 ;


%% path
path_name_CCA_SL = 'E:\DataProcessing\FDA_complex_feature\CCA-speaker-listener';
path_name_CCA = 'E:\DataProcessing\FDA_complex_feature\CCA';
path_name_mTRF = 'E:\DataProcessing\FDA_complex_feature\mTRF';

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat');

p = pwd;

for r = 1 : 15
    %% load data
    %     band_name = ' 0.1Hz-40Hz 64Hz';
    band_name_CCA_S_L = strcat(' 0.5Hz-40Hz 64Hz r rank',num2str(r));
    band_name_CCA = ' broadband 0.5-40Hz';
    band_name_mTRF = ' broadband 0.5-40Hz';
    
    cd(band_name_CCA_S_L(2:end));
    
    for j = 1 : length(timelag)
        data_name_CCA_S_L = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name_CCA_S_L,'.mat');
        load(strcat(path_name_CCA_SL,'\',band_name_CCA_S_L(2:end),'\',data_name_CCA_S_L));
        
        data_name_CCA = strcat('cca_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name_CCA,'.mat');
        load(strcat(path_name_CCA,'\',band_name_CCA(2:end),'\',data_name_CCA));
        
        data_name_mTRF = strcat('mTRF_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name_mTRF,'.mat');
        load(strcat(path_name_mTRF,'\',band_name_mTRF(2:end),'\',data_name_mTRF));
        
        
        predict_label_matrix = zeros(12,15);
        decoding_correct_or_not = zeros(12,15);% 1 ->correct;0->wrong
        
        for listener = 1 : 12
            
            for story = 1 : 15
                train_data_CCA = ...
                    [recon_AttendDecoder_audioA_train_cca{listener,story};...
                    recon_AttendDecoder_audioB_train_cca{listener,story};...
                    recon_UnattendDecoder_audioA_train_cca{listener,story};...
                    recon_UnattendDecoder_audioB_train_cca{listener,story}];
                
                train_data_CCA_S_L=...
                    [recon_AttendDecoder_speakerA_cca_train{listener,story};...
                    recon_AttendDecoder_speakerB_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerA_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerB_cca_train{listener,story}];
                
                train_data_mTRF = ... % attend and unattend decoder
                    [recon_AttendDecoder_audioA_corr_train{listener,story};...
                    recon_AttendDecoder_audioB_corr_train{listener,story};...
                    recon_UnattendDecoder_audioA_corr_train{listener,story};...
                    recon_UnattendDecoder_audioB_corr_train{listener,story}];
                
                train_data = [train_data_CCA; train_data_CCA_S_L;train_data_mTRF];
                labels = train_data_labels{listener,story}; % 1 ->attend;0->unattend
                
                % test data
                test_data_CCA = ... % attend and unattend decoder
                    [recon_AttendDecoder_audioA_cca(listener,story);...
                    recon_AttendDecoder_audioB_cca(listener,story);...
                    recon_UnattendDecoder_audioA_cca(listener,story);...
                    recon_UnattendDecoder_audioB_cca(listener,story)];
                
                test_data_CCA_S_L = ...
                    [recon_AttendDecoder_speakerA_cca(listener,story);...
                    recon_AttendDecoder_speakerB_cca(listener,story);...
                    recon_UnattendDecoder_speakerA_cca(listener,story);...
                    recon_UnattendDecoder_speakerB_cca(listener,story)];
                
                
                test_data_mTRF = ... % attend and unattend decoder
                    [recon_AttendDecoder_audioA_corr(listener,story);...
                    recon_AttendDecoder_audioB_corr(listener,story);...
                    recon_UnattendDecoder_audioA_corr(listener,story);...
                    recon_UnattendDecoder_audioB_corr(listener,story)];
                
                test_data = [test_data_CCA;test_data_CCA_S_L;test_data_mTRF];
                
                real_label =ListenA_Or_Not(story,listener);
                
                
                % FDA train
                disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
                [weights,intercept] = FDA_TRAIN(train_data,labels);
                test_label = FDA_TEST(test_data,weights,intercept);
                
                disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
                predict_label_matrix(listener,story)=test_label;
                if test_label == real_label
                    decoding_correct_or_not(listener,story) = 1;
                else
                    decoding_correct_or_not(listener,story) = 0;
                end
            end
        end
        
        % plot
        decoding_acc = mean(decoding_correct_or_not,2);
        plot_name = strcat('Three method decoding result+',num2str((1000/Fs)*timelag(j)),'ms',band_name_CCA_S_L,'.jpg');
        plot(decoding_acc*100);
        hold on;
        plot(repmat(mean(decoding_acc*100),[1 12]),'k--');
        title(plot_name(1:end-4));
        xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
        legend('Individual acc','Mean acc')
        saveas(gcf,plot_name);
        close
        
        
        save_name = strcat('Three_method_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name_CCA_S_L,'.mat');
        save(save_name,'decoding_correct_or_not','predict_label_matrix');
        
        
    end
    
    cd(p);
end