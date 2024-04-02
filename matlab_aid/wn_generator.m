function wn_generator()
    re = [];
    im = [];
    N = 512;
    for k=0:(N-1)
        re = [re, real(exp(-2*pi*k/N*1j)) * (2^15)];
        im = [im, imag(exp(-2*pi*k/N*1j)) * (2^15)];
    end
    re = clipping(round(re), 32767, -32767);
    im = clipping(round(im), 32767, -32767);
    re = dec2hex(re);
    im = dec2hex(im);
    fl_re = fopen('romdata_re.coe','w');
    fprintf(fl_re, "MEMORY_INITIALIZATION_RADIX=16;\n");
    fprintf(fl_re, "MEMORY_INITIALIZATION_VECTOR=\n");
    for i=1:length(re)
        if i==length(re)
            fprintf(fl_re, "%s;", re(i,:));
        else
            fprintf(fl_re, "%s,\n", re(i,:));
        end
    end
    fclose(fl_re);

    fl_im = fopen('romdata_im.coe','w');
    fprintf(fl_im, "MEMORY_INITIALIZATION_RADIX=16;\n");
    fprintf(fl_im, "MEMORY_INITIALIZATION_VECTOR=\n");
    for i=1:length(im)
        if i==length(im)
            fprintf(fl_im, "%s;", im(i,:));
        else
            fprintf(fl_im, "%s,\n", im(i,:));
        end
    end
    fclose(fl_im);
    fprintf("program finished.\n");
end

function out = clipping(array, amax, amin)
    out = [];
    for i=1:length(array)
        if array(i)>amax
            out(i) = amax;
        elseif array(i)<amin
            out(i) = amin;
        else
            out(i) = array(i);
        end
    end
end
