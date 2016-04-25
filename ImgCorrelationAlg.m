%preliminary algorithm for facial recognition, utilizing Pearson
%Correlation Coefficient to determine the closest match


load classdata.mat;

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

correl = 0;
recognized_image = [];

for i=1:size(testdata, 3)
% for i=1:size(classdata, 3)    
    image1 = testdata(:,:,i);
%     image1 = classdata(:,:,i);

    
    %get images and resizing to smaller size
    
    img1smallx = resample(image1, 1,4);
    img1small = resample(img1smallx', 1,4);
    image1 = img1small';
    for j=1:size(classdata, 3)
%     for j=1:size(testdata, 3)
    
        image2 = classdata(:,:,j);
%         image2 = testdata(:,:,j);

        img2smallx = resample(image2, 1,4);
        img2small = resample(img2smallx', 1,4);
        image2 = img2small';


        %reshaping to vectors
        col1 = reshape(image1, [90*64,1]);
        col2 = reshape(image2, [90*64,1]);

        %making correlation matrix
        testmat = [col1 col2];
        o = ones(size(testmat, 1), 1);
        m = o * mean(testmat);
        s = o * std(testmat);
        b = (testmat-m)./s;
        c = (1/(size(testmat,1)-1))*b'*b;
        
        if c(1,2) > correl
            correl = c(1,2);
            recognized_image = image2;
        end
    end
            
        
    % plotting result
    figure;
    subplot(1,2,1);
    imshow(image1);
    xlabel('original');
    subplot(1,2,2);
    imshow(recognized_image);
    xlabel('found');
    recognized_image = [];
    correl = 0;       

end