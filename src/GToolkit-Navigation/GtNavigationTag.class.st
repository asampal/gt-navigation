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
				geometry: BlCircleGeometry new;
				background: BrTheme default button textHighlightColor;
				addChild: (BlAttributedTextElement new
						text: aLabel asRopedText;
						bold;
						fontSize: 11;
						constraintsDo: [ :c | 
							c ignoreByLayout.
							c ignored horizontal alignCenter.
							c ignored vertical alignCenter ]));
		clipChildren: false
]

{ #category : #'event handling' }
GtNavigationTag >> simulateClickOnReference [

	BlSpace simulateClickOn: referenceElement.
	"For editors, we need to do two clicks otherwise they aren't focused"
	(referenceElement isKindOf: BrEditor) ifTrue: [ 
		[ 250 milliseconds wait ] asAsyncFuture wait.
		BlSpace simulateClickOn: referenceElement ]
]
