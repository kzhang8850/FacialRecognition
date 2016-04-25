%This is a preliminary algorithm for facial recognition, utilizing pixel
%spaces and finding the smallest distance

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

%initializing variables
smallest_distance = 100000000000000000000;
recognized_image = [];

%searching for the differences and finding the smallest distance between
%two pixels
for j=1:size(classdata, 3)
    testing = classdata(:,:,j);
    for i=1:size(testdata, 3)
        temp = testdata(:,:,i);
        diff = testing - temp;
        distance = sqrt(sum(sum(diff.^2)));
        if distance < smallest_distance
            recognized_image = temp;
            smallest_distance = distance;
        end
    end

    % plotting result
    figure;
    subplot(1,2,1);
    imshow(testing);
    xlabel('original');
    subplot(1,2,2);
    imshow(recognized_image);
    xlabel('found');
    recognized_image = [];
    smallest_distance = 100000000000000000000000000;
end
