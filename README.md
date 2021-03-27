# TreeBot
 
TreeBot is a minecraft bot written for [advanced macros mod](https://www.curseforge.com/minecraft/mc-mods/advanced-macros) v9.2.0 that auto harvests and replants trees.

## Farm Setup

- Farms can be a rectangle of any size.
- Trees should be in a retangular grid, with 4 block of air in between every sappling.
- east-west walkways should make it so the player can walk between every tree.
- north-south walkways should allow the player to walk between the west most and east most trees in your tree farm, so the bot can change east-west rows after completing a row.

## Usage

- In ``harvestTrees.lua`` assign ``X`` and ``Y`` in the ``treeBot.harvestTrees(X,Y)`` function call to the number of trees in your farm. ``X`` is the number of trees east-west and ``Y`` is the number of trees north-south.

- Make sure you have a diamond axe in your inventory with over 50 durability, food, and enough birch or oak sapplings in your inventory to replant all the trees in your farm.

- Stand 2 blocks west from the south-west most tree in your farm.

- Run ``harvestTrees.lua``
