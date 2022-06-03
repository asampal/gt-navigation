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
		'inputStatus',
		'labelIndex'
	],
	#classVars : [
		'LabelSequence',
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

	LabelSequence := #( AA SS DD DE DC FF FT FG FV FR JJ JU JY JN JH
                     JM KK KI LL LO GG HH QQ WW EE RR TT YY UU II OO
                     PP VV BB NN MM CC XX FJ FK FL FY FU FI FO FP FH
                     FN FM DJ DK DL DY DU DI DO DP DH DN DM SJ SK SL
                     SY SU SI SO SP SH SN SM AJ AK AL AY AU AI AO AP
                     AH AN AM GJ GK GL GY GU GI GO GP GH GN GM TJ TK
                     TL TY TU TI TO TP TH TN TM EJ EK EL EY EU EI EO
                     EP EH EN EM WJ WK WL WY WU WI WO WP WH WN WM QJ
                     QK QL QY QU QI QO QP QH QN QM VJ VK VL VY VU VI
                     VO VP VH VN VM CJ CK CL CY CU CI CO CP CH CN CM
                     UF UD US UA UT UR UE UW UQ UG UB UV UC UX IF ID
                     IS IA IT IR IE IW IQ IG IB IV IC IX OF OD OS OA
                     OT OR OE OW OQ OB OV OC OX PF PD PS PA PT PR PE
                     PW PQ PB PV PC PX JF JD JS JA JT JR JE JW JQ JB
                     JV JC JX KF KD KS KA KT KR KE KW KQ KB KV KC KX
                     LF LD LS LA LT LR LE LW LQ LB LV LC LX 'Q;' 'W;' 'E;'
                     'R;' 'T;' 'Y;' 'U;' 'I;' 'O;' 'P;' 'A-' 'S-' 'D-' 'F-' 'G-' 'H-' 'J-' 'K-' 'L-').
	RightHandKeys := 'JKLHYUIOPNM,.'.
	LeftHandKeys := 'FDSAGTREWQBVCXZ'
]

{ #category : #accessing }
GtNavigation class >> labelSequence [

	^ LabelSequence
]

{ #category : #accessing }
GtNavigation class >> labelSequence: aSequence [
	aSequence ifNotNil: [ LabelSequence := aSequence ]
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
		  ifPresent: [ :tag | "If found, we still want to ensure it's attached to anElement" 
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
				self hideNavigation: false.
				tag simulateClickOnReference.
				overlays valuesDo: [ :aTag | aTag detach ] ] ]
]

{ #category : #accessing }
GtNavigation >> hideNavigation: clearCache [

	clearCache ifTrue: [ overlays valuesDo: [ :aTag | aTag detach ] ].
	self removeChildren.
	self parent removeChild: self
]

{ #category : #initialization }
GtNavigation >> initializeWith: aRootElement as: aName [

	super initialize.
	leftIndex := 1.
	rightIndex := 1.
	labelIndex := 1.
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

{ #category : #processing }
GtNavigation >> nextClickTag2 [
	| tag |
	tag := (LabelSequence at: labelIndex) asString.
	labelIndex := labelIndex + 1.
	labelIndex > LabelSequence size
		ifTrue: [ labelIndex := LabelSequence size.
			^ '--' asSymbol ].
	^ tag asSymbol
]

{ #category : #accessing }
GtNavigation >> setOverlays [
	| selectTargets label tag |
	selectTargets := [ :element | 
		element ~= self & element isVisibleInSpace
			ifTrue: [ (element isMemberOf: BrTab) | (element isKindOf: BrEditor)
					| (element isKindOf: BrButton) | (element isKindOf: BrTriangle)
					| (element isKindOf: BrExpander)
					ifTrue: [ label := self nextClickTag2.
						tag := self getTagElementFor: element label: label.
						self
							addChild: tag as: label;
							clipChildren: false ].
				element children do: selectTargets ] ].

	targetContainer children do: selectTargets
]
