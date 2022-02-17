"
I take a root BlElement and iterate through my children. For those elements that are visible and of certain UI types I create a BlOverlayElement referencing these. Each overlay is tagged with a two letter key combination.

I handle key names as input and build up a currentTag name from these. Backspace is allowed to delete a wrongly typed key. If the currentTag matches the label on one of the overlays I manage, I hide all overlays and simulate a click on the BlElement that is referenced by the matching overlay.
"
Class {
	#name : #GtNavigation,
	#superclass : #BlElement,
	#instVars : [
		'targetContainer',
		'leftIndex',
		'rightIndex',
		'currentTag',
		'overlays',
		'inputStatus'
	],
	#classVars : [
		'LeftHandKeys',
		'RightHandKeys'
	],
	#classInstVars : [
		'targetContainer',
		'inputStatus'
	],
	#category : #'GToolkit-Navigation-UI'
}

{ #category : #initialization }
GtNavigation class >> initialize [
	RightHandKeys := 'JKLHYUIOPNM'.
	LeftHandKeys := 'FDSAGTREWQBVCXZ'
]

{ #category : #'instance creation' }
GtNavigation class >> new [

	self error: 'Do not create an instance of ' , self name
		, ' using new. Please use #rootedAt:as: instead'
]

{ #category : #'instance creation' }
GtNavigation class >> rootedAt: aNavRootElement as: aName [

	^ self basicNew initializeWith: aNavRootElement as: aName
]

{ #category : #accessing }
GtNavigation >> getTagElementFor: anElement label: aLabel [

	^ overlays
		  at: aLabel
		  ifPresent: [ :tag | "If found, we still want to ensure it's to anElement" 
			  tag attachTo: anElement ]
		  ifAbsentPut: [ GtNavigationTag on: anElement labeledAs: aLabel ]
]

{ #category : #processing }
GtNavigation >> handleNavigationString: aKeyName [

	aKeyName isEmpty ifTrue: [ ^ self ].
	Transcript crShow: 'key is: ' , aKeyName.
	aKeyName = 'Backspace'
		ifTrue: [ 
			(currentTag size between: 1 and: 2) ifTrue: [ 
				currentTag := currentTag allButLast ].
			inputStatus text: currentTag.
			^ self ]
		ifFalse: [ 
			currentTag size = 2 ifTrue: [ ^ self ].
			currentTag := (currentTag , aKeyName) asSymbol.
			inputStatus text: currentTag.
			self childNamed: currentTag ifFound: [ :tag | 
				self hideNavigation.
				tag simulateClickOnReference.
				overlays valuesDo: [ :aTag | aTag detach ] ] ]
]

{ #category : #accessing }
GtNavigation >> hideNavigation [

	self removeChildren.
	self parent removeChild: self
]

{ #category : #initialization }
GtNavigation >> initializeWith: aRootElement as: aName [

	super initialize.
	leftIndex := 1.
	rightIndex := 1.
	currentTag := ''.
	overlays ifNil: [ overlays := Dictionary new ].
	targetContainer := aRootElement.
	targetContainer addChild: self as: aName.
	inputStatus ifNil: [ inputStatus := GtNavigationStatus for: self ].
	inputStatus text: ''.
	self addChild: inputStatus.
	self
		size: aRootElement extent;
		clipChildren: false;
		setOverlays;
		addEventHandler: GtNavigationEventHandler new
]

{ #category : #processing }
GtNavigation >> nextClickTag [

	| tag |
	tag := (LeftHandKeys at: leftIndex) asString
	       , (RightHandKeys at: rightIndex) asString.
	leftIndex := leftIndex + 1.
	leftIndex > LeftHandKeys size ifTrue: [ 
		rightIndex := rightIndex + 1.
		rightIndex > RightHandKeys size ifTrue: [ rightIndex := 1 ].
		leftIndex := 1 ].
	^ tag asSymbol
]

{ #category : #accessing }
GtNavigation >> setOverlays [

	| selectTargets label tag |
	selectTargets := [ :element | 
	                 element ~= self & element isVisibleInSpace ifTrue: [ 
		                 (element isMemberOf: BrTab)
		                 | (element isKindOf: BrEditor)
		                 | (element isKindOf: BrButton)
		                 | (element isKindOf: BrExpander) ifTrue: [ 
			                 label := self nextClickTag.
			                 tag := self getTagElementFor: element label: label.
			                 self
				                 addChild: tag as: label;
				                 clipChildren: false ].
		                 element children do: selectTargets ] ].

	targetContainer children do: selectTargets
]
