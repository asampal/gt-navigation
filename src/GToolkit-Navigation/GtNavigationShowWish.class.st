"
Fire the ""scene navigation show wish"" from withing the graphical scene whose root has {{gtClass:GtNavigationEventHandler}} event handler to transform the scene into debug mode

"
Class {
	#name : #GtNavigationShowWish,
	#superclass : #BlEvent,
	#instVars : [
		'elementToSelect',
		'sceneExtent'
	],
	#category : 'GToolkit-Navigation-Events'
}

{ #category : #accessing }
GtNavigationShowWish >> elementToSelect [
	^ elementToSelect
]

{ #category : #accessing }
GtNavigationShowWish >> elementToSelect: anObject [
	elementToSelect := anObject
]

{ #category : #accessing }
GtNavigationShowWish >> sceneExtent [
	^ sceneExtent
]

{ #category : #accessing }
GtNavigationShowWish >> sceneExtent: anObject [
	sceneExtent := anObject
]

{ #category : #sending }
GtNavigationShowWish >> sendTo: anObject [
	anObject showNavigationEvent: self
]
