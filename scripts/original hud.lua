--DON'T STEAL KIDS!
--BY JUNIORNOVOA

local songSplashNames = {'Maze', 'Wireframe', 'Ferocious', 'Apple-Leak', 'OG'};
local songNames = {'Wireframe', 'Ferocious', 'Apple-Leak', 'OG'};
local arrowXoffset = 35;
local arrowYoffset = 0;
local no_splashes = false;

function onCreatePost()
	for i = 1, #songSplashNames do
		--print(songName..songNames[i]);
		if songName == songSplashNames[i] then
			no_splashes = true;
		end
	end
	for i = 1, #songNames do
		--print(songName..songNames[i]);
		if songName == songNames[i] then
			for direction = 0, 3 do
				setPropertyFromGroup('playerStrums', direction, 'x', getPropertyFromGroup('playerStrums', direction, 'x') - arrowXoffset)
				setPropertyFromGroup('opponentStrums', direction, 'x', getPropertyFromGroup('opponentStrums', direction, 'x') - arrowXoffset -5)
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if no_splashes then
		setPropertyFromGroup('grpNoteSplashes', getProperty('grpNoteSplashes.length') -1, 'visible', false);
	end
end