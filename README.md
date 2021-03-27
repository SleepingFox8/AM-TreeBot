# TreeBot
 
TreeBot is a minecraft bot written for [advanced macros mod](https://www.curseforge.com/minecraft/mc-mods/advanced-macros) v9.2.0 that auto harvests and replants trees.

## Farm Setup

![](https://i.imgur.com/3iJRHJ4.jpg)

- Trees should be in a retangular grid of any size, with (ideally 4 but can be different) blocks of air in between every sappling.
- east-west walkways should make it so the player can walk between every tree.
- north-south walkways should allow the player to walk between the west most and east most trees in your tree farm, so the bot can change east-west rows after completing a row.
- A water collection system should be put under the walkways. Allowing for the collection of sapplings and logs that the bot will drop into the water.

## Usage

- In ``harvestTrees.lua`` assign arguments to the ``treeBot.harvestTrees(Xtrees,Ztrees, Xspacing,Zspacing)`` function call.

  - ``Xtrees`` being the number of trees east-west
  - ``Ztrees`` being the number of trees north-south
  - ``Xspacing`` being the number of east-west air blocks between each tree.
  - ``Zspacing`` being the number of north-south air blocks between each tree.

- Make sure your inventory contains a diamond axe with over 50 durability, food, and enough birch or oak sapplings to replant all the trees in your farm.

- Stand 3 blocks west from the south-west most tree in your farm.

- Run ``harvestTrees.lua``
