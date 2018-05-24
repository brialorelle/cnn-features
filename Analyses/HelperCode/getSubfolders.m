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