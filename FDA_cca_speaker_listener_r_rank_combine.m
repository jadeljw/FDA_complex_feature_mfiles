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

for j = 1 : length(timelag)
    
    dataSet = ' 0.5Hz-40Hz 64Hz r rank 1-10';
    mkdir(dataSet(2:end));
    cd(dataSet(2:end));
    
    train_data_combine = cell(12,15);
    test_data_combine = cell(12,15);
    predict_label_matrix = zeros(12,15);
    decoding_correct_or_not = zeros(12,15);
    
    for r = 1 : 10
        %% load data
        %     band_name = ' 0.5Hz-40Hz 64Hz';
        band_name = strcat(' 0.5Hz-40Hz after zscore10 64Hz r rank',num2str(r));
        
        data_name = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        load(strcat(path_name,'\',band_name(2:end),'\',data_name));
        % 1 ->correct;0->wrong
        
        % combine data
        for listener = 1 : 12
            for story = 1 : 15
                train_data = ...
                    [recon_AttendDecoder_speakerA_cca_train{listener,story};...
                    recon_AttendDecoder_speakerB_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerA_cca_train{listener,story};...
                    recon_UnattendDecoder_speakerB_cca_train{listener,story}];
                % 1 ->attend;0->unattend
                train_data_combine{listener,story} = [train_data_combine{listener,story};train_data];
                % test data
                test_data = ...
                    [recon_AttendDecoder_speakerA_cca(listener,story);...
                    recon_AttendDecoder_speakerB_cca(listener,story);...
                    recon_UnattendDecoder_speakerA_cca(listener,story);...
                    recon_UnattendDecoder_speakerB_cca(listener,story)];
                
                test_data_combine{listener,story} = [test_data_combine{listener,story};test_data];
            end
        end
        
    end
    
    
    for listener = 1 : 12
        for story = 1 : 15
            
            % label
            labels = train_data_labels{listener,story};
            real_label =ListenA_Or_Not(story,listener);
            
            % FDA train
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            [weights,intercept] = FDA_TRAIN(train_data_combine{listener,story},labels);
            test_label = FDA_TEST(test_data_combine{listener,story},weights,intercept);
            
            % FDA test
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
    plot_name = strcat('cca S-L EEG decoding result+',num2str((1000/Fs)*timelag(j)),'ms',dataSet,'.jpg');
    plot(decoding_acc*100);
    hold on;
    plot(repmat(mean(decoding_acc*100),[1 12]),'k--');
    title(plot_name(1:end-4));
    xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
    legend('Individual acc','Mean acc')
    saveas(gcf,plot_name);
    close
    
    
    save_name = strcat('cca_S-L_EEG_decoding_result+',num2str((1000/Fs)*timelag(j)),'ms',dataSet,'.mat');
    save(save_name,'decoding_correct_or_not','predict_label_matrix');
    
    cd(p);
end