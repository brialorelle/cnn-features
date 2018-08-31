function makeMontages


topFolder=('Silhouettes')
% topFolder=('Texforms-HigherContrast')
% topFolder=('Originals-HigherContrast')
subFolders={'BigObjects','SmallObjects','BigAnimals','SmallAnimals'}

count=0;
for s=1:length(subFolders)
   subFolder2=subFolders{s}
   classFolders=getSubfolders([topFolder filesep subFolder2]);
    for c=1:length(classFolders)
        thisFolder=[topFolder filesep subFolder2 filesep classFolders(c).name]
        images=dir(fullfile(thisFolder,'*.png'))
        for i=1:length(images)
            count=count+1;
            imageList{i}=[pwd filesep thisFolder filesep images(i).name];
            imageListAll{count}=[pwd filesep thisFolder filesep images(i).name];     
        end
    end
    
end


subfigure(1,1,1)
% montage(imageListAll,'Size',[12 10])
montage(imageListAll,'Size',[24 5])
end

function contents=dropHiddenFiles(folder)

temp=dir(folder)

% jettison anything with a '.' in name
dropThese=[];
for i=1:length(temp)
  if any(strfind(temp(i).name,'.'));
    dropThese(i)=1;
  else
    dropThese(i)=0;
  end
end
temp(find(dropThese))=[];
contents=temp;

end

function contents=getSubfolders(folder)

temp=dir(folder);

% jettison anything with a '.' in name
dropThese=[];
for i=1:length(temp)
  if any(strfind(temp(i).name,'.'));
    dropThese(i)=1;
  else
    dropThese(i)=0;
  end
end
temp(find(dropThese))=[];
contents=temp;

end