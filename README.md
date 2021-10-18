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

# Note

Things to note:
- When you navigate to an editor, the keys you press for the tag will actually be typed in the editor so you'll need to delete them
- For some reason, after matching a tag, you'll need to press the navigation shortcut, Ctrl + ;, twice to bring up the overlays
- Installing the navigation will require some code to be run to load the project and to install a shortcut to toggle navigation on/off
- Tag labels aren't centered in the overlays
- Some UI elements you would probably like to navigate to won't be tagged (currently candidates must be isVisibleInSpace and meet isMemberOf: BrTab,  isKindOf: BrEditor, or isKindOf: BrButton - lots of ideas how this could be enhanced.
- Navigation within a text editor to arbitrary positions (line/word starts and ends), and selecting around these points (a la  Ace Jump/Ace Jump clones) is not yet possible. I intend to have a different shortcut focus in on an element such as an editor or other element with more fine-grained destination points and then display overlays that are rooted on that element.
- The creation of the two-letter tag labels doesn't consider ergonomics or typing efficiency, e.g. certain more frequently navigated to elements could have priority so they're tagged with single letter tags or easy to access key combinations
- The instructions provided in the project's readme only show how to install the navigation shortcut into the currently focused GtWorld