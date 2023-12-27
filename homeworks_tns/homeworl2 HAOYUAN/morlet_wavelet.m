function wavelet = morlet_wavelet(len, f0, fs)
    t0 = 1/f0;
    t = linspace(-len/2, len/2, len);
    sigma_t = 5.4285 / (2*pi*f0);
    wavelet = (pi*t0^2)^(-1/4) .* exp(-t.^2/(2*t0^2)) .* exp(-1i*2*pi*f0*t);
end