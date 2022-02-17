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

	^ { BlTextInputEvent }
	"BlKeyDownEvent."
]

{ #category : #accessing }
GtNavigationEventHandler >> getKeyName: aTextInputEvent [

	| key |
	key := aTextInputEvent text asUppercase.
	(NavigationKeys includes: key)
		ifTrue: [ ^ key ]
		ifFalse: [ ^ '' ]
]

{ #category : #accessing }
GtNavigationEventHandler >> keyDownEvent: aKeyDownEvent [

	| nav keyName |
	nav := aKeyDownEvent currentTarget.
	keyName := aKeyDownEvent key name.
	keyName = 'Backspace' ifTrue: [ 
		nav handleNavigationString: keyName.
		aKeyDownEvent consumed: true ].

	Transcript crShow: 'key down: ' , aKeyDownEvent key name
]

{ #category : #accessing }
GtNavigationEventHandler >> textInputEvent: aTextInputEvent [

	| nav keyName |
	nav := aTextInputEvent currentTarget.
	keyName := self getKeyName: aTextInputEvent.
	nav handleNavigationString: keyName.
	aTextInputEvent consumed: true
]
