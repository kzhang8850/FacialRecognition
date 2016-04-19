%This is a preliminary algorithm for facial recognition, utilizing pixel
%spaces and finding the smallest distance

load classdata.mat;

%reshaping images
imageone = classdata(:,:, 150);
imagetwo = classdata(:,:,100);
newpic1 = reshape(imageone, [360*256,1]);
newpic2 = reshape(imagetwo, [360*256,1]);
newpic2 = newpic2 .* 1.1;


%calculating the stuff for data
avg1 = sum(newpic1)/(360*256);
deviation1 = std(newpic1);
avg2 = sum(newpic2)/(360*256);
deviation2 = std(newpic2);
% display(avg1);
% display(deviation1);
% display(avg2);
% display(deviation2);


%reshaping again
imageone2 = reshape(newpic1, [360, 256]);
imagetwo2 = reshape(newpic2, [360, 256]);
% 
% imageone = Trans1(imageone2, 5);
% imagetwo = Trans2(imagetwo2);

% histogram(newpic1);
% subplot(1,2,1);
% imshow(imageone);
% subplot(1,2,2);
% imshow(imagetwo);
% histogram(newpic2);

%     diff1 = imageone - imagetwo;


%     distance1 = sqrt(sum(sum(diff1.^2)));



%      display(distance1);


%resizing to make smaller
    img1smallx = resample(imageone, 1,4);
    img1small = resample(img1smallx', 1,4);
    imageone = img1small';
    
    img2smallx = resample(imagetwo, 1,4);
    img2small = resample(img2smallx', 1,4);
    imagetwo = img2small';
    
%reshaping into a vector
    col1 = reshape(imageone, [90*64, 1]);
    col2 = reshape(imagetwo, [90*64, 1]);
   

%finding correlation matrix
    testmat = [col1, col2];
    o = ones(size(testmat, 1),1);
    m = o * mean(testmat);
    s = o * std(testmat);
    b = (testmat-m)./s;
    c = (1/(size(testmat,1)-1))*b'*b;
%     display(c);


%target image and initializing variables
chicken = classdata(:,:,162);
smallest_distance = 100000000000000000000;
recognized_image = [];

%searching for the differences and finding the smallest distance between
%two pixels
for i=1:344
    temp = classdata(:,:,i);
    diff = chicken - temp;
    distance = sqrt(sum(sum(diff.^2)));
    if distance < smallest_distance
        recognized_image = temp;
        smallest_distance = distance;
    end
end

% plotting result
subplot(1,2,1);
imshow(chicken);
xlabel('original');
subplot(1,2,2);
imshow(recognized_image);
xlabel('found');
