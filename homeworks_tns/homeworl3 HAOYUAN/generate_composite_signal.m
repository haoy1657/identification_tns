function comp_signal = generate_composite_signal(snr_db, y)
    % Assume y is the useful signal whose power is already known
    signal_power = bandpower(y);
    
    % Convert SNR from dB to linear scale
    snr_linear = 10^(snr_db / 10);
    
    % Calculate noise power based on desired SNR
    noise_power = signal_power / snr_linear;
    noise_std = sqrt(noise_power);
    
    % Generate noise
    noise = noise_std * randn(1, length(y));
    
    % Generate composite signal
    comp_signal = y + noise;
end
