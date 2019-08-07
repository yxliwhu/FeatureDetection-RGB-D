% Given keypoints of two images, determing the matching keypoints
function matches = computeMatches(list1, list2)

	M1 = length(list1);
	M2 = length(list2);
	matches = [];

	% try to find a match for every point in list1 in list2
	for i = 1:M1
		d1 = 1e99;
		d2 = d1;
		minIdx = -1;
		secMinIdx = minIdx;
		for j = 1:M2
			distnc = norm(list1{i}.Descriptor - list2{j}.Descriptor);
			if (distnc < d1)
				d2 = d1;
				d1 = distnc;
				secMinIdx = minIdx;
				minIdx = j;
			elseif (distnc < d2)
				d2 = distnc;
				secMinIdx = j;
			end
		end

		% perform threshold check on the distance ratio
		if (d1 / d2 < 0.6)
			matches = [matches; [list1{i}.Coordinates(:);list2{minIdx}.Coordinates(:)]'];
		end

	end