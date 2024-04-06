function erroraly()
    fft_fpga_sim = readmatrix("fftout_fpga_sim.csv");
    fft_fpga_sim = fft_fpga_sim(2:length(fft_fpga_sim), :);
    fft_matlab = readmatrix("fftout_matlab.csv");

    error_re = abs(fft_fpga_sim(:,2)-fft_matlab(:,2));
    error_im = abs(fft_fpga_sim(:,3)-fft_matlab(:,3));
    error_e = error_re.^2 + error_im.^2;
    total_error_e = sum(error_e);
    total_energy = sum(fft_matlab(:,2).^2 + fft_matlab(:,3).^2);
    total_relative_error_e = total_error_e/total_energy;
    fprintf("total_relative_error_e = %.4f e-6\n", total_relative_error_e*1e6);
end