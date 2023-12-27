function [quantized_signal] = quantize_signal(signal, num_bits, scale)
    % Quantize a signal to a specified number of bits and scale.
    % The scale defines the range of the quantizer.

    max_val = max(abs(signal)) / scale;
    step_size = (2 * max_val) / (2^num_bits);
    quantized_signal = round(signal / step_size) * step_size;
end
