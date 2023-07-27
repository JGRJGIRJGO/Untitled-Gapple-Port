local brobPart = true;

function onCreatePost()
    precacheMusic("freshAndToasted/win-brobgonal")
    addHaxeLibrary("FlxColor", 'flixel.util')
    if stringStartsWith(version, '0.6') then
        addHaxeLibrary('Character')
    else
        addHaxeLibrary('Character', 'objects')
    end

    runHaxeCode([[
        var barbu = new Character(game.dad.x - 525, -500, 'barbu');
		//barbu.visible = false;
		game.add(barbu);
		game.modchartSprites.set('barbu', barbu);
    ]])

    for i = 0, getProperty("unspawnNotes.length") do
        if not getPropertyFromGroup("unspawnNotes", i, 'mustPress') then
            setPropertyFromGroup("unspawnNotes", i, 'noAnimation', true)
        end
    end
end

local elapsedtime = 0;

function onUpdatePost(elapsed)
    elapsedtime = elapsedtime + elapsed;
    if not brobPart then
        setDataFromSave("Juniors Ports Stuff", "dad cam", {getProperty("barbu.x") + 500, getProperty('barbu.y') + 325})
        setProperty("barbu.x", getProperty("barbu.x") - (math.sin(elapsedtime) * 0.9))
    end

    if curStep >= 1647 then
        setShaderFloat('fresh1', 'uTime', 0)
    end

    
    if curStep >= 2767 then
        setDataFromSave("Juniors Ports Stuff", "dad cam", {getProperty("barbu.x") + 500, getProperty('barbu.y') + 325})
        local dadCamZ = getDataFromSave("Juniors Ports Stuff", "dad cam")
        dadCamZ[2] = dadCamZ[2] - 25;
        setDataFromSave("Juniors Ports Stuff", "dad cam", dadCamZ)
        setDataFromSave("Juniors Ports Stuff", "bf cam", dadCamZ)
        triggerEvent('Camera Follow Pos', ''..(dadCamZ[1]), ''..dadCamZ[2])
    end
end

function onStepHit()
    if curStep == 1647 then
        doTweenX('freshX', 'fresh1.scale', 0, 3)
        doTweenY('freshY', 'fresh1.scale', 0, 3)
        doTweenAngle("freshAngle", "fresh1", 90, 3)
        setProperty("defaultCamZoom", getProperty("defaultCamZoom") - 0.1)
    end

    if curStep == 1663 then
        doTweenY('barbu', 'barbu', getProperty("boyfriend.y") - 200, 2)
    end

    if curStep == 1711 then
        cameraFlash("hud", "FFFFFF", 1)
    end

    if curStep == 2767 then -- car
        setProperty("banduCar.x", getProperty('dad.x') - 1035)
        setProperty("banduCar.y", getProperty('dad.y') - 485)
        setProperty("banduCar.visible", true)
        setProperty("dad.visible", false)
        playAnim("banduCar", "ramBrob")
        setProperty("defaultCamZoom", getProperty("defaultCamZoom") - 0.1)
    end

    if curStep >= 2783 then
        playAnim("barbu", "stare", true)
        setProperty("vocals.volume", 0)
    end
    if curStep == 2782 then
        doTweenX('yay', 'yay.scale', 1.15, 0.6, 'sineInOut')
        doTweenY('yayq', 'yay.scale', 1.15, 0.6, 'sineInOut')
        playSound("yay", 1)
    end

    if curStep == 2767 then
        setProperty("defaultCamZoom", getProperty("defaultCamZoom") - 0.05)
    end

    if curStep == 2844 then -- brob hospital
        openCustomSubstate("hospital", true)
    end
end

function onBeatHit()
    if curBeat % 1 == 0 then
        playAnim('barbu', 'idle', true)
    end
end

function onTweenCompleted(tag)
    if tag == 'barbu' then 
        brobPart = false;
        runHaxeCode([[
            game.iconP2.changeIcon('barbu');

            game.healthBar.createFilledBar(FlxColor.fromRGB(getLuaObject('barbu', false).healthColorArray[0], getLuaObject('barbu', false).healthColorArray[1], getLuaObject('barbu', false).healthColorArray[2]), FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
		    game.healthBar.updateBar();
        ]])
    end

    if tag == 'yayq' then
        doTweenX('yay', 'yay.scale', 1, 0.1, 'sineInOut')
        doTweenY('yay!', 'yay.scale', 1, 0.1, 'sineInOut')
    end

    if tag == 'thunderBlack' then 
        setProperty("hospital.visible", true)
        setObjectCamera("thunderBlack", "other")
        doTweenX("thunderBlackLast", "thunderBlack", screenWidth, 0.5, "")
        playMusic("freshAndToasted/win-brobgonal", 1, true)
    end
end

local singAnim = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if brobPart then
        playAnim("dad", singAnim[noteData + 1], true)
        setProperty("dad.holdTimer", 0)
    else
        playAnim("barbu", singAnim[noteData + 1], true)
        setProperty("barbu.holdTimer", 0)
    end
end

function onCustomSubstateCreatePost(name)
    if name ~= 'hospital' then return; end
    setObjectOrder("thunderBlack", 999)
    scaleObject("thunderBlack", 2, 2)
    setProperty("thunderBlack.alpha", 1)
    setProperty("thunderBlack.x", -3600)
    doTweenX("thunderBlack", "thunderBlack", screenWidth - 1280, 0.5, "")

    makeLuaSprite("hospital", "main/fresh-and-toasted/yayyyyyyyyyyyyyyyyyyy-min", 0, 0)
    setObjectCamera("hospital", "other")
    scaleObject("hospital", 1.075, 1.075)
    updateHitbox("hospital")
    screenCenter("hospital")
    addLuaSprite("hospital", false)
    setProperty("hospital.visible", false)
end

function onCustomSubstateUpdate(name, elapsed)
    if getPropertyFromClass("flixel.FlxG", "keys.justPressed.ENTER") then
        playSound("confirmMenu", 1, 'fart')
    end
end

function onSoundFinished(tag) if tag == 'fart' then runHaxeCode("game.endSong();") end end