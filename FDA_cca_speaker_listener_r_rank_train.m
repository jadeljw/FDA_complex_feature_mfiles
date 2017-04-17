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
path_name = 'E:\DataProcessing\FDA_complex_feature\CCA-speaker-listener';

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat');

p = pwd;

for r = 11:34
    %% load data
    %     band_name = ' 0.5Hz-40Hz 64Hz';
    band_name = strcat(' 0.5Hz-40Hz after zscore10 64Hz r rank',num2str(r));
    mkdir(band_name(2:end));
    cd(band_name(2:end));
    
    for j = 1 : length(timelag)
        data_name = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        load(strcat(path_name,'\',band_name(2:end),'\',data_name));
        predict_label_matrix = cell(12,15);
        decoding_correct_or_not = cell(12,15);% 1 ->correct;0->wrong
        decoding_correct_or_not_mean = zeros(12,15);
        
        for listener = 1 : 12
            
            for story = 1 : 15
                
                train_data = ...
                    [recon_AttendDecoder_speakerA_cca_train{listener,story};...
                    recon_AttendDecoder_speakerB_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerA_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerB_cca_train{listener,story}];
                labels = train_data_labels{listener,story}; % 1 ->attend;0->unattend
                
                
                for train_index = 1 : 14
                    % test data
                    test_data = ...
                        [recon_AttendDecoder_speakerA_cca_train{listener,story}(train_index);...
                        recon_AttendDecoder_speakerB_cca_train{listener,story}(train_index);...
                        recon_UnattendDecoder_speakerA_cca_train{listener,story}(train_index);...
                        recon_UnattendDecoder_speakerB_cca_train{listener,story}(train_index)];
                    real_label =train_data_labels{listener,story}(train_index);
                    
                    
                    % FDA train
                    disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),' train story ',num2str(train_index),'...'));
                    [weights,intercept] = FDA_TRAIN(train_data,labels);
                    test_label = FDA_TEST(test_data,weights,intercept);
                    
                    disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
                    predict_label_matrix{listener,story}(train_index)=test_label;
                    if test_label == real_label
                        decoding_correct_or_not{listener,story}(train_index) = 1;
                    else
                        decoding_correct_or_not{listener,story}(train_index) = 0;
                    end
                end
                
                decoding_correct_or_not_mean(listener,story) = mean(decoding_correct_or_not{listener,story});
            end
        end
        
        % plot
        decoding_acc_mean = mean(decoding_correct_or_not_mean,2);
        plot_name = strcat('cca S-L EEG decoding result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.jpg');
        plot(decoding_acc_mean*100);
        hold on;
        plot(repmat(mean(decoding_acc_mean*100),[1 12]),'k--');
        title(plot_name(1:end-4));
        xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([60,100]);
        legend('Individual acc','Mean acc')
        saveas(gcf,plot_name);
        close
        
        
        save_name = strcat('cca_S-L_EEG_decoding_result_train_set+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        save(save_name,'decoding_correct_or_not','predict_label_matrix','decoding_correct_or_not_mean');
        
        
    end
    
    cd(p);
end