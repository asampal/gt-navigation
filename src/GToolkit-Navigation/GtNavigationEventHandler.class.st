Class {
	#name : #GtNavigationEventHandler,
	#superclass : #BlCustomEventHandler,
	#classVars : [
		'NavigationKeys'
	],
	#category : #'GToolkit-Navigation-Navigation'
}

{ #category : #'class initialization' }
GtNavigationEventHandler class >> initialize [

	NavigationKeys := (($A to: $Z) collect: [ :char | char asString ]) 
		                  copyWith: BlKeyboardKey backspace name asString
]

{ #category : #accessing }
GtNavigationEventHandler >> eventsToHandle [

	^ { BlKeyDownEvent }
]

{ #category : #accessing }
GtNavigationEventHandler >> getKeyName: aKeyEvent [

	| key |
	key := aKeyEvent key.
	(NavigationKeys includes: key name)
		ifTrue: [ ^ key name ]
		ifFalse: [ ^ '' ]
]

{ #category : #accessing }
GtNavigationEventHandler >> keyDownEvent: aKeyDownEvent [

	| navi keyName |
	navi := aKeyDownEvent currentTarget.
	keyName := self getKeyName: aKeyDownEvent.
	navi handleNavigationString: keyName.
	aKeyDownEvent consumed: true
]
