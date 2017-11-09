function data = fullProcessing(data)
    
    %Low Pass
    order = 4;
    wc = 20;
    fs=1000;
    fc = wc / (0.5 * fs);
    [b, a]=butter(order, fc);
    e1 = filter (b, a, data); 
    
    % High Pass
    order = 4;
    wc = 5;
    fc = wc / (0.5 * fs);
    [b,a] = butter(order, fc,'High');
    e2 = filter (b, a, e1);
    
    % Differentiation and Potentiation
    e3 = diff(e2);
    e4 = e3.^2;

    % moving average
    N = 1000*0.2;
    b = (1/N)*ones (1, N);
    a = 1;
    e5 = filter (b, a, e4);
    
    data = {e1, e2, e3, e4, e5};
    
end