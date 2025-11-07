# atsync

Simple command line program to save and automatize rsync tasks.

FLAGS:
- autorecursion: every time it synchronizes a directory it automatically does so recursively
  
  Commands:
  - atsync autorecursion on : it activate the autorecursion
  - atsync autorecursion off: it deactivate the autorecursion 
  - atsync autorecursion chk: it return the present value of the flag

PROFILE COMMAND: profiles are like different folders where you store the paths and options of the synchronizing process.

- atsync profile add name: it create a profile with name 'name'

- atsync profile select name: it selecte the specified profile
- atsync profile remove name: it remove the specified profile
- atsync profile print: it print he list of pahts stored in the current profile
- atsync profile chk: it print the name of the current profile

PATHS COMMANDS: once you selected a profile with atsync profile select 'name' you can:

- atsync add source_path target_path options: this will add a source a target and the options for rsync to use
- atsync print: this will print all the saved paths in the selected profile
- atsync sync all: this will synchronize all the paths in the current profile
- atsync sync n: this will synchronize the n-th paths as printed with the command atsync print

