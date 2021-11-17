This is an engine that does stuff
wip tho but feel free to use

# This engine support gamejolt crap, so if you don't want gamejolt stuff, remove `<define name="GAMEJOLT_ALLOWED" />` in the `Project.xml` file.

If you DO want GameJolt stuff, follow these steps below.

You have to install some libraries, so do these commands in order (a terminal or some crap, MAKE SURE YOU HAVE GIT INSTALLED):
```
haxelib git tentools https://github.com/TentaRJ/tentools.git
haxelib git systools https://github.com/haya3218/systools
haxelib run lime rebuild systools [windows, mac, linux]
```

I removed a file in source because I'm not supposed to show them, but it is required. So, create a new file in source and call it `GJKeys.hx`, then copy and paste this:
```haxe
package;

class GJKeys
{
    public static var id:Int = 	0; // Put your game's ID here
    public static var key:String = ""; // Put your game's private API key here
}
```
### DO NOT SHARE YOUR KEY TO ANYONE! It's supposed to be private and bad shit can happen if you share it.
### You can find your game id and private key on your GameJolt page.

If you want to achieve a trophy of some sort in a certain state, make sure it has this:
```haxe
#if GAMEJOLT_ALLOWED
import GameJolt.GameJoltAPI;
#end
```
# If it does not have this, then add it.

Now, add this code to wherever you want the player to achieve it or some crap:
```haxe
#if GAMEJOLT_ALLOWED
GameJoltAPI.getTrophy(trophyID); //replace trophyID with the Trophy ID of the trophy you want. man, so many trophies.
#end
```
Once done, you should be ready to go.
If you want to change some crap in the login screen, go to `GameJolt.hx`, press Ctrl+F and type in `GameJoltLogin` and you should be there.