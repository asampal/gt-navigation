"
# Scene Navigation Event Handler

I am a key event filter added to, typically, the world's root element. 

When the ctrl + ; shortcut is pressed, I am added as a filter if not already present, or I am removed if there.

When I am added, I also create an instance of GtNavigation which is added as a child with ID NavigationId to the world's root element.

If a an alphabetic key is pressed while I am active, I ask the GtNavigation instance to handle it.

"
Class {
	#name : #GtNavigationEventFilter,
	#superclass : #BlCustomEventHandler,
	#classVars : [
		'NavigationId'
	],
	#category : #'GToolkit-Navigation-Navigation'
}

{ #category : #'class initialization' }
GtNavigationEventFilter class >> initialize [

	NavigationId := 'gtoolkit-navigation'
]

{ #category : #creation }
GtNavigationEventFilter >> createNavigationFor: aNavRootElement [

	| nav |
	nav := GtNavigation
		       rootedAt: aNavRootElement
		       as: NavigationId
		       withHandler: self.
	nav addEventHandler: GtNavigationEventHandler new.
	nav focused: true
	"aNavRootElement space focusOwner: nav"
]

{ #category : #'event handling' }
GtNavigationEventFilter >> eventsToHandle [

	^ { 
		  GtNavigationShowWish.
		  GtNavigationHideWish }
]

{ #category : #'UI - handling' }
GtNavigationEventFilter >> hideNavigation: aNavRootElement [

	aNavRootElement
		childWithId: NavigationId
		ifFound: [ :aNavigation | aNavigation hideNavigation ]
]

{ #category : #'event handling' }
GtNavigationEventFilter >> hideNavigationEvent: aHideNavigationEvent [
	self hideNavigation: aHideNavigationEvent currentTarget
]

{ #category : #'UI - handling' }
GtNavigationEventFilter >> hideOrShowNavigationFor: aNavRootElement [

	aNavRootElement
		childWithId: NavigationId
		ifFound: [ :aNavigation | aNavigation hideNavigation ]
		ifNone: [ self createNavigationFor: aNavRootElement ]
]

{ #category : #initialization }
GtNavigationEventFilter >> initialize [

	super initialize
]

{ #category : #'UI - handling' }
GtNavigationEventFilter >> showNavigation: aNavRootElement [

	Transcript crShow: 'Show Navigation'.
	aNavRootElement
		childWithId: NavigationId
		ifNone: [ self createNavigationFor: aNavRootElement ]
]

{ #category : #'event handling' }
GtNavigationEventFilter >> showNavigationEvent: aShowNavigationEvent [

	aShowNavigationEvent consumed: true.
	self showNavigation: aShowNavigationEvent currentTarget
]
