function string=replaceDash(string)
% replace underscores with '-' so figures can look ok
% bll 10.9.17 bria@stanford.edu
try
    ind=strfind(string,'-');
    string(ind)='_';
    out=string;
catch
    disp('no dash to replace...')
end
end