--care bears UNITED  BRO

--I would've used MetaSprite function, but it doesn't work. Great.
--for props, it can be a value between 0 to 3, where:
--0 - no flips
--1 - x flip
--2 - y flip
--3 - both x and y flips
--or yolo it and use any other value and get the same result as 0 (no flips)
function Draw16x16Sprite(y,x,Tile,Props)

  XFlipFlag = false
  YFlipFlag = false

  LeftSpritesXPos = x
  RightSpritesXPos = x+8

  TopSpritesYPos = y
  BottomSpritesXPos = y+8


--I would've used a bitwise thinanigan (e.g. 0b00) but it throws errors at me and I'm too lazy to figure out what I did wrong. that's just the way of programming
  if Props == 1 or Props == 3 then
    XFlipFlag = true
    
    LeftSpritesXPos = x+8
    RightSpritesXPos = x
  end

  if Props == 2 or Props == 3 then
    YFlipFlag = true
    
    TopSpritesYPos = y+8
    BottomSpritesXPos = y
  end

  DrawSprite(Tile,LeftSpritesXPos,TopSpritesYPos,XFlipFlag,YFlipFlag,DrawMode.Sprite)
  DrawSprite(Tile+1,RightSpritesXPos,TopSpritesYPos,XFlipFlag,YFlipFlag,DrawMode.Sprite)
  DrawSprite(Tile+16,LeftSpritesXPos,BottomSpritesXPos,XFlipFlag,YFlipFlag,DrawMode.Sprite)
  DrawSprite(Tile+17,RightSpritesXPos,BottomSpritesXPos,XFlipFlag,YFlipFlag,DrawMode.Sprite)
end

function DrawFileProgress(Progress,x,y)
  TextToDraw = Progress .. "    " -- make sure the "ITS" part of EXITS doesn't remain after we clear the save file
  if tonumber(Progress) != nil then
    TextToDraw = tostring(Progress) .. " EXITS" --"plus" these strings together
  end
  DrawText(TextToDraw, x, y, DrawMode.Tile, "large", FontColor)
end


function MoveCursor(CursorChoice,InputUp,InputDown,NumOfOptions)
  if InputUp == 1 then
    PlaySound(0,0)
    if CursorChoice == 1 then
      CursorChoice = NumOfOptions --can't select non-file options
    else
      CursorChoice = CursorChoice-1
    end
  elseif InputDown == 1 then
    PlaySound(0,0)
    if CursorChoice == NumOfOptions then
      CursorChoice = 1
    else
      CursorChoice = CursorChoice+1
    end
  end
  return CursorChoice
end

