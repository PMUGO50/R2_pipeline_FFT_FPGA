function wave_generator()
    fs = 128;
    f0 = 1;
    t = (1/fs):(1/fs):(512/fs);
    
    x = xfunc(t, f0);
    x = round(x).';
    sampgen(x);
    fx = ffttest(x);
    test_ploting_amp(fx, fs);
end

function x = xfunc(t, f0)
%%%from following functions choose one
    %x = 50*(sin(f0*(2*pi)*t) + sin(7*f0*(2*pi)*t) + sin(26*f0*(2*pi)*t));
    %x = 50.*(2*pi*16*f0).*exp(-(2*pi*16*f0).*t);
    x = 50*square(2*pi*f0*t);
end

function sampgen(x)
    fl = fopen('wavesamp.txt','w');
    x = dec2hex(x, 4);
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

function test_ploting_amp(fx, fs)
    N = length(fx);
    f = 0:(N-1);
    f = f*fs/N;
    amp_fx = sqrt(real(fx).^2 + imag(fx).^2);
    figure(1);
    ax = gca;
    plot(ax, f, amp_fx, 'LineWidth', 1);
    ax.XLabel.String = "freq/Hz";
    ax.YLabel.String = "fft";
end