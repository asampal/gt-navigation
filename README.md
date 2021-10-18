# gt-navigation

# Load the project

```smalltalk
Metacello new
  baseline: 'GToolkitNavigation';
  reposblitory: 'github://asampal/gt-navigation:main/src';
  load.
```

# Install the shortcut to toggle navigation on/off

Note that the following only installs the shortcut for navigation into the focused GtWorld. You can instead iterate over all worlds to set for all. Ideally the shortcut should be installed whenever a world opens.

```smalltalk
root := (GtWorld allInstances detect: [:world | world focused]) root.
root addShortcut: (BlShortcutWithAction new 
	combination: (BlKeyCombination builder control; key: BlKeyboardKey semicolon; build);
	action: [ 
		root eventDispatcher filters 
			detect: [:filter| filter class = GtNavigationEventHandler] 
			ifFound: [:filter |
				"self inform: 'Hide Navigation'."
				filter hideNavigation: root.
				root removeEventFilter: filter]
			ifNone: [| filter filters |
				"self inform: 'Show Navigation'."
				filter := GtNavigationEventHandler new.
				root addEventFilter: filter.
				filter showNavigation: root.]])
```

# To remove the shortcut, do something like the following:

Since there is no (currently) other shortcut installed at this level, removing all should be safe. 

```smalltalk
world := GtWorld allInstances detect: [:world | world focused].
world root eventDispatcher shortcutHandler shortcuts removeAll; compact
```

# To remove the GtNavigationEventHandler

In case you need to manually remove it run something like the following:

```smalltalk
world root removeEventFiltersSuchThat: [:filter | filter class = GtNavigationEventHandler].
```