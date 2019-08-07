function data = Read_Signal_Depth_Data(fullFileName)
    [fid, msg] = fopen(fullFileName, 'r');
    fopen(fid);
    if(fid<0)
        error('kinect_toolbox:readpgm_noscale:fileOpen', ...
            [fullFileName ': ' msg]);
    end
    width=640; %fscanf(fid,'%d',1);
    height=480 ;%fscanf(fid,'%d',1);
    channels = 1;
    numvals = width*height*channels;
    [data,count]=fread(fid,numvals,'*single',0,'ieee-le');
    if length(fread(fid, 1, 'char'));
        warning('kinect_toolbox:readpgm_noscale:extraData', ...
            '%s: file contains extra data.',fullFileName);
    end
    fclose(fid);
    
    if count < numvals
        warning('kinect_toolbox:readpgm_noscale:unexpectedEOF', ...
            '%s: file ended while reading image data.',fullFileName);
        data(numvals) = 0;
    end
    
    data = reshape(data, [channels width height]);
    data = permute(data, [3 2 1]);
    data = double(data);
    data(data==0)=nan;
end

