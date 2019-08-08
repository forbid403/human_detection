
function saveModifiedImages(image, param)

% path for saving modified image %
file_path = "C:\Users\sonia\Desktop\etri\Job\5th_Week\project\";
currAction = param.action(param.srtAction);
folder_name = char(strcat(file_path, param.name, currAction));

disp(folder_name);

if ~exist(folder_name, 'dir')
    mkdir(folder_name);
end

imgName = 'img0001.jpg';
fullName = fullfile(folder_name, imgName);
imwrite(image, fullName);
disp(['action Num : ' param.srtAction ', currAction :' currAction]);

end



