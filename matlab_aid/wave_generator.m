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
    for i=1:length(x)
        if(x(i)>=0)
            if(i==length(x))
                fprintf(fl, "dtest[%d]=16'd%d;\n", (i-1), x(i));
            else
                fprintf(fl, "dtest[%d]=16'd%d,\n", (i-1), x(i));
            end
        else
            if(i==length(x))
                fprintf(fl, "dtest[%d]=-16'd%d;\n", (i-1), -x(i));
            else
                fprintf(fl, "dtest[%d]=-16'd%d,\n", (i-1), -x(i));
            end
        end
    end
    fclose(fl);
end

function fx = ffttest(x)
    fx = fft(x);
    flf = fopen('wavefft.csv', 'w');
    for i=1:length(x)
        fprintf(flf, "re[%02d]=%08.2f,\t im[%02d]=%08.2f\n", (i-1), real(fx(i)), (i-1), imag(fx(i)));
    end
    fclose(flf);
end