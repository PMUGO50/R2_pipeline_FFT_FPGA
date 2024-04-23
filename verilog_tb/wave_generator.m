function wave_generator()
    fs = 40*10^6;
    f0 = 10^6;
    t = (1/fs):(1/fs):(512/fs);
    
    x = xfunc(t, f0, 100);
    x = round(x).';
    sampgen(x);
    fx = ffttest(x);
    ploting_amp(fx, fs);
end

function x = xfunc(t, f0, a)
%%%from following functions choose one
    %x = a*sin(2*pi*f0*t);
    %x = a*(sin(f0*(2*pi)*t) + sin(3*f0*(2*pi)*t) + sin(7*f0*(2*pi)*t));
    %x = a.*(2*pi*16*f0).*exp(-(2*pi*16*f0).*t);
    x = a*square(2*pi*f0*t);
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

function ploting_amp(fx, fs)
    N = length(fx);
    f = 0:(N-1);
    f = f*fs/N/(10^6);
    figure(1);
    ax = gca;
    plot(ax, f, real(fx)./N, 'LineWidth', 1, 'Color', 'r');
    hold on;
    plot(ax, f, imag(fx)./N, 'LineWidth', 1, 'Color', 'b');
    legend("real", "imag");
    ax.XLabel.String = "freq/MHz";
    ax.YLabel.String = "fft";
    figure(2);
    plot(f, abs(fx)./N, 'LineWidth', 1, 'Color', 'r');
end