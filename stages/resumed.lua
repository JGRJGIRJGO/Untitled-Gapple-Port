function onCreate()
    makeLuaSprite('bg', '', 0, 0)
    makeGraphic('bg', ''..(1280 * 4), ''..(720 * 2), 'FFFFFF')
    updateHitbox("bg")
    screenCenter("bg", 'xy')
    addLuaSprite('bg', false)
end