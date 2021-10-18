Class {
	#name : #GtNavigationHideWish,
	#superclass : #BlEvent,
	#category : 'GToolkit-Navigation-Events'
}

{ #category : #sending }
GtNavigationHideWish >> sendTo: anObject [
	anObject hideNavigationEvent: self
]
