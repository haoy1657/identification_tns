function plot_signals(t, sine_wave, white_noise, linear_sweep)
    % Plot sine wave
    subplot(3, 1, 1);
    plot(t, sine_wave);
    title('Sine Wave');
    
    % Plot white noise
    subplot(3, 1, 2);
    plot(t, white_noise);
    title('White Noise');
    
    % Plot linear sweep
    subplot(3, 1, 3);
    plot(t, linear_sweep);
    title('Linear Sweep');
end