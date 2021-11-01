Class {
	#name : #GtNavigationTag,
	#superclass : #BlOverlayElement,
	#instVars : [
		'navigationHandler'
	],
	#category : #'GToolkit-Navigation-UI'
}

{ #category : #'instace creation' }
GtNavigationTag class >> on: anElement labeledAs: aLabel withHandler: anEventHandler [

	^ (self new attachTo: anElement) 
		  setLabeledContent: aLabel
]

{ #category : #'instace creation' }
GtNavigationTag >> attachTo: anElement withHandler: anEventHandler [

	referenceElement = anElement ifTrue: [ ^ self ].

	self isAttached ifTrue: [ self detach ].

	navigationHandler := anEventHandler.
	referenceElement := anElement.
	anElement addEventHandler: overlayListener.
	anElement addEventHandler: anEventHandler
]

{ #category : #accessing }
GtNavigationTag >> detach [

	self isAttached ifFalse: [ ^ self ].

	referenceElement removeEventHandler: overlayListener.
	referenceElement removeEventHandler: navigationHandler.
	referenceElement := nil
]

{ #category : #accessing }
GtNavigationTag >> setLabeledContent: aLabel [

	self
		addChild: (BlElement new
				 constraintsDo: [ :c | 
					 c ignoreByLayout.
					 c ignored horizontal alignCenter.
					 c ignored vertical alignCenter ];
				 size: 20 @ 20;
				 elevation: (BlRelativeElevation elevation: 10);
				 geometry: BlCircleGeometry new;
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
								   text: aLabel)));
		clipChildren: false
	"constraintsDo: [ :c |
					     	c ignoreByLayout. 
						     c horizontal alignCenter.
						     c vertical alignCenter ];"
]

{ #category : #'event handling' }
GtNavigationTag >> simulateClickOnReference [

	BlSpace simulateClickOn: referenceElement
]
