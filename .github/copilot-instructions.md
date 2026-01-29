This is a game about rolling dices to earn gold and unlock new dice types.

The code uses Godot's GDScript and follows standard practices for signal emission and state management. It should be Godot 4 compatible. Gdscript 2.0 shall be used.

Don't include obvious comments.

# Coding standards.

Internal functions and variables should be prefixed with an underscore (_).
External functions and variables should not be prefixed.

The order of members in a script should be:
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
	1. _init()
	2. _enter_tree()
	3. _ready()
	4. _process()
	5. _physics_process()
	6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses

# Documentation

In gdscript you can document code like this:

- A brief description of the script.
- Detailed description.
- Tutorials and deprecated/experimental marks.

Example:
```gdscript
extends Node2D
## A brief description of the class's role and functionality.
##
## The description of the script, what it can do,
## and any further detail.
##
## @tutorial:             https://example.com/tutorial_1
## @tutorial(Tutorial 2): https://example.com/tutorial_2
## @experimental
```

Don't add comments for obvious code.
Don't add documentation for onready variables unless necessary.