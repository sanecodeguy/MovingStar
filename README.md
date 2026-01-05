# x86 Assembly Maze Game 

To compile and run this game, use **vimasm** to open the source and **Nc** to build and execute:

```bash
sudo pacman -Syu nasm dosbox neovim wget unzip
yay -S vimasm 
vimasm main.asm
Nc 

```
## Demo 
<img width="765" height="490" alt="image" src="https://github.com/user-attachments/assets/77201635-6aaf-4a1f-8077-da9efbf43a13" />

---

## Game Summary

### 1. Controls & Input (`render.asm`)

* **Keyboard Polling**: Uses `INT 16h` to check for key presses.
* **Movement Keys**:
* **Left (4Bh)** / **Right (4Dh)**.
* **Up (48h)** / **Down (50h)**.


* **Direction**: Updates a `direction` byte (0=Left, 1=Right, 2=Up, 3=Down).

### 2. Game Logic (`main.asm` & `render.asm`)

* **Timer Interrupt**: Hooks `INT 08h` to update the player position based on the system clock.
* **Movement Mechanics**:
* **Star Positioning**: The player is represented by the `*` character (attribute `1Fh`).
* **Screen Wrapping**: Includes logic to wrap the player around the top and bottom edges of the screen.


* **Collision Detection**:
* **Green Obstacles (`0x2F20`)**: Triggers the `lost` state.
* **Red Goal (`0x4000`)**: Triggers the `won` state.



### 3. Visuals (`utils.asm`)

* **Screen Buffer**: Direct writes to segment `0xB800`.
* **Clear Screen**: Fills the background with a solid block character (`0x0FDB`).
* **Map Generation**: The `drawobs` routine hardcodes several rectangular barriers and a starting goal block using the `blocks` function.

### 4. End States (`render.asm`)

* **Win**: Displays "YOU WON" in green and exits to DOS via `INT 21h`.
* **Loss**: Displays "GAME OVER" in red and exits to DOS.



