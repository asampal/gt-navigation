"
# Scene Navigation Event Handler

I am a key event filter added to, typically, the world's root element. 

When the ctrl + ; shortcut is pressed, I am added as a filter if not already present, or I am removed if there.

When I am added, I also create an instance of GtNavigation which is added as a child with ID NavigationId to the world's root element.

If a an alphabetic key is pressed while I am active, I ask the GtNavigation instance to handle it.

"
Class {
	#name : #GtNavigationEventHandler,
	#superclass : #BlCustomEventHandler,
	#classVars : [
		'NavigationId',
		'NavigationKeys'
	],
	#category : #'GToolkit-Navigation-Navigation'
}

{ #category : #'class initialization' }
GtNavigationEventHandler class >> initialize [

	NavigationId := 'gtoolkit-navigation'.
	NavigationKeys := (($A to: $Z) collect: [ :char | char asString ]) 
		                  copyWith: BlKeyboardKey backspace name asString
]

{ #category : #creation }
GtNavigationEventHandler >> createNavigationFor: aNavRootElement [

	aNavRootElement
		addChild:
		(GtNavigation new initializeWith: aNavRootElement andHandler: self)
		as: NavigationId
]

{ #category : #'event handling' }
GtNavigationEventHandler >> eventsToHandle [
	^ { 
		  GtNavigationShowWish.
		  GtNavigationHideWish.
		  BlKeyDownEvent.
		  BlKeyUpEvent }
]

{ #category : #'api - accessing' }
GtNavigationEventHandler >> getKeyName: aKeyEvent [

	| key |
	key := aKeyEvent key.
	(NavigationKeys includes: key name)
		ifTrue: [ ^ key name ]
		ifFalse: [ ^ '' ]
]

{ #category : #'UI - handling' }
GtNavigationEventHandler >> hideNavigation: aNavRootElement [

	aNavRootElement
		childWithId: NavigationId
		ifFound: [ :aNavigation | aNavigation hideNavigation ]
]

{ #category : #'event handling' }
GtNavigationEventHandler >> hideNavigationEvent: aHideNavigationEvent [
	self hideNavigation: aHideNavigationEvent currentTarget
]

{ #category : #'UI - handling' }
GtNavigationEventHandler >> hideOrShowNavigationFor: aNavRootElement [

	aNavRootElement
		childWithId: NavigationId
		ifFound: [ :aNavigation | aNavigation hideNavigation ]
		ifNone: [ self createNavigationFor: aNavRootElement ]
]

{ #category : #accesing }
GtNavigationEventHandler >> inNavigationFor: focusRoot [
	<return: #Boolean>
	
	focusRoot childWithId: NavigationId ifFound: [ ^ true ].
	^ false
]

{ #category : #initialization }
GtNavigationEventHandler >> initialize [

	super initialize
]

{ #category : #'event handling' }
GtNavigationEventHandler >> keyDownEvent: aKeyDownEvent [

	| focusRoot |
	aKeyDownEvent consumed: true.
	focusRoot := aKeyDownEvent currentTarget.
	focusRoot childWithId: NavigationId ifFound: [ :navi | 
		navi handleNavigationString: (self getKeyName: aKeyDownEvent) ]
]

{ #category : #'event handling' }
GtNavigationEventHandler >> keyUpEvent: aKeyUpEvent [

	aKeyUpEvent consumed: true
]

{ #category : #'UI - handling' }
GtNavigationEventHandler >> showNavigation: aNavRootElement [

	Transcript crShow: 'Show Navigation'.
	aNavRootElement
		childWithId: NavigationId
		ifNone: [ self createNavigationFor: aNavRootElement ]
]

{ #category : #'event handling' }
GtNavigationEventHandler >> showNavigationEvent: aShowNavigationEvent [

	aShowNavigationEvent consumed: true.
	self showNavigation: aShowNavigationEvent currentTarget
]
