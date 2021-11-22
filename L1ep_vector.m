function [x_hat] = L1ep_vector(A, y, p)
[x_hat, maxiter, epsilon, lambda, beta] = deal(randn(size(A, 2), 1), 1000, 0.01, 0.1, 0.7); % lambda = 0.01
for iter = 1 : maxiter
    temp_x_hat = x_hat;
    g = ((A * x_hat - y).^2 + epsilon.^2).^(p/2 - 1) .* (A * x_hat - y) ;
    delta_f = p * A' * g + 2*x_hat;
    a = x_hat - lambda.*delta_f;
    f1 = norm((A * a - y).^2 + epsilon.^2, p/2)^(p/2) + norm(a,2)^2;
    f0 = norm((A * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(x_hat,2)^2 - lambda/2*delta_f'*delta_f;
    in = 0;
    while f1 > f0
        in = in + 1;
        lambda = lambda * beta;
        a = x_hat - lambda.*delta_f;
        f1 = norm((A * a - y).^2 + epsilon.^2, p/2)^(p/2) + norm(a,2)^2;
        f0 = norm((A * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(x_hat,2)^2 - lambda/2*delta_f'*delta_f;
    end
    x_hat = x_hat - lambda.*delta_f;
    MSE = norm(temp_x_hat - x_hat)^2/norm(x_hat)^2;
    if MSE < 1e-5
        break
    end
end
end

