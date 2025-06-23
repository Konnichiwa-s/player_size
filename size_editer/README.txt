==========================================
 Size Editor Mod for Minetest/Multicraft
==========================================

A powerful mod that allows players to adjust their character size with simple commands. Perfect for roleplaying servers, adventure maps, or just having fun!

■■■ Features ■■■
- Wide size range: 0.001 (microscopic) to 20.0 (giant)
- Precise size controls with commands
- Realistic physics and collision scaling
- Visual particle effects during size changes
- Privilege system for server control
- Size persistence between sessions
- Mobile-friendly (works on Android)

■■■ Commands ■■■
All commands require 'size_edit' privilege:

1. /setsize <size> 
   Set exact size (0.001-20.0)
   Example: /setsize 0.05

2. /small <amount> 
   Decrease size (1-100 levels)
   Each level = 1% size reduction
   Example: /small 10 (10% smaller)

3. /large <amount> 
   Increase size (1-100 levels)
   Each level = 1% size increase
   Example: /large 5 (5% larger)

4. /super_small
   Become extremely small (size 0.01)

5. /micro
   Become microscopic (size 0.001)

6. /super_large
   Become giant (size 20.0)

7. /normal_size
   Return to normal size (1.0)

■■■ Privileges ■■■
- 'size_edit' privilege required for all commands
- Grant to players: /grant <player> size_edit
- Revoke from players: /revoke <player> size_edit

■■■ Installation ■■■
1. Create folder 'size_editer' in your mods directory
2. Place init.lua inside the folder
3. Enable in minetest.conf:
   load_mod_size_editer = true

For multiplayer servers:
4. Grant privileges to players:
   /grant <player> size_edit

■■■ Configuration ■■■
Add to minetest.conf for customization:

# Minimum allowed size (default: 0.001)
size_editer.min_size = 0.001

# Maximum allowed size (default: 20.0)
size_editer.max_size = 30.0

# Step per level (default: 0.01)
size_editer.step_size = 0.01

■■■ For Server Owners ■■■
To allow all players to resize themselves, add to minetest.conf:
basic_privs = interact, shout, size_edit

■■■ Notes ■■■
- Size changes show particle effects
- Physics automatically adjust to size:
  • Smaller = faster movement, higher jumps
  • Larger = slower movement, lower jumps
- Size is saved between game sessions

■■■ License ■■■
MIT License - Free for all uses with attribution

■■■ Created with ❤️ for the Minetest community ■■■
