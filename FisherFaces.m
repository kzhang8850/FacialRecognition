%%computing the LDA class means

M1 = mean(X1')';
M2 = mean(X2')';
M3 = mean(X3')';


%overall mean
Mu = (M1 + M2 + M3)./3;

%class covariance matrices
S1 = cov(X1');
S2 = cov(X2');
S3 = cov(X3');

%within-class scatter matrix
Sw = S1 + S2 + S2;

%number of samples of each class
N1 = size(X1, 2);
N2 = size(X2, 2);
N3 = size(X3, 2);

%between-class scatter matrix
SB1 = N1 .* (M1 - Mu) * (M1 - Mu)';
SB2 = N2 .* (M2 - Mu) * (M2 - Mu)';
SB3 = N3 .* (M3 - Mu) * (M3 - Mu)';

SB = SB1 + SB2 + SB3;

%computing the LDA projection
invSw = inv(Sw);
invSw_by_SB = invSw * SB;

%getting the projection vectors
[V, D] = eig(invSw_by_SB);

