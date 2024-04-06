function wave_generator()
    fs = 128;
    f0 = 1;
    t = (1/fs):(1/fs):(512/fs);
    
    x = 50*(sin(f0*(2*pi)*t) + sin(7*f0*(2*pi)*t) + sin(26*f0*(2*pi)*t));
    x = round(x).';
    sampgen(x)
    
    fx = ffttest(x);
    f = 0:(length(t)-1);
    f = f/length(t)*fs;
    figure(1);
    plot(f,real(fx));
    hold on;
    plot(f,imag(fx));
end

function sampgen(x)
    fl = fopen('wavesamp.txt','w');
    x = dec2hex(x);
    for i=1:length(x)
        if(i==length(x))
            fprintf(fl, "%s", x(i,:));
        else
            fprintf(fl, "%s\n", x(i,:));
        end
    end
    fclose(fl);
end

function fx = ffttest(x)
    fx = fft(x);
    col0 = 0:(length(fx)-1);
    datafl = [col0.', real(fx), imag(fx)];
    writematrix(datafl, 'fftout_matlab.csv');
end