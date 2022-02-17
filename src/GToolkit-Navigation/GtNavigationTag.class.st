Class {
	#name : #GtNavigationTag,
	#superclass : #BlOverlayElement,
	#category : #'GToolkit-Navigation-UI'
}

{ #category : #'instace creation' }
GtNavigationTag class >> on: anElement labeledAs: aLabel [

	^ (self new attachTo: anElement) 
		  setLabeledContent: aLabel
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
]

{ #category : #'event handling' }
GtNavigationTag >> simulateClickOnReference [

	BlSpace simulateClickOn: referenceElement.
	"For editors, we need to do two clicks otherwise they aren't focused"
	(referenceElement isKindOf: BrEditor) ifTrue: [ 
		BlSpace simulateClickOn: referenceElement ]
]
