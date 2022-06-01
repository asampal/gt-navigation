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

	self labelSequence: nil.
	RightHandKeys := 'JKLHYUIOPNM,.'.
	LeftHandKeys := 'FDSAGTREWQBVCXZ'
]

{ #category : #accessing }
GtNavigation class >> labelSequence [

	^ LabelSequence
]

{ #category : #accessing }
GtNavigation class >> labelSequence: aSequence [

	aSequence ifNil: ([ 
		 LabelSequence := #( a s d f j k l g h q w e r t y u i o p v b n m c
		                     x aa ss dd de dc ff ft fg fv fr jj ju jy jn jh
		                     jm kk ki ll lo gg hh qq ww ee rr tt yy uu ii oo
		                     pp vv bb nn mm cc xx fj fk fl fy fu fi fo fp fh
		                     fn fm dj dk dl dy du di do dp dh dn dm sj sk sl
		                     sy su si so sp sh sn sm aj ak al ay au ai ao ap
		                     ah an am gj gk gl gy gu gi go gp gh gn gm tj tk
		                     tl ty tu ti to tp th tn tm ej ek el ey eu ei eo
		                     ep eh en em wj wk wl wy wu wi wo wp wh wn wm qj
		                     qk ql qy qu qi qo qp qh qn qm vj vk vl vy vu vi
		                     vo vp vh vn vm cj ck cl cy cu ci co cp ch cn cm
		                     uf ud us ua ut ur ue uw uq ug ub uv uc ux if id
		                     is ia it ir ie iw iq ig ib iv ic ix of od os oa
		                     ot or oe ow oq ob ov oc ox pf pd ps pa pt pr pe
		                     pw pq pb pv pc px jf jd js ja jt jr je jw jq jb
		                     jv jc jx kf kd ks ka kt kr ke kw kq kb kv kc kx
		                     lf ld ls la lt lr le lw lq lb lv lc lx ) ] 
			 ifNotNil: [ LabelSequence := aSequence ])
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
	labelIndex = 1.
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
