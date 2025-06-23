# Size Editor Mod for Minetest

A powerful mod that allows players to adjust their character size with simple commands. Perfect for roleplaying servers, adventure maps, or just having fun!

## Features

- **Wide Size Range**: From microscopic (0.001) to giant (20x normal size)
- **Precise Controls**: Set exact sizes or adjust incrementally
- **Physics Scaling**: Realistic movement and collision adjustments
- **Visual Effects**: Particle effects during size changes
- **Privilege System**: Server-controlled access to commands
- **Persistence**: Size saved between sessions
- **Mobile-Friendly**: Works perfectly on Android devices

## Commands

All commands require the `size_edit` privilege:

| Command | Parameters | Description | Default |
|---------|------------|-------------|---------|
| `/setsize` | `<size>` | Set exact size (0.001-20.0) | - |
| `/small` | `<amount>` | Decrease size (1-100 levels) | 1 |
| `/large` | `<amount>` | Increase size (1-100 levels) | 1 |
| `/super_small` | - | Become extremely small (0.01) | - |
| `/micro` | - | Become microscopic (0.001) | - |
| `/super_large` | - | Become giant (20.0) | - |
| `/normal_size` | - | Return to normal size (1.0) | - |

**Note**: Each level = 1% size change (0.01)

## Privileges

- `size_edit` - Allows players to use size commands
- Grant with `/grant <player> size_edit`
- Revoke with `/revoke <player> size_edit`
