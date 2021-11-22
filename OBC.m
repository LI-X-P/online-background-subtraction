function [M_r] = OBC(M, rak)
%%
% When using the whole or part of this code, please cite the following paper:
% Q. Liu, X.P. Li, "Efficient Low-Rank Matrix Factorization based on l_{1,\epsilon}-norm for Online Background Subtraction", 
% IEEE Transactions on Circuits and Systems for Video Technology, 2021.
%%
outerIter = 1;
[U0, S0, ~] = svd(M(:,1:20),0); % use the first 20 frames to initial U
U = U0*sqrt(S0(:,1:rak));
M_r = zeros(size(M));
V = zeros(rak,size(M,2));
for col = 1 : size(M,2)
    m_I = M(:,col);
    for i = 1 : outerIter
        U_I =  U;
        v_j = L1ep_vector(U_I, m_I, 1);
        U = L1ep_matrix(U_I, v_j,  m_I, 1);
    end
    M_r(:,col) = U*v_j;
    V(:,col) = v_j;
end
end