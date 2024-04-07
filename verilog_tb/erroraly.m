function erroraly()
    fft_fpga_sim = readmatrix("fftout_fpga_sim.csv");
    fft_fpga_sim = fft_fpga_sim(2:length(fft_fpga_sim), :);
    fft_fpga_sim = fft_fpga_sim(:,2:3);
    fft_matlab = readmatrix("fftout_matlab.csv");
    fft_matlab = fft_matlab(:,2:3);
    fs = 128;

    total_relative_error_e = errorcal(fft_fpga_sim, fft_matlab);
    fprintf("total_relative_error_e = %.4f e-6\n", total_relative_error_e*1e6);

    fft_ploting(fft_fpga_sim, fft_matlab, fs);
    ifft_ploting(fft_fpga_sim, fft_matlab, fs);
end

function total_relative_error_e = errorcal(fft_fpga_sim, fft_matlab)
    error_re = abs(fft_fpga_sim(:,1)-fft_matlab(:,1));
    error_im = abs(fft_fpga_sim(:,2)-fft_matlab(:,2));
    error_e = error_re.^2 + error_im.^2;
    total_error_e = sum(error_e);
    total_energy = sum(fft_matlab(:,1).^2 + fft_matlab(:,2).^2);
    total_relative_error_e = total_error_e/total_energy;
end

function fft_ploting(fft_fpga_sim, fft_matlab, fs)
    N = length(fft_fpga_sim);
    f = 0:(N-1);
    f = f*fs/N;
    figure(1);
    tiledlayout(2,1);

    ax1 = nexttile;
    plot(ax1, f, fft_matlab(:,1), 'LineWidth', 1, 'Color', '#D95319');
    hold on;
    plot(ax1, f, fft_fpga_sim(:,1), 'LineWidth', 1, 'Color', '#0072BD');
    legend(ax1, "matlab", "fpga sim");
    title("Real part");
    ax1.XLabel.String = "freq/Hz";
    ax1.YLabel.String = "fft";
    ax1.YAxis.Exponent = 3;

    ax2 = nexttile;
    plot(ax2, f, fft_matlab(:,2), 'LineWidth', 1, 'Color', '#D95319');
    hold on;
    plot(ax2, f, fft_fpga_sim(:,2), 'LineWidth', 1, 'Color', '#0072BD');
    legend(ax2, "matlab", "fpga sim");
    title("Imag part");
    ax2.XLabel.String = "freq/Hz";
    ax2.YLabel.String = "fft";
    ax2.YAxis.Exponent = 3;
end

function ifft_ploting(fft_fpga_sim, fft_matlab, fs)
    comp_fpga_sim = fft_fpga_sim(:,1) + fft_fpga_sim(:,2)*(1j);
    comp_matlab = fft_matlab(:,1) + fft_matlab(:,2)*(1j);
    ifft_fpga_sim = ifft(comp_fpga_sim);
    ifft_matlab = ifft(comp_matlab);
    t = 1:length(fft_fpga_sim);
    t = t/fs;

    figure(2);
    ax3 = gca;
    plot(ax3, t, real(ifft_matlab), 'LineWidth', 1, 'Color', '#D95319');
    hold on;
    plot(ax3, t, real(ifft_fpga_sim), 'LineWidth', 1, 'Color', '#0072BD');
    legend(ax3, "matlab", "fpga sim");
    title("Inv FFT");
    ax3.XLabel.String = "time/s";
    ax3.YLabel.String = "signal";
    ax3.YAxis.Exponent = 3;
end