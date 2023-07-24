

local Game = require 'src/screens/game'
local Title = require 'src/screens/title'

local game, title, currentScreen, highScore
local started = false

local dimensions = {
    w = 320,
    h = 480,
}

local colors = {
    yellow = {255, 182, 25},
    violet = {184, 0, 255},
    purple = {86, 6, 114},
    lightGreen = {20, 204, 123},
    darkGreen = {9, 178, 104},
    black = {25, 25, 25},
    white = {255, 255, 255},
    lightBlue = {27, 174, 204},
}

function love.load()
    love.window.setMode(dimensions.w, dimensions.h)
    local saveFile = love.filesystem.newFile('save.txt')
    saveFile:open('r')
    local data = saveFile:read()

    if highScore == nil then
        highScore = 0
    else
        highScore = tonumber(data)
    end

    
    math.randomseed(os.time())

    title = Title.create{
        dimensions = dimensions,
        colors = colors,
    }

    
    game = Game.create{
        highScore = highScore,
        dimensions = dimensions,
        colors = colors,
    }

    
    currentScreen = title
    currentScreen:load()
end

function love.update(dt)
    love.window.setTitle("Dinojump")
    currentScreen:update(dt)

    
    if not started and love.keyboard.isDown("space") then
        started = true
        currentScreen = nil
        currentScreen = game
        currentScreen:load()
    end

    if currentScreen == game and currentScreen:isOver() and love.keyboard.isDown("r") then
        if game.score.value > highScore then
            highScore = math.floor(game.score.value)
        end

        currentScreen = nil
        game = nil
        game = Game.create{
            dimensions = dimensions,
            colors = colors,
            highScore = highScore
        }
        currentScreen = game
        currentScreen:load()
     end
end