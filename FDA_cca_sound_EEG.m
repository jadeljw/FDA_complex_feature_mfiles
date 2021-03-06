% FDA for CCA speaker-listener result
% 2017.1.9
% LJW : jx_ljw@163.com
% for speaker-listener experiment

%% timelag
Fs = 64;
% timelag = (-3000:500/32:3000)/(1000/Fs);
% timelag = (-250:500/32:500)/(1000/Fs);
timelag = (-250:500/32:500);
% timelag = 0 ;


%% path
path_name = 'E:\DataProcessing\FDA_complex_feature\CCA';

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat');

%% load data


for j = 1 : length(timelag)
    band_name = ' broadband central 0.5-40Hz after zscore';
    
    data_name = strcat('cca_sound_EEG_result+',num2str(timelag(j)),'ms',band_name,'.mat');
    load(strcat(path_name,'\',band_name(2:end),'\',data_name));
    predict_label_matrix = zeros(12,15);
    decoding_correct_or_not = zeros(12,15);% 1 ->correct;0->wrong
    
    for listener = 1 : 12
        
        for story = 1 : 15
            
            train_data = ... % attend and unattend decoder
                [recon_AttendDecoder_audioA_train_cca{listener,story};...
                recon_AttendDecoder_audioB_train_cca{listener,story};...
                recon_UnattendDecoder_audioA_train_cca{listener,story};...
                recon_UnattendDecoder_audioB_train_cca{listener,story}];
            
%             train_data = ...% attend decoder
%                 [recon_AttendDecoder_audioA_train_cca{listener,story};...
%                 recon_AttendDecoder_audioB_train_cca{listener,story}];
            
%              train_data = ...% unattend decoder
%                 [recon_UnattendDecoder_audioA_train_cca{listener,story};...
%                 recon_UnattendDecoder_audioB_train_cca{listener,story}];
            
            labels = train_data_labels{listener,story}; % 1 ->attend;0->unattend
            
            % test data
            test_data = ... % attend and unattend decoder
                 [recon_AttendDecoder_audioA_cca(listener,story);...
                recon_AttendDecoder_audioB_cca(listener,story);...
                recon_UnattendDecoder_audioA_cca(listener,story);...
                recon_UnattendDecoder_audioB_cca(listener,story)];
            
%              test_data = ...% attend decoder
%                  [recon_AttendDecoder_audioA_cca(listener,story);...
%                 recon_AttendDecoder_audioB_cca(listener,story)];
            
%              test_data = ...% unattend decoder
%                  [recon_UnattendDecoder_audioA_cca(listener,story);...
%                 recon_UnattendDecoder_audioB_cca(listener,story)];
            
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
    
    
%     band_name = ' broadband 0.5-40Hz long attend decoder';
    % plot
    decoding_acc = mean(decoding_correct_or_not,2);
    plot_name = strcat('CCA sound EEG decoding result+',num2str(timelag(j)),'ms',band_name,'.jpg');
    plot(decoding_acc*100);
    hold on;
    plot(repmat(mean(decoding_acc*100),[1 12]),'k--');
    title(plot_name(1:end-4));
    xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
    legend('Individual acc','Mean acc')
    saveas(gcf,plot_name);
    close
    
    
    save_name = strcat('CCA_sound_EEG_result+',num2str(timelag(j)),'ms',band_name,'.mat');
    save(save_name,'decoding_correct_or_not','predict_label_matrix');
    
    
end