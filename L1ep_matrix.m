function [A_hat] = L1ep_matrix(A, x_hat, y, p)
% lambda = 1e-4;
% beta = 0.9;
[A_hat, maxiter, epsilon, ra, roh] = deal(A, 500, 0.01, 0, 0.90);
for iter = 1 : maxiter
    temp_A_hat = A_hat;
    g = ((A * x_hat - y).^2 + epsilon.^2).^(p/2 - 1) .* (A * x_hat - y);
    delta_f = p * g * x_hat' + 2 * A;  
    ra = roh*ra + (1-roh)*delta_f.*delta_f;
    A_hat = A_hat - (1e-4./sqrt(1e-10 + ra)).*delta_f; 
%     A = A_hat - lambda.*delta_f;
%     f1 = norm((A * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(A,2)^2;
%     f0 = norm((A_hat * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(A_hat,2)^2 - lambda/2*delta_f'*delta_f;
%     while f1 > f0
%         lambda = lambda * beta;
%         a = x_hat - lambda.*delta_f;
%         f1 = norm((A * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(A,2)^2;
%         f0 = norm((A_hat * x_hat - y).^2 + epsilon.^2, p/2)^(p/2) + norm(A_hat,2)^2 - lambda/2*delta_f'*delta_f;
%     end
%     A_hat = A_hat - lambda.*delta_f; 
%     norm(A_hat * x_hat - y,2)
    MSE = norm(temp_A_hat - A_hat)^2/norm(A_hat)^2;
    if MSE < 1e-5 
        break
    end
end
end

