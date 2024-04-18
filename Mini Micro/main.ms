import "HandyFunctions" //global functions that can be used in any game mode

SaveFile = "save.txt"

//check if save file exists, generate if it doesn't
if file.readLines(SaveFile) == null then
  file.writeLines SaveFile, ["EMPTY","EMPTY","EMPTY"]
end if

globals.FilesProgress = []

SavesProgress = file.readLines(SaveFile)

//contains an array of exit numbers/EMPTY strings
for i in SavesProgress
  FilesProgress.push i
end for

//the title screen save file display expects the numbers to be actual numbers instead of strings
if not FilesProgress[0] == "EMPTY" then FilesProgress[0] = FilesProgress[0].val
if not FilesProgress[1] == "EMPTY" then FilesProgress[1] = FilesProgress[1].val
if not FilesProgress[2] == "EMPTY" then FilesProgress[2] = FilesProgress[2].val

GameMode_TitleScreen = 0
GameMode_Cutscene = 1   //not used, simply there because the original had placeholder pointers as well
GameMode_Overworld = 2  //
GameMode_Level = 3      //

GameRunningFlag = true //the game is running

//the game loads into a title screen, as you'd expect (unless you expect developer logos and such first)
GameMode = GameMode_TitleScreen

while GameRunningFlag
  if GameMode == GameMode_TitleScreen then
    //from what I can tell, this is harmless. as in, this does not generate a new instance of "TitleScreenCode" every time we execute this... which would mean this is a pretty terrible coding practice
    //I guess this is just a normal include function after all.
    import "TitleScreenCode"
 
  else if GameMode == GameMode_Cutscene then
    //nothing, because cutscenes aren't real and they can't hurt you
  else if GameMode == GameMode_Overworld then
    //nothing, because overworlds aren't real and they can't hurt you
  else if GameMode == GameMode_Level then
    //nothing, because repetitive jokes aren't real and they can't hurt you
  end if

  yield //do I need this? considering each game mode is going to have its own yield... I mean, it's not hurting anything, so might as well leave it, right?
end while

file.writeLines SaveFile, FilesProgress //saves stuff upon quitting the game

key.clear //don't spill the beans on the terminal
clear //font stays white though, have fun!