#Requires AutoHotkey v2.0
^+1::{
  SoundBeep(523, 500)
  FileAppend("test text\n", "C:\Users\colli\OneDrive\Documents\AutoHotkey\write_file.txt")
}
