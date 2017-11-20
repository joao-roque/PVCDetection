%---------------------------- IM - 2014/15
clear
close all
LIST={...
    'afdb_file-04043_episode-1'
    'afdb_file-04043_episode-2'
    'afdb_file-04043_episode-3'
    'afdb_file-04043_episode-4'
    'afdb_file-04048_episode-1'
    'afdb_file-04048_episode-2'
    'afdb_file-04048_episode-3'
    'afdb_file-04746_episode-1'
    'afdb_file-04746_episode-2'
    'afdb_file-04746_episode-3'
    'afdb_file-05261_episode-1'
    'afdb_file-05261_episode-2'
    'afdb_file-05261_episode-3'
    'afdb_file-05261_episode-4'
    'afdb_file-08219_episode-1'
    'afdb_file-08219_episode-2'
    'afdb_file-08219_episode-3'
    'afdb_file-08219_episode-4'
    };

fs=250;

for list=1:length(LIST)
    
    close all
    cmd=['load ' char(LIST(list)) ];
    eval(cmd);
    ECG=DAT.ecg;
    ANT=DAT.class;
    iniA=DAT.annot(1);
    endA=DAT.annot(2);
    N=length(ECG);
    
    figure(1)
    plot(1:N, ECG, 'g', 1:N, ANT, 'r');
    legend('ECG','AF')
    xlabel(LIST(list))
    pause
    
    
    
end
