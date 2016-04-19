%preliminary algorithm for facial recognition, utilizing Pearson
%Correlation Coefficient to determine the closest match


load classdata.mat;


%get images and resizing to smaller size
image1 = classdata(:,:,1);
img1smallx = resample(image1, 1,4);
img1small = resample(img1smallx', 1,4);
image1 = img1small';
% imshow(image1);

image2 = classdata(:,:,2);
img2smallx = resample(image2, 1,4);
img2small = resample(img2smallx', 1,4);
image2 = img2small';
% imshow(image2); 

image3 = classdata(:,:,20);
img3smallx = resample(image3, 1,4);
img3small = resample(img3smallx', 1,4);
image3 = img3small';
% imshow(image3);


%reshaping to vectors
col1 = reshape(image1, [90*64,1]);
col2 = reshape(image2, [90*64,1]);
col3 = reshape(image3, [90*64,1]);


%making correlation matrix
testmat = [col1 col2 col3];
o = ones(size(testmat, 1), 1);
m = o * mean(testmat);
s = o * std(testmat);
b = (testmat-m)./s;
c = (1/(size(testmat,1)-1))*b'*b;
display(c);
 