%---------------------------- IM - 2014/15
clear
close all
list={...
    'DPVC_116', 'DPVC_201', 'DPVC_221', 'DPVC_233', ... 
    'DPVC_119', 'DPVC_203', 'DPVC_223', 'DPVC_106', ...
    'DPVC_200', 'DPVC_210', 'DPVC_228' };


for i=1:length(list)
    close all
    cmd=['load ' char(list(i)) ];
    eval(cmd);
    
    N=length(DAT.ecg);
    
    figure(1)
    pvc=max(1,DAT.pvc.*DAT.ind);
    plot(1:N,DAT.ecg,'g', DAT.ind, DAT.ecg(DAT.ind),'b+')
    hold on
    plot(pvc,DAT.ecg(pvc),'ro','MarkerSize',4,'LineWidth',2 )
    title(list(i),'FontSize',22);
    xlabel(['Batimentos: ', num2str(length(DAT.ind))  '   '...
            'PVC :  ', num2str(sum(DAT.pvc))  ],'FontSize',18)
    zoom on
    pause    
end
