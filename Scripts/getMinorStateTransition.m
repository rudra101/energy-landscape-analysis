%a helper function which calculates the direct minor state transition 
function result = getMinorStateTransition(transFreq, numBasins, majorStIndices)
   result = 0;
   minorSts = setdiff(1:numBasins, majorStIndices); %set subtraction
   for ii = 1:length(minorSts)
    for jj = 1:length(minorSts)
     if ii ~= jj;
	 result = result + transFreq(ii,jj);
     end
    end
   end
end

