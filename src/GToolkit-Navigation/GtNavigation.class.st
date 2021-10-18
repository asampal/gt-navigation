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
		'navigationEventHandler',
		'currentTag',
		'overlays'
	],
	#classVars : [
		'LeftHandKeys',
		'RightHandKeys'
	],
	#category : #'GToolkit-Navigation-UI'
}

{ #category : #initialization }
GtNavigation class >> initialize [
	RightHandKeys := 'JKLHYUIOPNM'.
	LeftHandKeys := 'FDSAGTREWQBVCXZ'
]

{ #category : #processing }
GtNavigation >> createTagFrom: aLabel [

	^ BlElement new
		  constraintsDo: [ :c | 
			  c ignoreByLayout.
			  c ignored horizontal alignCenter.
			  c ignored vertical alignCenter ];
		  size: 20 @ 20;
		  elevation: (BlRelativeElevation elevation: 10);
		  geometry: BlCircle new;
		  aptitude: (BrStyleCommonAptitude new default: [ :aStyle | 
					   aStyle border: (BlBorder
								    paint:
									    (BrTheme default button textHighlightColor alpha: 0.9)
								    width: 2).
					   aStyle background:
							   (BrTheme default button textHighlightColor alpha: 0.9) ]);
		  addChild:
			  (BlElement new aptitude: (BrGlamorousTextLabelAptitude new
						    foreground: Color black;
						    fontSize: 14;
						    padding: (BlInsets all: 1);
						    bold;
						    text: aLabel))
]

{ #category : #processing }
GtNavigation >> handleNavigationString: aKeyName [

	aKeyName isEmpty ifTrue: [ ^ self ].
	aKeyName = 'Backspace'
		ifTrue: [ 
			(currentTag size between: 1 and: 2) ifTrue: [ 
				currentTag := currentTag allButLast ].
			^ self ]
		ifFalse: [ 
			currentTag size = 2 ifTrue: [ ^ self ].
			currentTag := currentTag , aKeyName.
			self
				childNamed: currentTag
				ifFound: [ :tag | "self inform: 'Acting on ' , tag asString."
					self hideNavigation.
					tag simulateClickOnReference.
					overlays valuesDo: [ :overlay | overlay detach ] ] ]
]

{ #category : #accessing }
GtNavigation >> hideNavigation [

	navigationEventHandler handleEvent:
		(GtNavigationHideWish new currentTarget: targetContainer)
]

{ #category : #initialization }
GtNavigation >> initialize [

	super initialize.
	leftIndex := 1.
	rightIndex := 1.
	currentTag := ''.
	overlays := Dictionary new
]

{ #category : #initialization }
GtNavigation >> initializeWith: aRootElement andHandler: aNavigationEventHandler [

	| selectTargets tag label |
	targetContainer := aRootElement.
	self size: aRootElement extent.
	navigationEventHandler := aNavigationEventHandler.

	selectTargets := [ :element | 
	                 element isVisibleInSpace ifTrue: [ 
		                 ((element isMemberOf: BrTab) or: [ 
			                  (element isKindOf: BrEditor) or: [ 
				                  (element isKindOf: BrButton) or: [ 
					                  element isKindOf: BrExpander ] ] ]) ifTrue: [ 
			                 label := self nextClickTag.
			                 tag := self createTagFrom: label.
			                 self
				                 addChild: ((BlOverlayElement on: element)
						                  clipChildren: false;
						                  addChild: tag)
				                 as: label asSymbol ].
		                 element children do: selectTargets ] ].

	aRootElement children do: selectTargets
]

{ #category : #processing }
GtNavigation >> nextClickTag [

	| tag |
	tag := (LeftHandKeys at: leftIndex) asString
	       , (RightHandKeys at: rightIndex) asString.
	leftIndex := leftIndex + 1.
	leftIndex > LeftHandKeys size ifTrue: [ 
		rightIndex := rightIndex + 1.
		leftIndex := 1 ].
	^ tag
]
