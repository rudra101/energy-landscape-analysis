% convert a map whose keys map to pydict into a complete pydict
function res = convertToPyDict(inputDict)
   mapKeys = inputDict.keys();
   argStr = ''; %start creating the argument for py.dict
   for ii = 1:length(mapKeys);
    key = mapKeys{ii};
    % trying to reproduce "'key', inputDict('key')" to use as pyargs
    argStr = [argStr ',' getSingleQuote() key getSingleQuote() ',inputDict(' getSingleQuote() key getSingleQuote() ')' ];
   end 
   argStr = ['pyargs(' argStr(2:end) ')']; % remove the first comma from argStr
   res = eval(sprintf('py.dict(%s)', argStr));
end

% a function to get a single quote within single quote. Type '''' in terminal to understand what it means
function res = getSingleQuote()
     res = '''';
end

