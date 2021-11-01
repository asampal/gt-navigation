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

	| nav |
	nav := GtNavigation
		       rootedAt: aNavRootElement
		       as: NavigationId
		       withHandler: self.
	aNavRootElement space focusOwner: nav
]

{ #category : #'event handling' }
GtNavigationEventHandler >> eventsToHandle [

	^ { 
		  GtNavigationShowWish.
		  GtNavigationHideWish.
		  BlKeyDownEvent.
		  BlTextInputEvent }
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

	| keyName |
	aKeyDownEvent currentTarget
		childWithId: NavigationId
		ifFound: [ :navi | 
			keyName := self getKeyName: aKeyDownEvent.
			navi handleNavigationString: keyName.
			aKeyDownEvent consumed: true ]
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

{ #category : #'api - accessing' }
GtNavigationEventHandler >> textInputEvent: aTextInputEvent [

	aTextInputEvent currentTarget eventDispatcher handlersDo: [ :handler | 
		handler class = BlOverlayListener ifTrue: [ 
			Transcript crShow: 'true' ] ].

	aTextInputEvent currentTarget
		childWithId: NavigationId
		ifFound: [ :aNavigation | aTextInputEvent consumed: true ]
]
