%preliminary algorithm for facial recognition, utilizing eigenfaces and
%eigenstuff to find the closest match

%loads the database of student faces
load classdata.mat;


load testdata.mat;
finaldata = testdata./255;

%creating the testset and the dataset
testdata = zeros(360, 256, 43);
counter = 1;
for i=1:8:344
    testdata(:,:,counter) = classdata(:,:,i);
    counter = counter + 1;
end

tempdata = zeros(360, 256, 344-size(testdata, 3));
counter = 1;
counter2 = 1;
for i =1:344
    if counter < 44
        if(classdata(:,:,i) == testdata(:,:,counter))
            counter = counter + 1;
        else
            tempdata(:,:,counter2) = classdata(:,:,i);
            counter2 = counter2 + 1;
        end
    else
        tempdata(:,:,counter2) = classdata(:,:,i);
        counter2 = counter2 + 1;
    end
end

classdata = tempdata;
tic
%finds the mean face, which is used for centering the dataset around the
%mean

% mean_face = mean(testdata, 3);
mean_face = mean(classdata, 3);


%finds the difference faces for all faces in the database. This is the
%centered dataset.

% classdata2 = testdata;
classdata2 = classdata;


% for i=1:size(testdata, 3)
for i=1:size(classdata, 3)    
    classdata2(:,:,i) = classdata(:,:,i) - mean_face;
end

%converts to vector form, which is used to create a image by image
%covariance matrix
classvector = reshape(classdata2, [360*256, size(classdata, 3)]);


%creates the covariance matrix by using the formula C = 1/(N-1)*A^T*A
covariance_matrix = 1/(size(classvector, 1)-1) * (classvector')*(classvector);

%finds the eigenvalue and associated eigenvectors of the smaller covariance matrix, A^T*A
[eigenvector, eigenvalue] = eig(covariance_matrix);


%use the eigenvectors of the smaller covariance matrix to find the
%eigenvectors of the larger covariance matrix A*A^T. A postulate states
%that if v is the eigenvector of A^T*A, then Av is the eigenvector of A*A^T
eigenfaces = classvector * eigenvector;

%normalizing the eigenfaces to make linear combination easier
for i=1:size(eigenfaces, 2)
    eigenfaces(:,i) = eigenfaces(:,i)/norm(eigenfaces(:,i));
end


%testing eigenfaces with decompostion and reconstruction

%using the most important eigenfaces, based on 95% of the eigenvalues

% temp = eigenfaces(:,1:43);
temp = eigenfaces(:,1:120);



for j=1:size(finaldata, 3)
% for j=1:size(classdata, 3)
% for j=1:size(testdata, 3)
    
    %pulling the test subject for facial recognition
%     test = classdata(:,:,j);
%     test = testdata(:,:,j);
    test = finaldata(:,:,j);

    test2 = test - mean_face;
    test = reshape(test2, [360*256, 1]);

    alpha = temp' * test;
    
    
    smallestdist = 100000000;
    index = 0;
    % dist = zeros(344);
    % number = 1:344;

%     for i=1:size(testdata, 3)
    for i=1:size(classdata, 3)    
%         data = testdata(:,:,i);
        data = classdata(:,:,i);

        data2 = data - mean_face;
        data = reshape(data2, [360*256, 1]);
        alpha2 = temp' * data;

        dist = sqrt(sum((alpha2-alpha).^2));

        if dist < smallestdist
            smallestdist = dist;
            index = i;
        end
    end
    figure;
    subplot(1,2,1);
    imagesc(reshape(test, [360, 256]));
    colormap gray;
    axis equal;
    xlabel('Original Image');
    subplot(1,2,2);
    imagesc(classdata(:,:,index));
%     imagesc(classdata(:,:,index));
    
    xlabel('Found Image');
    % reconstruct = temp * alpha ;
    % recon = reshape(reconstruct, [360, 256]) + mean_face;
    % imagesc(recon);
    colormap gray;
    axis equal;
end



toc



    
