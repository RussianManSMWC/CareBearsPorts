#Care Bears Go To Pyxel

import pyxel
from enum import Enum
from TitleScreenCode import TitleScreen

#define our custom font (x/y positions within the sprite sheet)
CustomFontX = {
'!':80,
'.':88,
'-':96,
',':104,
'?':112,
'A':0,
'B':8,
'C':16,
'D':24,
'E':32,
'F':40,
'G':48,
'H':56,
'I':64,
'J':72,
'K':80,
'L':88,
'M':96,
'N':104,
'O':112,
'P':120,
'Q':0,
'R':8,
'S':16,
'T':24,
'U':32,
'V':40,
'W':48,
'X':56,
'Y':64,
'Z':72,
'1':0,
'2':8,
'3':16
#add more numbers if necessary
}

CustomFontY = {
'!':8,
'.':8,
'-':8,
',':8,
'?':8,
'A':0,
'B':0,
'C':0,
'D':0,
'E':0,
'F':0,
'G':0,
'H':0,
'I':0,
'J':0,
'K':0,
'L':0,
'M':0,
'N':0,
'O':0,
'P':0,
'Q':8,
'R':8,
'S':8,
'T':8,
'U':8,
'V':8,
'W':8,
'X':8,
'Y':8,
'Z':8,
'1':16,
'2':16,
'3':16
#add more numbers if necessary
}

#I don't think we need to change this in any of the game modes... or load these, because, y'know... error
SpritesImageBank = 0
FontImageBank = 1

# define this """game"""
class GameButNotReally:

    #keyboard keys corrsponding to these buttons
    KeyAssignment_Right = pyxel.KEY_RIGHT
    KeyAssignment_Left = pyxel.KEY_LEFT
    KeyAssignment_Down = pyxel.KEY_DOWN
    KeyAssignment_Up = pyxel.KEY_UP
    KeyAssignment_Start = pyxel.KEY_RETURN #a non-num-pad enter key? yes it is.
    KeyAssignment_Select = pyxel.KEY_RSHIFT
    KeyAssignment_B = pyxel.KEY_Z
    KeyAssignment_A = pyxel.KEY_X

    FilesProgress = ['','','']
    #attempt to open a save.txt save file
    SaveFile_File = "save.txt" #this isn't confusing in the slightest
    try:
        with open(SaveFile_File, "r") as SaveFile:
            a = 0
            for i in SaveFile.readlines():
                FilesProgress[a] = i #load progress from the save file
                a+=1
    except:
        with open(SaveFile_File,"w") as SaveFile:
            SaveFile.writelines(['EMPTY\n', 'EMPTY\n', 'EMPTY\n']) #create a save file... file
            FilesProgress = ['EMPTY\n', 'EMPTY\n', 'EMPTY\n'] #empty progress by default
    
    #classes are the bane of my existence! apparently
    class GameMode(Enum):
        TitleScreen = 0
        Cutscene = 1
        Overworld = 2
        Level = 3
        
    class TitleScreenTask(Enum):
        Selecting = 0
        ChoseFile = 1
        ChoseCopy = 2
        ChoseErase = 3

#these should be inherited by any other class I would hope!!
#coords - a list containing x and y coordinates for the string
    def DrawString(self,coords,String):
        x = 0
        for i in String:
            try:
                pyxel.blt(coords[0]+x, coords[1], FontImageBank, CustomFontX[i], CustomFontY[i], 8, 8, 0)
            except: #this will occure for spaces or any other characters that aren't defined
                pass #nothing happens
            x+=8 #move onto next character

#not necessary, but makes the code looks a little bit nicer I feel
#pos, GFXpos and dimensions must be lists/topples with exactly 2 values
    def DrawSprite(self,pos,GFXpos,dimensions):
        pyxel.blt(pos[0], pos[1], SpritesImageBank, GFXpos[0], GFXpos[1], dimensions[0], dimensions[1],0)

    BackAreaColor = 2 #can change if necessary (in title screen, it targets the sky-blue color)

    def __init__(self):
        pyxel.init(256, 240, title="Care Bears UNITED BRO", fps=60) #same resolution as NES (+overscan) (actually, the window is triple size for me... but the inside resolution is the same)
        
        pyxel.load("sfx.pyxres") #contains two very basic sound effects (that aren't the same as in Pixel Vision 8 version's)
        
        #0xFF00FF - transparency in sprite sheets
        #define our palette (for the title screen at least)
        Palette = [0xFF00FF,0x000000,0xB5EBF2,0xFFFFFF,0x48CDDE,0xD3D2FF,0xEA9E22,0xFE6ECC,0xFBC2FF]
        j = 0
        for i in Palette:
            pyxel.colors[j] = i
            j = j + 1
        pyxel.images[SpritesImageBank].load(0, 0, "gfx/sprites.png") #default everything but font on page 0
        pyxel.images[FontImageBank].load(0, 0, "gfx/font.png")

        #add more variables here if needed
        self.GameMode = self.GameMode.TitleScreen
        self.TitleScreenTask = self.TitleScreenTask.Selecting

        pyxel.run(self.update, self.draw)

    def update(self):
        #how else do you handle this?? the game shuts down before it can even process this.
        #The best I've got is to do this every frame, which isn't ideal as you can imagine, having to constantly open to write to a file. how else are you supposed to handle SRAM (save data)??
        with open("save.txt", "w") as SaveFile:
            for i in self.FilesProgress:
                SaveFile.writelines(i)

        GameMode = self.GameMode
        
        #I have to retract that statement I made in Mini Micro version where I said it doesn't have cases just like Python. Turns out Python does have cases now, apparently.
        match GameMode:
            case GameMode.TitleScreen:
                TitleScreen.run(self)

            case GameMode.Cutscene:
                pass

            case GameMode.Overworld:
                pass

            case GameMode.Level:
                pass

        if pyxel.btnp(pyxel.KEY_Q):
            pyxel.quit()

    def draw(self):
    
        pyxel.cls(self.BackAreaColor)
        GameMode = self.GameMode #self sucks (but we'll be seeing more of it)
        #you're telling me there ARE cases in python??? oh, right, they were was added in Python 3.10
        match GameMode:
            case GameMode.TitleScreen:
                TitleScreen.draw(self)

            case GameMode.Cutscene:
                pass

            case GameMode.Overworld:
                pass

            case GameMode.Level:
                pass #you may pass on this one

GameButNotReally() #this will execute the game that we defined just above