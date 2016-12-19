# Description:
#   Remembering the good ol days when things were simpler
#
# Commands:
#   memberberries member <something from the good ol days>? - See if Memberberries member something
#
# Author:
#   Bennettaur
#
# Based on MartinPetkov's NostalgiaBot

fs = require 'fs'
request = require 'request'

toTitleCase = (str) ->
    str.replace /\w\S*/g, (txt) ->
        txt[0].toUpperCase() + txt[1..txt.length - 1].toLowerCase()

memoryFile = "member.txt"
memories = (fs.readFileSync memoryFile, 'utf8').toString().split("\n").filter(Boolean)

responses = ["Oh yeah! I member!", "Oh yeah, I love newMemory!", "Ohh, I member!"]
suggestMemories = ["Member oldMemory?", "Hey, member oldMemory?", "Yeah! Member oldMemory?", "member?"]

member = (res) ->
    memory = res.match[1].trim()

    if (memory == "")
        return

    memoryIndex = memories.indexOf(memory)
    if (memoryIndex < 0)
        res.send "I member!"
        usedMemories = []
    else
        response = res.random responses
        res.send response.replace("newMemory", memory)
        usedMemories = [memoryIndex]

    numNewMemories = Math.min(Math.floor(Math.random() * 4), memories.length)

    for i in [0...numNewMemories]
        oldMemoryIndex = Math.floor(Math.random() * memories.length)
        if (usedMemories.indexOf(oldMemoryIndex) < 0)
            oldMemory = memories[oldMemoryIndex]
            usedMemories.push(oldMemoryIndex)
            suggestMemory = res.random suggestMemories
            res.send suggestMemory.replace("oldMemory", oldMemory)

    if (res.message.user.name == "tom")
        if (Math.floor(Math.random() * 100) > 40)
            res.send "@tom Member when you stole @michael's Star Wars mug?"
        else
            res.send "@tom We're going to f*@king kill you, member?"

    if (memories.indexOf(memory) < 0)
        memories.push(memory)

        # Write entire list of memories to memoryFile
        fs.writeFileSync(memoryFile, '')
        for m in memories
            do (m) ->
                fs.appendFileSync(memoryFile, "#{m}\n")

module.exports = (robot) ->
    robot.respond /member (.*)\?+/i, member
