function postchecker()
    N = 512;
    fs = 40;
    parafl = fopen("fftpara.v", 'r');
    para = textscan(parafl, '%s %s %s');
    para = para{1,3};
    scale = 1;
    for i=5:length(para)
        scale = scale*2^str2double(para{i});
    end

    fft_fpga_sim = readmatrix("fftout_fpga_sim.csv");
    fft_fpga_sim(:,1) = fft_fpga_sim(:,1)./(2^22)./N.*fs; %%counter: {1'b0, cnt, 22'd0}
    fft_fpga_sim(:,2) = fft_fpga_sim(:,2)./(2^16).*scale./N; %%realpart: {re, 16'd0}
    fft_fpga_sim(:,3) = fft_fpga_sim(:,3)./(2^16).*scale./N; %%imagpart: {im, 16'd0}
    fft_fpga_sim(:,4) = fft_fpga_sim(:,4)./(2^30); %%valid: {1'b0, en, 30'd0}
    fft_ploting(fft_fpga_sim, 1);
end

function fft_ploting(fft_fpga_sim, figi)
    xaxis = fft_fpga_sim(:,1);
    figure(figi);
    tiledlayout(2,1);

    ax1 = nexttile;
    maxc1 = max(max(fft_fpga_sim(:,2)), 1);
    plot(ax1, xaxis, maxc1*fft_fpga_sim(:,4), 'LineWidth', 1, 'Color', '#99FF33');
    hold on;
    stem(ax1, xaxis, fft_fpga_sim(:,2), '.', 'LineWidth', 1, 'Color', '#E63F00');
    title("Real part");
    legend({'valid', 'fft'});
    ax1.XLabel.String = "freq/MHz";
    ax1.YLabel.String = "FS";
    ax1.YAxis.Exponent = 0;

    ax2 = nexttile;
    maxc2 = max(max(fft_fpga_sim(:,3)), 1);
    plot(ax2, xaxis, maxc2*fft_fpga_sim(:,4), 'LineWidth', 1, 'Color', '#99FF33');
    hold on;
    stem(ax2, xaxis, fft_fpga_sim(:,3), '.', 'LineWidth', 1, 'Color', '#E63F00');
    title("Imag part");
    legend({'valid', 'fft'});
    ax2.XLabel.String = "freq/MHz";
    ax2.YLabel.String = "FS";
    ax2.YAxis.Exponent = 0;

    figure(figi+1);
    ax3 = gca;
    amp = sqrt(fft_fpga_sim(:,3).^2 + fft_fpga_sim(:,2).^2);
    stem(ax3, xaxis, amp, '.', 'LineWidth', 1, 'Color', '#E63F00');
    title("FFT Amp");
    ax3.XLabel.String = "freq/MHz";
    ax3.YLabel.String = "FS";
    ax3.YAxis.Exponent = 0;
end