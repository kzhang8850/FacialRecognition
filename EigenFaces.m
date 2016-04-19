%preliminary algorithm for facial recognition, utilizing eigenfaces and
%eigenstuff to find the closest match



%loads the database of student faces
load classdata.mat;

%finds the mean face
mean_face = zeros(360, 256);

for i=1:360
    for j=1:256
        mean_face(i,j) = mean(classdata(i, j, :));
    end
end


%finds the difference faces for all faces in the database
classdata2 = classdata;
for i=1:344
    classdata2(:,:,i) = classdata(:,:,i) - mean_face;
end

%converts to vector form
classvector = zeros(360*256, 344);

for i=1:344
    classvector(:,i) = reshape(classdata2(:,:,i), [360*256, 1]);
end


%creates the covariance matrix
covariance_matrix = 1/(size(classvector, 1)-1) * (classvector')*(classvector);

%finds the eigenvalue of the smaller covariance matrix, A^T*A
[eigenvector, eigenvalue] = eig(covariance_matrix);


%use the eigenvalue of the smaller covariance matrix to find the
%eigenvectors of the larger covariance matrix A*A^T
eigenfaces = classvector * eigenvector;

%normalizing the eigenfaces
for i=1:344
    eigenfaces(:,i) = eigenfaces(:,i)/(sqrt(sum(eigenfaces(:,i).^2)));
end


%testing eigenfaces with decompostion and reconstruction
temp = eigenfaces(:,1:200);
test = classdata(:,:, 1);
test2 = test - mean_face;
test = reshape(test2, [360*256, 1]);

alpha = temp' * test;

reconstruct = temp * alpha ;
recon = reshape(reconstruct, [360, 256]) + mean_face;
imagesc(recon);
colormap gray;
axis equal;







    