--Functions can modify variables from other functions it looks like (unless Pixel Vision 8 makes them global behind the scenes... otherwise you wouldn't be able to work with variables from init in main and draw functions and such)
function BlinkCursor()
  if CursorBlinkCounter != 0 then
    CursorBlinkCounter = CursorBlinkCounter-1
  else
    CursorBlinkCounter = 15
    if ShowCursorFlag == true then
      ShowCursorFlag = false
      Cursor1YPos = 255
    else
      ShowCursorFlag = true
      Cursor1YPos = CursorPointPositions[CursorPosition1] --only cursor 1 blinks, ever
    end
  end
end

-- This array will store any buttons pressed during the current frame
  local heldButtons = {}
  local pressedButtons = {}
  local heldButtonsLastFrame = {}

-- A list of all the buttons to check on each frame
  local buttons = {
    Buttons.Up,
    Buttons.Down,
    Buttons.Left,
    Buttons.Right,
    Buttons.A,
    Buttons.B,
    Buttons.Select,
    Buttons.Start
}

--different compared to NES and Mini Micro
--shouldn't forget that in Lua, tables (basically the same thing as lists in other languages) start from index 1 instead of 0
ButtonPress_Up = 1
ButtonPress_Down = 2
ButtonPress_Left = 3
ButtonPress_Right = 4
ButtonPress_A = 5
ButtonPress_B = 6
ButtonPress_Select = 7
ButtonPress_Start = 8

MaxOptions = 6

CursorOptionsBaseXPosition = 0x56
CursorPointPositions = {0x43,0x53,0x63,0x73,0x83,0x93}

CharacterChoice_CursorYPosition = 0xB0
CharacterChoice_CursorXPositions = {0x60,0x90} --apparently I made an error in NES homebrew's x-flip sprite functionality, which meant the cursor erroneously moved 8-pixels to the left instead of flipping in place. the more you know (adjusted first value of the table from 0x68 to 0x60)


--[[
  The Init() method is part of the game's lifecycle and called a game starts.
  We are going to use this method to configure background color,
  ScreenBufferChip and draw a text box.
]]--
function Init()

  -- Here we are manually changing the background color
  BackgroundColor(0)

  local display = Display()
  
  --LoadTilemap("tilemap") --apparently this feature is broken in 1.0.0. thankfully I'm automatically loading the image, so no worries... not that I'm gonna make a game in this, haha... right?
  --...right? yeah, right.
  
  --SRAM
  FileProgressTable = {"", "", ""}
  FileProgressTable[1] = ReadSaveData("File1", "EMPTY") --if save data does not exist, default to "EMPTY"
  FileProgressTable[2] = ReadSaveData("File2", "EMPTY")
  FileProgressTable[3] = ReadSaveData("File3", "EMPTY")
  
  FileStringsBaseYPos = 9
  FileStringsBaseXPos = 22
  
  CursorPosition1 = 1
  CursorPosition2 = 1
  CursorPosition3 = 1
  
  Cursor1YPos = CursorPointPositions[CursorPosition1]
  Cursor2YPos = 255 --CursorPointPositions[CursorPosition2]
  Cursor3YPos = 255 --CursorPointPositions[CursorPosition3]
  
  Cursor1XPos = CursorOptionsBaseXPosition
  Cursor2XPos = CursorOptionsBaseXPosition --cursor 2 is the only cursor with variable x-pos (because of the character choice x-posisiotns)
  Cursor3XPos = CursorOptionsBaseXPosition
  
  TitleScreenTask = 0
  
  Cursor2XFlip = 0 --the only cursor that can be x-flipped (add other properties like this if needed)
  
  FontColor = 2 --white color
  
  CursorBlinkCounter = 15
  ShowCursorFlag = true
end

--[[
  The Update() method is part of the game's life cycle. The engine calls
  Update() on every frame before the Draw() method. It accepts one argument,
  timeDelta, which is the difference in milliseconds since the last frame.
]]--
function Update(timeDelta)
  
  --table.insert(heldButtonsLastFrame, heldButtons)
  for i=1, #pressedButtons do
    heldButtonsLastFrame[i] = heldButtons[i] --copy inputs from the last frame
  end
  
  -- reset button arrays
  heldButtons = {0,0,0,0,0,0,0,0} --purge inputs for this frame
  pressedButtons = {0,0,0,0,0,0,0,0} --presses also do not carry over
  
  
  -- Loop through all the buttons
  for i = 1, #buttons do

    -- Test if player 1's current button is down and save it to the heldButtons array
    if(Button(buttons[i], InputState.Down, 0)) then
      heldButtons[i] = 1 --InputState.Down
      
      if (heldButtonsLastFrame[i] == 0) and (heldButtons[i] == 1) then
        pressedButtons[i] = 1 --just pressed the button. yay.
      --else
        --pressedButtons[i] = 0
      end
    end
  end
  
  if TitleScreenTask == 0 then
  ------------------------
  --CHOOSING OPTIONS CODE
  ------------------------
  
  --Take your pick
  CursorPosition1 = MoveCursor(CursorPosition1,pressedButtons[ButtonPress_Up],pressedButtons[ButtonPress_Down],MaxOptions)
  Cursor1YPos = CursorPointPositions[CursorPosition1]
    
    if pressedButtons[ButtonPress_A] == 1 then
      if CursorPosition1 <= 3 then --if the cursor was on one of 3 files
        TitleScreenTask = 1
        CursorPosition2 = 1
        Cursor2XFlip = 1
        Cursor2YPos = CharacterChoice_CursorYPosition
        Cursor2XPos = CharacterChoice_CursorXPositions[CursorPosition2]
      elseif CursorPosition1 == 4 then --if the cursor was on the copy option
        TitleScreenTask = 2
        CursorPosition2 = 1
        ChoseFileToCopy = 0
        Cursor2YPos = CursorPointPositions[CursorPosition2]
      elseif CursorPosition1 == 5 then --if the cursor was on the delete option
        TitleScreenTask = 3
      elseif CursorPosition1 == 6 then
        FileProgressTable[1] = "33" --fill with fake progress
      end
    end

  ------------------------
  --SELECTED FILE CODE
  ------------------------
  elseif TitleScreenTask == 1 then

    --blink cursor
    BlinkCursor() --unlike mini script, this does work!

    if pressedButtons[ButtonPress_Right] == 1 or pressedButtons[ButtonPress_Left] == 1 then
      if CursorPosition2 == 1 then --feels crude if you ask me, but it just works. but I doubt you ask me, so...
        CursorPosition2 = 2
        Cursor2XFlip = 0
      else
        CursorPosition2 = 1
        Cursor2XFlip = 1
      end
      --CursorPosition2 = not CursorPosition2 --I don't think you can do the logical not (xor/EOR) with a number like this, unlike Mini Micro (unless I did it wrong ofc)
      
      Cursor2XPos = CharacterChoice_CursorXPositions[CursorPosition2] --don't forget to update the x-pos... maybe
    end

    if pressedButtons[ButtonPress_B] == 1 then
      PlaySound(1,1)
      TitleScreenTask = 0
      Cursor1YPos = CursorPointPositions[CursorPosition1] --cursor 1 is definitely on screen
      Cursor2YPos = 255 --remove cursor 2
      Cursor2XFlip = 0 --not flipped by default
      Cursor2XPos = CursorOptionsBaseXPosition --default it on options
    end
    
  ------------------------
  --SELECTED COPY CODE
  ------------------------
  elseif TitleScreenTask == 2 then
  
    BlinkCursor()
  
    ------------------------
    --CHOOSE FILE TO COPY
    ------------------------
    if ChoseFileToCopy == 0 then
    
      CursorPosition2 = MoveCursor(CursorPosition2,pressedButtons[ButtonPress_Up],pressedButtons[ButtonPress_Down],MaxOptions-3)
      Cursor2YPos = CursorPointPositions[CursorPosition2]
    
      --A and B buttons here
      if pressedButtons[ButtonPress_A] == 1 then
        ChoseFileToCopy = 1 --yes, we are going to copy stuff over
        
        if CursorPosition2 == 1 then
          CursorPosition3 = 2 --do not spawn on top of the previous cursor
        else
          CursorPosition3 = 1
        end
        
        Cursor3YPos = CursorPointPositions[CursorPosition3] --show up on-screen
        
      elseif pressedButtons[ButtonPress_B] == 1 then
        PlaySound(1,1)
        TitleScreenTask = 0
        Cursor1YPos = CursorPointPositions[CursorPosition1] --cursor 1 is definitely on screen
        Cursor2YPos = 255 --remove cursor 2
      end

    ------------------------
    --CHOOSE FILE TO PASTE
    ------------------------
    else
      ::RepeatCursor3Movement::
      
      CursorPosition3 = MoveCursor(CursorPosition3,pressedButtons[ButtonPress_Up],pressedButtons[ButtonPress_Down],MaxOptions-3)
      Cursor3YPos = CursorPointPositions[CursorPosition3]
      
      if CursorPosition3 == CursorPosition2 then
        goto RepeatCursor3Movement --make sure it doesn't overlap with cursor 2
      end
    
      --A and B buttons here
      if pressedButtons[ButtonPress_A] == 1 then
        FileProgressTable[CursorPosition3] = FileProgressTable[CursorPosition2] --copy progress over
      elseif pressedButtons[ButtonPress_B] == 1 then
        PlaySound(1,1)
        ChoseFileToCopy = 0 --not copying stuff
        Cursor3YPos = 255 --remove cursor 3
      end
      
    end

  ------------------------
  --SELECTED DELETE CODE
  ------------------------
  elseif TitleScreenTask == 3 then

    BlinkCursor()

    CursorPosition2 = MoveCursor(CursorPosition2,pressedButtons[ButtonPress_Up],pressedButtons[ButtonPress_Down],MaxOptions-3)
    Cursor2YPos = CursorPointPositions[CursorPosition2]

    if pressedButtons[ButtonPress_A] == 1 then
      FileProgressTable[CursorPosition2] = "EMPTY" --no progress
    elseif pressedButtons[ButtonPress_B] == 1 then
      PlaySound(1,1)
      TitleScreenTask = 0 --not copying stuff
      Cursor2YPos = 255 --remove cursor 2
    end

  end
end

--[[
  The Draw() method is part of the game's life cycle. It is called after
  Update() and is where all of our draw calls should go. We'll be using this
  to render sprites to the display.
]]--
function Draw()

  -- We can use the RedrawDisplay() method to clear the screen and redraw
  -- the tilemap in a single call.
  RedrawDisplay()

  DrawFileProgress(FileProgressTable[1],FileStringsBaseXPos,FileStringsBaseYPos)
  DrawFileProgress(FileProgressTable[2],FileStringsBaseXPos,FileStringsBaseYPos+2)
  DrawFileProgress(FileProgressTable[3],FileStringsBaseXPos,FileStringsBaseYPos+4)

  --A BROKEN FEATURE???
  --DrawMetaSprite("Cursor", CursorOptionsBaseXPosition, CursorPointPositions[2],false,false,DrawMode.Sprite)
  
  Draw16x16Sprite(Cursor1YPos,Cursor1XPos,14,0)
  Draw16x16Sprite(Cursor2YPos,Cursor2XPos,14,Cursor2XFlip) --< v update these ones... even if they're offscreen
  Draw16x16Sprite(Cursor3YPos,Cursor3XPos,14,0)
end

--when the game is, WELL, shut down
function Shutdown()
  WriteSaveData("File1", FileProgressTable[1]) --save progress that we most certainly didn't spawn from nowhere
  WriteSaveData("File2", FileProgressTable[2])
  WriteSaveData("File3", FileProgressTable[3])
end