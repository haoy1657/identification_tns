function [sine_wave, white_noise, linear_sweep, t] = generate_signals(T, A, f0, f1, mu, sigma, fs)
    % Time vector
    t = 0:1/fs:T-1/fs;
    
    % Sine wave
    sine_wave = A * sin(2 * pi * f0 * t);
    
    % Gaussian white noise
    white_noise = mu + sigma * randn(size(t));
    
    % Linear sweep (chirp signal)
    linear_sweep = A * chirp(t, f0, T, f1);
end

