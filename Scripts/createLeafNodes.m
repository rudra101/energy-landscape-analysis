%creates activity patterns to act as leaf nodes in the energy dendrograms.
function createLeafNodes(nodeNumber, E, LocalMinIndex, Name)
        vectorList = mfunc_VectorList(nodeNumber);
	leaveSpace = 0.06; %space below the dendrogram leaf for more visibility
	stretchHorz = 0.2; % how much one single activity cell is to be stretched in horizontal direction
	stretchVer = 0.2; % how much one single activity cell is to be stretched in vertical direction
	edgecolor = 'k'; %edgecolor for patched polygon 
	for leafIndex = 1:length(LocalMinIndex);
		state = LocalMinIndex(leafIndex);
		energyPos = E(state) - leaveSpace; %energy is leaf's y-coordinate
		activityPtrn = vectorList(:,state)'; % get the activity pattern. 
		Ys = energyPos - stretchVer *(0:nodeNumber); %y coordinate of each horizontal line in an activity pattern.
		leafLeft = leafIndex - stretchHorz *0.5;
		leafRight = leafIndex + stretchHorz *0.5;
		%figure;
		for node = 1:nodeNumber; 
			activity = activityPtrn(end-node+1); %caution: this order follows mfunc_ActivityMap()
			Xcoord = [leafLeft leafLeft leafRight leafRight];
			Ycoord = [Ys(node+1) Ys(node) Ys(node) Ys(node+1)];
			%vertices = [Xcoord' Ycoord'];
			facecolor = [1 1 1]; %white
			if activity == -1; %paint in lighter shade of black
			facecolor = [0.3 0.3 0.3];
			end
			patch(Xcoord, Ycoord, facecolor);
			%patch('Faces', [1 2 3 4], 'Vertices',vertices,'FaceColor',facecolor, 'EdgeColor', edgecolor);
		end
	end
	addActivityLabels(nodeNumber, Name, E, LocalMinIndex);
end

function addActivityLabels(nodeNumber, Name, E, LocalMinIndex)
numOfLeafs = length(LocalMinIndex);
minEng = min(E(LocalMinIndex)); maxEng = max(E(LocalMinIndex));
maxVal = max(abs(minEng), abs(maxEng));
stretchHorz = 0.3; % how much one single activity cell is to be stretched in horizontal direction
stretchVer = 0.3; % how much one single activity cell is to be stretched in vertical direction
edgecolor = 'k'; 
xoffset = 4 + maxVal; %trying to add some logic to legend placement
yoffset = max(E(LocalMinIndex)); %change the offset if needed
textOffset = 0.1; %change if needed
edgeLeft = xoffset - stretchHorz *0.5; 
edgeRight = xoffset + stretchHorz *0.5;
Ys = yoffset - stretchVer *(0:nodeNumber);  
for node = 1:nodeNumber; %paint all white cells
	Xcoord = [edgeLeft edgeLeft edgeRight edgeRight];
	Ycoord = [Ys(node+1) Ys(node) Ys(node) Ys(node+1)];
	%vertices = [Xcoord' Ycoord'];
	facecolor = [1 1 1]; %white
	patch(Xcoord, Ycoord, facecolor);
	%caution: order of Name follows mfunc_ActivityMap()
	text(edgeRight+textOffset, 0.5*(Ys(node+1)+Ys(node)), Name(end-node+1), 'Color', 'k', 'FontSize', 9);
end
%paint an active ROI
labelOffset = 0.2; %space above the activity patterns
Xcoord = labelOffset + [edgeLeft-stretchHorz edgeLeft-stretchHorz edgeRight-stretchHorz edgeRight-stretchHorz];
Ycoord = labelOffset + [Ys(2)+stretchVer Ys(1)+stretchVer Ys(1)+stretchVer Ys(2)+stretchVer];
patch(Xcoord, Ycoord, 'w');
text(edgeRight-stretchHorz+0.25, 0.5*(Ycoord(1)+Ycoord(2)), 'Active ROI', 'Color', 'k', 'FontSize', 8);
%paint an inactive ROI
Xcoord = labelOffset + [edgeLeft-stretchHorz edgeLeft-stretchHorz edgeRight-stretchHorz edgeRight-stretchHorz];
Ycoord = 0.1 + labelOffset + [Ys(2)+2*stretchVer Ys(1)+2*stretchVer Ys(1)+2*stretchVer Ys(2)+2*stretchVer];
patch(Xcoord, Ycoord, 'k'); %inactive ROI
text(edgeRight-stretchHorz+0.25, 0.5*(Ycoord(1)+Ycoord(2)), 'Inactive ROI', 'Color', 'k', 'FontSize', 8);
end

